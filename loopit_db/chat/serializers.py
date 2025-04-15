from rest_framework import serializers
from .models import Product, Conversation, Message, Offer, Order
from django.contrib.auth.models import User

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'username', 'email']

class ProductSerializer(serializers.ModelSerializer):
    seller = UserSerializer(read_only=True)
    
    class Meta:
        model = Product
        fields = ['id', 'name', 'brand', 'price', 'description', 'seller', 'image', 'created_at']

class MessageSerializer(serializers.ModelSerializer):
    sender = UserSerializer(read_only=True)
    
    class Meta:
        model = Message
        fields = ['id', 'conversation', 'sender', 'text', 'created_at']

class OfferSerializer(serializers.ModelSerializer):
    product = ProductSerializer(read_only=True)
    buyer = UserSerializer(read_only=True)
    
    class Meta:
        model = Offer
        fields = ['id', 'conversation', 'message', 'product', 'buyer', 'amount', 'status', 'created_at']

class MessageDetailSerializer(serializers.ModelSerializer):
    sender = UserSerializer(read_only=True)
    offer = OfferSerializer(read_only=True)
    
    class Meta:
        model = Message
        fields = ['id', 'conversation', 'sender', 'text', 'created_at', 'offer']

class ConversationSerializer(serializers.ModelSerializer):
    participants = UserSerializer(many=True, read_only=True)
    last_message = serializers.SerializerMethodField()
    
    class Meta:
        model = Conversation
        fields = ['id', 'participants', 'created_at', 'updated_at', 'last_message']
        
    def get_last_message(self, obj):
        last_msg = obj.messages.order_by('-created_at').first()
        if last_msg:
            return MessageSerializer(last_msg).data
        return None

class ConversationDetailSerializer(serializers.ModelSerializer):
    participants = UserSerializer(many=True, read_only=True)
    messages = MessageDetailSerializer(many=True, read_only=True)
    
    class Meta:
        model = Conversation
        fields = ['id', 'participants', 'messages', 'created_at', 'updated_at']

class OrderSerializer(serializers.ModelSerializer):
    buyer = UserSerializer(read_only=True)
    seller = UserSerializer(read_only=True)
    product = ProductSerializer(read_only=True)
    
    class Meta:
        model = Order
        fields = ['id', 'offer', 'buyer', 'seller', 'product', 'amount', 'status', 'created_at', 'updated_at']