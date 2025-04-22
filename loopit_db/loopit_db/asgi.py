import os
import django
from django.core.asgi import get_asgi_application

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'loopit_db.settings')
django.setup()

from channels.routing import ProtocolTypeRouter, URLRouter
# Replace this import with the new TokenAuthMiddlewareStack
# from channels.auth import AuthMiddlewareStack
from loopit_db.ws_auth import TokenAuthMiddlewareStack  # New import for our custom middleware
import chat.routing

# Debug logging
print("Loading ASGI application")
print(f"WebSocket patterns: {chat.routing.websocket_urlpatterns}")

application = ProtocolTypeRouter({
    "http": get_asgi_application(),
    "websocket": TokenAuthMiddlewareStack(  # Use the new middleware
        URLRouter(
            chat.routing.websocket_urlpatterns
        )
    ),
})