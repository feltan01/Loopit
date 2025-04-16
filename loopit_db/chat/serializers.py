from rest_framework import serializers
from .models import Product, Conversation, Message, Offer, Order
from django.contrib.auth import get_user_model
from django.db.models import Q

User = get_user_model()

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'username', 'email']

class ProductSerializer(serializers.ModelSerializer):
    seller = UserSerializer(read_only=True)
    
    class Meta:
        model = Product
        fields = ['id', 'name', 'brand', 'price', 'description', 'seller', 'image', 'created_at']
        
    def to_representation(self, instance):
        representation = super().to_representation(instance)
        if instance.seller is None:
            representation['seller'] = None
        return representation

class MessageSerializer(serializers.ModelSerializer):
    sender = UserSerializer(read_only=True)
    
    class Meta:
        model = Message
        fields = ['id', 'conversation', 'sender', 'text', 'created_at']
        
    def create(self, validated_data):
        if 'conversation' not in validated_data or not validated_data['conversation']:
            raise serializers.ValidationError({'conversation': 'This field is required'})
            
        if 'sender' not in validated_data or not validated_data['sender']:
            request = self.context.get('request')
            if not request or not request.user or not request.user.is_authenticated:
                raise serializers.ValidationError({'sender': 'A valid sender is required'})
            validated_data['sender'] = request.user
            
        return super().create(validated_data)

class OfferSerializer(serializers.ModelSerializer):
    class Meta:
        model = Offer
        fields = ['id', 'conversation', 'message', 'product', 'buyer', 'amount', 'status', 'created_at']
        read_only_fields = ['message', 'buyer']

    def to_representation(self, instance):
        rep = super().to_representation(instance)
        rep['buyer'] = {
            "id": instance.buyer.id,
            "username": instance.buyer.username,
            "email": instance.buyer.email
        } if instance.buyer else None
        rep['product'] = {
            "id": instance.product.id,
            "name": instance.product.name,
            "brand": instance.product.brand,
            "price": str(instance.product.price),
            "seller": {
                "id": instance.product.seller.id,
                "username": instance.product.seller.username,
                "email": instance.product.seller.email
            } if instance.product.seller else None
        } if instance.product else None
        return rep

    def create(self, validated_data):
        request = self.context.get('request')
        if request and request.user and request.user.is_authenticated:
            validated_data['buyer'] = request.user
        else:
            buyer = User.objects.first()
            if buyer:
                validated_data['buyer'] = buyer
            else:
                raise serializers.ValidationError("No user available to assign as buyer")
        
        return super().create(validated_data)

class MessageDetailSerializer(serializers.ModelSerializer):
    sender = UserSerializer(read_only=True)
    offer = serializers.SerializerMethodField()
    
    class Meta:
        model = Message
        fields = ['id', 'conversation', 'sender', 'text', 'created_at', 'offer']
        
    def get_offer(self, obj):
        try:
            offer = Offer.objects.filter(message=obj).first()
            if offer:
                return OfferSerializer(offer).data
            return None
        except:
            return None

class ConversationSerializer(serializers.ModelSerializer):
    participants = UserSerializer(many=True, read_only=True)
    last_message = serializers.SerializerMethodField()
    unread_count = serializers.SerializerMethodField()
    
    class Meta:
        model = Conversation
        fields = ['id', 'participants', 'created_at', 'updated_at', 'last_message', 'unread_count']
        
    def get_last_message(self, obj):
        last_msg = obj.messages.order_by('-created_at').first()
        if last_msg:
            return MessageSerializer(last_msg).data
        return None
        
    def get_unread_count(self, obj):
        request = self.context.get('request')
        if not request or not request.user or not request.user.is_authenticated:
            return 0
            
        user = request.user
        return obj.messages.filter(read=False).exclude(sender=user).count()

class ConversationDetailSerializer(serializers.ModelSerializer):
    participants = UserSerializer(many=True, read_only=True)
    messages = serializers.SerializerMethodField()
    
    class Meta:
        model = Conversation
        fields = ['id', 'participants', 'messages', 'created_at', 'updated_at']
        
    def get_messages(self, obj):
        messages = obj.messages.all().order_by('created_at')
        return MessageDetailSerializer(messages, many=True, context=self.context).data

class OrderSerializer(serializers.ModelSerializer):
    buyer = UserSerializer(read_only=True)
    seller = UserSerializer(read_only=True)
    product = ProductSerializer(read_only=True)
    
    class Meta:
        model = Order
        fields = ['id', 'offer', 'buyer', 'seller', 'product', 'amount', 'status', 'created_at', 'updated_at']