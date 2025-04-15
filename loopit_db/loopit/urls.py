from django.urls import path, include
from rest_framework.routers import DefaultRouter
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView
from .views import UserViewSet, ProfileViewSet, ListingViewSet

router = DefaultRouter()
router.register(r'users', UserViewSet, basename='user')
router.register(r'profiles', ProfileViewSet, basename='profile')
router.register(r'listings', ListingViewSet, basename='listing')

urlpatterns = [
    path('', include(router.urls)),

    # JWT Token Endpoints
    path('token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),

    # Custom User Actions (handled via UserViewSet)
    path('signup/', UserViewSet.as_view({'post': 'signup'}), name='signup'),
    path('login/', UserViewSet.as_view({'post': 'login'}), name='login'),
    path('password/request-reset/', UserViewSet.as_view({'post': 'forgot_password'}), name='request-reset'),
    path('password/reset/', UserViewSet.as_view({'post': 'reset_password'}), name='reset-password'),
]
