from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import UserViewSet, ProfileViewSet
from rest_framework_simplejwt.views import (
    TokenObtainPairView,
    TokenRefreshView,
)
from .views import UserViewSet, ProfileViewSet

router = DefaultRouter()
router.register(r'users', UserViewSet, basename='user')
router.register(r'profiles', ProfileViewSet, basename='profile')


urlpatterns = [
    path('', include(router.urls)),
    path('token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('signup/', UserViewSet.as_view({'post': 'signup'}), name='signup'),
    path('login/', UserViewSet.as_view({'post': 'login'}), name='login'),
]