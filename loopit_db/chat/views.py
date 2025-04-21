from django.utils import timezone
from rest_framework import viewsets, permissions, status, serializers
from rest_framework.decorators import action
from rest_framework.response import Response
from .models import Product, Conversation, Message, Offer, Order
from .serializers import (
    ProductSerializer, ConversationSerializer, 
    ConversationDetailSerializer, MessageSerializer,
    MessageDetailSerializer, OfferSerializer, OrderSerializer, UserSerializer
)
from django.db.models import Q
from django.contrib.auth import get_user_model

User = get_user_model()
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from rest_framework_simplejwt.authentication import JWTAuthentication


class UserInfoView(APIView):
    permission_classes = [IsAuthenticated]
    authentication_classes = [JWTAuthentication]
    
    def get(self, request):
        serializer = UserSerializer(request.user)
        return Response(serializer.data)


class ProductViewSet(viewsets.ModelViewSet):
    queryset = Product.objects.all()
    serializer_class = ProductSerializer
    # permission_classes = [permissions.IsAuthenticated]

    def perform_create(self, serializer):
        if not self.request.user.is_authenticated:
            raise serializers.ValidationError("Authentication required to create a product")
        
        serializer.save(seller=self.request.user)

    def get_queryset(self):
        queryset = Product.objects.filter(seller__isnull=False)
        
        seller_id = self.request.query_params.get('seller')
        if seller_id:
            queryset = queryset.filter(seller_id=seller_id)
            
        return queryset


class ConversationViewSet(viewsets.ModelViewSet):
    serializer_class = ConversationSerializer
    permission_classes = [permissions.AllowAny]  # Allow any user to access this endpoint
    
    def get_queryset(self):
        if self.request.user.is_authenticated:
            return Conversation.objects.filter(participants=self.request.user).order_by('-updated_at')
        
        # Return all conversations if the user is not authenticated
        return Conversation.objects.all()  # Adjust this based on your requirements
    
    def retrieve(self, request, *args, **kwargs):
        instance = self.get_object()
        
        if request.user.is_authenticated:
            serializer = ConversationDetailSerializer(instance)
        else:
            serializer = ConversationSerializer(instance)
        
        return Response(serializer.data)

    def get_serializer_context(self):
        context = super().get_serializer_context()
        context['request'] = self.request
        return context
        
    @action(detail=False, methods=['post'])
    def start(self, request):
        if not request.user.is_authenticated:
            return Response({'error': 'Authentication required to start a conversation.'}, 
                           status=status.HTTP_401_UNAUTHORIZED)
            
        other_user_id = request.data.get('user_id')
        if not other_user_id:
            return Response({'error': 'User ID is required'}, status=status.HTTP_400_BAD_REQUEST)
        
        try:
            other_user = User.objects.get(id=other_user_id)
        except User.DoesNotExist:
            return Response({'error': 'User not found'}, status=status.HTTP_404_NOT_FOUND)
        
        conversations = Conversation.objects.filter(
            participants=request.user
        ).filter(
            participants=other_user
        )
        
        if conversations.exists():
            serializer = self.get_serializer(conversations.first())
            return Response(serializer.data)
        
        conversation = Conversation.objects.create()
        conversation.participants.add(request.user, other_user)
        serializer = self.get_serializer(conversation)
        return Response(serializer.data, status=status.HTTP_201_CREATED)


class MessageViewSet(viewsets.ModelViewSet):
    serializer_class = MessageSerializer
    permission_classes = [permissions.AllowAny]
    
    def get_queryset(self):
        conversation_id = self.request.query_params.get('conversation')
        if conversation_id:
            return Message.objects.filter(conversation_id=conversation_id).order_by('created_at')
        return Message.objects.none()
    
    def create(self, request, *args, **kwargs):
        if not request.user.is_authenticated:
            return Response({'error': 'Authentication required to send messages.'}, 
                           status=status.HTTP_401_UNAUTHORIZED)
        
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        conversation_id = request.data.get('conversation')
        try:
            conversation = Conversation.objects.get(id=conversation_id)
        except Conversation.DoesNotExist:
            return Response(
                {"error": "Conversation not found"},
                status=status.HTTP_404_NOT_FOUND
            )
        
        message = Message.objects.create(
            conversation=conversation,
            sender=request.user,
            text=serializer.validated_data.get('text')
        )
        
        conversation.updated_at = timezone.now()
        conversation.save()
        
        result = MessageSerializer(message)
        return Response(result.data, status=status.HTTP_201_CREATED)


