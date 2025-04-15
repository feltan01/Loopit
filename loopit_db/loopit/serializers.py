from rest_framework import serializers
from django.contrib.auth import get_user_model
from django.contrib.auth.tokens import default_token_generator
from django.utils.http import urlsafe_base64_encode, urlsafe_base64_decode
from django.core.mail import send_mail
from django.utils.encoding import force_bytes
from .models import Profile, Listing, ListingImage

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
    password = serializers.CharField(write_only=True, trim_whitespace=False)

    def validate(self, data):
        email = data.get('email')
        password = data.get('password')

        if not email or not password:
            raise serializers.ValidationError("Email dan password wajib diisi.")
        
        return data


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
        user = self.context['request'].user
        listing = Listing.objects.create(owner=user, **validated_data)
        return listing


# Serializer untuk Forgot Password (Email Gimmick + Return Token/UID)
class PasswordResetSerializer(serializers.Serializer):
    email = serializers.EmailField()

    def validate_email(self, value):
        try:
            user = User.objects.get(email=value)
        except User.DoesNotExist:
            raise serializers.ValidationError("Email tidak terdaftar.")
        return value

    def save(self):
        email = self.validated_data['email']
        user = User.objects.get(email=email)

        # Generate token & UID
        token = default_token_generator.make_token(user)
        uid = urlsafe_base64_encode(force_bytes(user.pk))

        # Kirim email gimmick
        reset_link = f"http://example.com/reset-password/{uid}/{token}/"
        subject = "Password Reset Request"
        message = (
            f"Hi, kamu baru saja meminta reset password.\n\n"
            f"Kalau kamu sedang menggunakan aplikasi Loopit, kamu bisa abaikan email ini.\n"
            f"Kalau perlu, berikut link reset password-nya: {reset_link}\n\n"
            f"Terima kasih 🙌"
        )

        try:
            send_mail(subject, message, 'no-reply@example.com', [email])
        except Exception as e:
            print(f"Email sending failed (dev mode): {e}")

        # Kembalikan UID dan Token ke frontend
        return {
            'message': "Token reset berhasil dikirim ke email Anda.",
            'uid': str(uid),
            'token': str(token)
        }


# Serializer untuk Reset Password
class SetNewPasswordSerializer(serializers.Serializer):
    password = serializers.CharField(write_only=True)
    token = serializers.CharField()
    uid = serializers.CharField()

    def validate(self, data):
        try:
            uid = urlsafe_base64_decode(data['uid']).decode()
            user = User.objects.get(pk=uid)
        except (User.DoesNotExist, ValueError, TypeError):
            raise serializers.ValidationError("User tidak ditemukan.")

        if not default_token_generator.check_token(user, data['token']):
            raise serializers.ValidationError("Token tidak valid atau telah kedaluwarsa.")

        return data

    def save(self):
        uid = urlsafe_base64_decode(self.validated_data['uid']).decode()
        user = User.objects.get(pk=uid)
        password = self.validated_data['password']

        user.set_password(password)
        user.save()

        return {
            'message': "Password Anda berhasil diubah."
        }
