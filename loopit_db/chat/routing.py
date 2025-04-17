from django.urls import path
from . import consumers

websocket_urlpatterns = [
    path('ws/chat/<int:conversation_id>/', consumers.ChatConsumer.as_asgi()),
    
]

async def connect(self):
    print(f"WebSocket connect request received: {self.scope}")
    try:
        self.conversation_id = self.scope['url_route']['kwargs']['conversation_id']
        self.room_group_name = f'chat_{self.conversation_id}'
        
        # Join room group
        await self.channel_layer.group_add(
            self.room_group_name,
            self.channel_name
        )
        
        # Accept the connection
        await self.accept()
        print(f"WebSocket connection accepted for conversation {self.conversation_id}")
    except Exception as e:
        print(f"Error in WebSocket connect: {str(e)}")
        raise