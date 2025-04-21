import json
from channels.generic.websocket import AsyncWebsocketConsumer
from channels.db import database_sync_to_async
from .models import Conversation, Message
from django.contrib.auth.models import User

class ChatConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        self.conversation_id = self.scope['url_route']['kwargs']['conversation_id']
        self.room_group_name = f'chat_{self.conversation_id}'
        
        # Add debug log
        print(f"WebSocket connect attempt to conversation {self.conversation_id}")
        
        # Join room group
        await self.channel_layer.group_add(
            self.room_group_name,
            self.channel_name
        )
        
        # Accept the connection
        await self.accept()
        print(f"WebSocket connection accepted for conversation {self.conversation_id}")
        
        # Send a connection confirmation message
        await self.send(text_data=json.dumps({
            'message': 'Connected to chat server',
            'sender_id': -1,
            'message_id': 0,
            'timestamp': self.get_timestamp(),
            'type': 'connection_established'
        }))
    
    async def disconnect(self, close_code):
        # Log the disconnect
        print(f"WebSocket disconnected from conversation {self.conversation_id} with code {close_code}")
        
        # Leave room group
        await self.channel_layer.group_discard(
            self.room_group_name,
            self.channel_name
        )
    
    # Receive message from WebSocket
    async def receive(self, text_data):
        try:
            data = json.loads(text_data)
            message = data.get('message', '')
            sender_id = data.get('sender_id', -1)
            
            # Handle ping messages
            if message == '__ping__' and sender_id == -1:
                await self.send(text_data=json.dumps({
                    'message': '__pong__',
                    'sender_id': -1,
                    'message_id': 0,
                    'timestamp': self.get_timestamp(),
                    'type': 'ping_response'
                }))
                return
                
            # For regular messages, proceed as before
            print(f"Received message from sender {sender_id} in conversation {self.conversation_id}")
            
            # Save message to database
            saved_message = await self.save_message(sender_id, message)
            
            # Send message to room group
            await self.channel_layer.group_send(
                self.room_group_name,
                {
                    'type': 'chat_message',
                    'message': message,
                    'sender_id': sender_id,
                    'message_id': saved_message['id'],
                    'timestamp': saved_message['timestamp'],
                }
            )
        except json.JSONDecodeError:
            print(f"Invalid JSON received: {text_data}")
            await self.send(text_data=json.dumps({
                'error': 'Invalid JSON format',
                'timestamp': self.get_timestamp()
            }))
        except Exception as e:
            print(f"Error in receive: {str(e)}")
            await self.send(text_data=json.dumps({
                'error': f'Server error: {str(e)}',
                'timestamp': self.get_timestamp()
            }))
    
    # Receive message from room group
    async def chat_message(self, event):
        try:
            # Send message to WebSocket
            await self.send(text_data=json.dumps({
                'message': event['message'],
                'sender_id': event['sender_id'],
                'message_id': event['message_id'],
                'timestamp': event['timestamp'],
                'type': 'chat_message'
            }))
        except Exception as e:
            print(f"Error in chat_message: {str(e)}")
    
    @database_sync_to_async
    def save_message(self, sender_id, message_text):
        try:
            user = User.objects.get(id=sender_id)
            conversation = Conversation.objects.get(id=self.conversation_id)
            message = Message.objects.create(
                conversation=conversation,
                sender=user,
                text=message_text
            )
            
            # Update conversation timestamp
            conversation.save()
            
            return {
                'id': message.id,
                'timestamp': message.created_at.isoformat(),
            }
        except User.DoesNotExist:
            print(f"User with ID {sender_id} does not exist")
            raise
        except Conversation.DoesNotExist:
            print(f"Conversation with ID {self.conversation_id} does not exist")
            raise
        except Exception as e:
            print(f"Error saving message: {str(e)}")
            raise
    
    def get_timestamp(self):
        from datetime import datetime
        return datetime.now().isoformat()
    
