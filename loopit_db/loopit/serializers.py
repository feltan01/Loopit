from rest_framework import serializers
from django.contrib.auth import get_user_model
from .models import Profile
from .models import Listing, ListingImage

User = get_user_model()

# Serializer untuk Registrasi
class UserSignUpSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)

    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'phone_number', 'password']
        extra_kwargs = {
            'password': {'write_only': True}
        }

    def create(self, validated_data):
        user = User.objects.create_user(
            username=validated_data['username'],
            email=validated_data['email'],
            password=validated_data['password'],
            phone_number=validated_data.get('phone_number', '')
        )
        return user


# Serializer untuk Login
class UserLoginSerializer(serializers.Serializer):
    email = serializers.EmailField()
    password = serializers.CharField(write_only=True)


# Serializer untuk Profil
class ProfileSerializer(serializers.ModelSerializer):
    user = UserSignUpSerializer(read_only=True)
    
    class Meta:
        model = Profile
        fields = ['user', 'bio', 'profile_picture']
        

class ListingImageSerializer(serializers.ModelSerializer):
    class Meta:
        model = ListingImage
        fields = ['id', 'image', 'uploaded_at']


class ListingSerializer(serializers.ModelSerializer):
    images = ListingImageSerializer(many=True, read_only=True)
    
    class Meta:
        model = Listing
        fields = ['id', 'title', 'price', 'category', 'condition', 
                  'description', 'product_age', 'owner', 'created_at', 
                  'updated_at', 'images']
        read_only_fields = ['owner', 'created_at', 'updated_at']
    
    def create(self, validated_data):
        # Assign the current user as the owner
        user = self.context['request'].user
        listing = Listing.objects.create(owner=user, **validated_data)
        return listing
