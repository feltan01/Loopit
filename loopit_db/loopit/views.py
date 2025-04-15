from rest_framework import viewsets, status, permissions
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework.parsers import MultiPartParser, FormParser
from django.contrib.auth import authenticate
from django.shortcuts import get_object_or_404
from .models import LoopitUser, Profile, Listing, ListingImage
from .serializers import UserSignUpSerializer, UserLoginSerializer, ProfileSerializer, ListingSerializer, ListingImageSerializer, PasswordResetSerializer, SetNewPasswordSerializer

class UserViewSet(viewsets.ModelViewSet):
    queryset = LoopitUser.objects.all()
    permission_classes = [AllowAny]

    def get_serializer_class(self):
        if self.action == 'signup':
            return UserSignUpSerializer
        return UserLoginSerializer

    @action(detail=False, methods=['POST'], permission_classes=[AllowAny])
    def signup(self, request):
        serializer = UserSignUpSerializer(data=request.data)
        if serializer.is_valid():
            user = serializer.save()
            refresh = RefreshToken.for_user(user)
            return Response({
                'message': 'User registered successfully',
                'user_id': user.id,
                'email': user.email,
                'refresh': str(refresh),
                'access': str(refresh.access_token),
            }, status=status.HTTP_201_CREATED)
        
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    @action(detail=False, methods=['POST'], permission_classes=[AllowAny])
    def login(self, request):
        serializer = UserLoginSerializer(data=request.data)
        if serializer.is_valid():
            email = serializer.validated_data['email']
            password = serializer.validated_data['password']

            # Custom authentication via email
            try:
                user = LoopitUser.objects.get(email=email)
            except LoopitUser.DoesNotExist:
                return Response({'error': 'Email tidak ditemukan'}, status=status.HTTP_404_NOT_FOUND)

            user = authenticate(request, email=email, password=password)  # custom user uses email

            if user:
                refresh = RefreshToken.for_user(user)
                return Response({
                    'message': 'Login successful',
                    'user_id': user.id,
                    'email': user.email,
                    'username': user.username, 
                    'refresh': str(refresh),
                    'access': str(refresh.access_token),
                }, status=status.HTTP_200_OK)

            return Response({'error': 'Password salah'}, status=status.HTTP_401_UNAUTHORIZED)

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    # Forgot Password
    @action(detail=False, methods=['POST'], permission_classes=[AllowAny])
    def forgot_password(self, request):
        serializer = PasswordResetSerializer(data=request.data)
        if serializer.is_valid():
            response = serializer.save()
            return Response(response, status=status.HTTP_200_OK)
        
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    # Reset Password
    @action(detail=False, methods=['POST'], permission_classes=[AllowAny])
    def reset_password(self, request):
        serializer = SetNewPasswordSerializer(data=request.data)
        if serializer.is_valid():
            response = serializer.save()
            return Response(response, status=status.HTTP_200_OK)
        
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

# ... (imports tetap sama)

class ProfileViewSet(viewsets.ModelViewSet):
    queryset = Profile.objects.all()
    serializer_class = ProfileSerializer
    permission_classes = [IsAuthenticated]

    def retrieve(self, request, pk=None):
        try:
            profile = Profile.objects.get(user=request.user)
            serializer = self.get_serializer(profile)
            return Response(serializer.data)
        except Profile.DoesNotExist:
            return Response({'error': 'Profile not found'}, status=status.HTTP_404_NOT_FOUND)

    def update(self, request, pk=None):
        try:
            profile = Profile.objects.get(user=request.user)
            serializer = self.get_serializer(profile, data=request.data, partial=True)
            if serializer.is_valid():
                serializer.save()
                return Response(serializer.data)
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        except Profile.DoesNotExist:
            return Response({'error': 'Profile not found'}, status=status.HTTP_404_NOT_FOUND)

    @action(detail=False, methods=['get'], permission_classes=[IsAuthenticated])
    def me(self, request):
        try:
            profile = Profile.objects.get(user=request.user)
            serializer = self.get_serializer(profile)
            return Response(serializer.data)
        except Profile.DoesNotExist:
            return Response({'error': 'Profile not found'}, status=status.HTTP_404_NOT_FOUND)  

class ListingViewSet(viewsets.ModelViewSet):
    queryset = Listing.objects.all()
    serializer_class = ListingSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        queryset = Listing.objects.all()
        category = self.request.query_params.get('category', None)
        if category:
            queryset = queryset.filter(category=category)
        return queryset

    def perform_create(self, serializer):
        serializer.save(owner=self.request.user)

    @action(detail=True, methods=['post'], parser_classes=[MultiPartParser, FormParser])
    def upload_images(self, request, pk=None):
        listing = self.get_object()

        current_count = listing.images.count()
        if current_count >= 10:
            return Response(
                {"detail": "Maximum 10 images allowed per listing."},
                status=status.HTTP_400_BAD_REQUEST
            )

        images = request.FILES.getlist('images')
        if current_count + len(images) > 10:
            return Response(
                {"detail": f"You can only add {10 - current_count} more images."},
                status=status.HTTP_400_BAD_REQUEST
            )

        for image in images:
            ListingImage.objects.create(listing=listing, image=image)

        serializer = self.get_serializer(listing)
        return Response(serializer.data)

    @action(detail=False, methods=['get'])
    def my_listings(self, request):
        listings = Listing.objects.filter(owner=request.user)
        serializer = self.get_serializer(listings, many=True)
        return Response(serializer.data)
