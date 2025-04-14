from rest_framework import viewsets, permissions, status
from rest_framework.decorators import action
from rest_framework.response import Response
from .models import Product, Conversation, Message, Offer, Order
from .serializers import (
    ProductSerializer, ConversationSerializer, 
    ConversationDetailSerializer, MessageSerializer,
    MessageDetailSerializer, OfferSerializer, OrderSerializer
)
from django.db.models import Q
from django.contrib.auth.models import User

class ProductViewSet(viewsets.ModelViewSet):
    queryset = Product.objects.all()
    serializer_class = ProductSerializer
    permission_classes = [permissions.IsAuthenticated]
    
    def perform_create(self, serializer):
        serializer.save(seller=self.request.user)
    
    def get_queryset(self):
        queryset = Product.objects.all()
        
        # Filter by seller if requested
        seller_id = self.request.query_params.get('seller')
        if seller_id:
            queryset = queryset.filter(seller_id=seller_id)
            
        return queryset

class ConversationViewSet(viewsets.ModelViewSet):
    serializer_class = ConversationSerializer
    permission_classes = [permissions.IsAuthenticated]
    
    def get_queryset(self):
        return Conversation.objects.filter(
            participants=self.request.user
        ).order_by('-updated_at')
    
    def retrieve(self, request, *args, **kwargs):
        instance = self.get_object()
        serializer = ConversationDetailSerializer(instance)
        return Response(serializer.data)
    
    @action(detail=False, methods=['post'])
    def start(self, request):
        other_user_id = request.data.get('user_id')
        if not other_user_id:
            return Response({'error': 'User ID is required'}, status=status.HTTP_400_BAD_REQUEST)
        
        try:
            other_user = User.objects.get(id=other_user_id)
        except User.DoesNotExist:
            return Response({'error': 'User not found'}, status=status.HTTP_404_NOT_FOUND)
        
        # Check if conversation already exists
        conversations = Conversation.objects.filter(
            participants=request.user
        ).filter(
            participants=other_user
        )
        
        if conversations.exists():
            serializer = self.get_serializer(conversations.first())
            return Response(serializer.data)
        
        # Create new conversation
        conversation = Conversation.objects.create()
        conversation.participants.add(request.user, other_user)
        serializer = self.get_serializer(conversation)
        return Response(serializer.data, status=status.HTTP_201_CREATED)

class MessageViewSet(viewsets.ModelViewSet):
    serializer_class = MessageSerializer
    permission_classes = [permissions.IsAuthenticated]
    
    def get_queryset(self):
        conversation_id = self.request.query_params.get('conversation')
        if conversation_id:
            return Message.objects.filter(conversation_id=conversation_id).order_by('created_at')
        return Message.objects.none()
    
    def perform_create(self, serializer):
        serializer.save(sender=self.request.user)
        
        # Update conversation timestamp
        conversation = serializer.validated_data['conversation']
        conversation.save()  # This will update the updated_at field

class OfferViewSet(viewsets.ModelViewSet):
    serializer_class = OfferSerializer
    permission_classes = [permissions.IsAuthenticated]
    
    def get_queryset(self):
        return Offer.objects.filter(
            Q(buyer=self.request.user) | Q(product__seller=self.request.user)
        ).order_by('-created_at')
    
    def perform_create(self, serializer):
        # Create the message first
        conversation = serializer.validated_data['conversation']
        product = serializer.validated_data['product']
        amount = serializer.validated_data['amount']
        
        # Make sure user is part of the conversation
        if not conversation.participants.filter(id=self.request.user.id).exists():
            raise serializers.ValidationError("You are not part of this conversation")
        
        # Create the message
        message = Message.objects.create(
            conversation=conversation,
            sender=self.request.user,
            text=f"I'd like to offer {amount} for {product.name}"
        )
        
        # Create the offer
        serializer.save(buyer=self.request.user, message=message)
    
    @action(detail=True, methods=['post'])
    def respond(self, request, pk=None):
        offer = self.get_object()
        response = request.data.get('response')
        
        # Check if the user is the seller
        if offer.product.seller != request.user:
            return Response({'error': 'Only the seller can respond to this offer'}, 
                           status=status.HTTP_403_FORBIDDEN)
        
        if response not in ['ACCEPTED', 'REJECTED']:
            return Response({'error': 'Response must be ACCEPTED or REJECTED'}, 
                           status=status.HTTP_400_BAD_REQUEST)
        
        # Update offer status
        offer.status = response
        offer.save()
        
        # Create a response message
        Message.objects.create(
            conversation=offer.conversation,
            sender=request.user,
            text=f"Your offer of {offer.amount} for {offer.product.name} has been {response.lower()}"
        )
        
        # If accepted, create an order
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
    permission_classes = [permissions.IsAuthenticated]
    
    def get_queryset(self):
        return Order.objects.filter(
            Q(buyer=self.request.user) | Q(seller=self.request.user)
        ).order_by('-created_at')
    
    @action(detail=True, methods=['post'])
    def update_status(self, request, pk=None):
        order = self.get_object()
        new_status = request.data.get('status')
        
        # Validate the user has permission to update
        if order.seller != request.user and order.buyer != request.user:
            return Response({'error': 'You do not have permission to update this order'}, 
                          status=status.HTTP_403_FORBIDDEN)
        
        # Only seller can mark as shipped
        if new_status == 'SHIPPED' and order.seller != request.user:
            return Response({'error': 'Only the seller can mark an order as shipped'}, 
                          status=status.HTTP_403_FORBIDDEN)
        
        # Only buyer can mark as delivered
        if new_status == 'DELIVERED' and order.buyer != request.user:
            return Response({'error': 'Only the buyer can mark an order as delivered'}, 
                          status=status.HTTP_403_FORBIDDEN)
        
        order.status = new_status
        order.save()
        
        serializer = self.get_serializer(order)
        return Response(serializer.data)