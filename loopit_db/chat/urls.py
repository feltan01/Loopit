from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import ProductViewSet, ConversationViewSet, MessageViewSet, OfferViewSet, OrderViewSet

router = DefaultRouter()
router.register(r'products', ProductViewSet, basename='product')
router.register(r'conversations', ConversationViewSet, basename='conversation')
router.register(r'messages', MessageViewSet, basename='message')
router.register(r'offers', OfferViewSet, basename='offer')
router.register(r'orders', OrderViewSet, basename='order')

urlpatterns = [
    path('', include(router.urls)),  # Includes all default router URLs for the second app
]