class OfferViewSet(viewsets.ModelViewSet):
    serializer_class = OfferSerializer
    # permission_classes = [permissions.IsAuthenticated]
    
    def get_queryset(self):
        if not self.request.user.is_authenticated:
            return Offer.objects.none()
            
        conversation_id = self.request.query_params.get('conversation')
        if conversation_id:
            return Offer.objects.filter(conversation_id=conversation_id).order_by('created_at')
        return Offer.objects.filter(Q(buyer=self.request.user) | 
                                    Q(product__seller=self.request.user)).order_by('-created_at')
        
    def perform_create(self, serializer):
        if not self.request.user.is_authenticated:
            raise serializers.ValidationError("Authentication required to create an offer")
        
        conversation = serializer.validated_data['conversation']
        product = serializer.validated_data['product']
        amount = serializer.validated_data['amount']
        
        # Debug print statements
        print("Current User:", self.request.user)
        print("Conversation Participants:", list(conversation.participants.all()))
        print("Is user in participants:", conversation.participants.filter(id=self.request.user.id).exists())
        
        if not conversation.participants.filter(id=self.request.user.id).exists():
            # Automatically add the user to the conversation if not already a participant
            conversation.participants.add(self.request.user)
        
        message = Message.objects.create(
            conversation=conversation,
            sender=self.request.user,
            text=f"I'd like to offer {amount} for {product.name}"
        )
        
        conversation.updated_at = timezone.now()
        conversation.save()
        
        serializer.save(buyer=self.request.user, message=message)
    
    @action(detail=True, methods=['post'])
    def respond(self, request, pk=None):
        if not request.user.is_authenticated:
            return Response({'error': 'Authentication required to respond to an offer.'}, 
                           status=status.HTTP_401_UNAUTHORIZED)
                           
        offer = self.get_object()
        response = request.data.get('response')
        
        if offer.product.seller != request.user:
            return Response({'error': 'Only the seller can respond to this offer'}, 
                           status=status.HTTP_403_FORBIDDEN)
        
        if response not in ['ACCEPTED', 'REJECTED']:
            return Response({'error': 'Response must be ACCEPTED or REJECTED'}, 
                           status=status.HTTP_400_BAD_REQUEST)
        
        offer.status = response
        offer.save()
        
        Message.objects.create(
            conversation=offer.conversation,
            sender=request.user,
            text=f"Your offer of {offer.amount} for {offer.product.name} has been {response.lower()}"
        )
        
        if response == 'ACCEPTED':
            Order.objects.create(
                offer=offer,
                buyer=offer.buyer,
                seller=request.user,
                product=offer.product,
                amount=offer.amount
            )
        
        serializer = self.get_serializer(offer)
        return Response(serializer.data)


class OrderViewSet(viewsets.ModelViewSet):
    serializer_class = OrderSerializer
    # permission_classes = [permissions.IsAuthenticated]
    
    def get_queryset(self):
        if not self.request.user.is_authenticated:
            return Order.objects.none()
            
        return Order.objects.filter(
            Q(buyer=self.request.user) | Q(seller=self.request.user)
        ).order_by('-created_at')
    
    @action(detail=True, methods=['post'])
    def update_status(self, request, pk=None):
        if not request.user.is_authenticated:
            return Response({'error': 'Authentication required to update order status.'}, 
                           status=status.HTTP_401_UNAUTHORIZED)
                           
        order = self.get_object()
        new_status = request.data.get('status')
        
        if order.seller != request.user and order.buyer != request.user:
            return Response({'error': 'You do not have permission to update this order'}, 
                          status=status.HTTP_403_FORBIDDEN)
        
        if new_status == 'SHIPPED' and order.seller != request.user:
            return Response({'error': 'Only the seller can mark an order as shipped'}, 
                          status=status.HTTP_403_FORBIDDEN)
        
        if new_status == 'DELIVERED' and order.buyer != request.user:
            return Response({'error': 'Only the buyer can mark an order as delivered'}, 
                          status=status.HTTP_403_FORBIDDEN)
        
        order.status = new_status
        order.save()
        
        serializer = self.get_serializer(order)
        return Response(serializer.data)