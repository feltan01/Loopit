import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import '../services/api_service.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  Function(Map<String, dynamic>)? onMessageReceived;
  Function()? onConnectionClosed; // 🔹 Added this
  int? _conversationId;
  bool _connected = false;

  // Connect to WebSocket for a specific conversation
  Future<void> connectToConversation(int conversationId) async {
    if (_connected && _conversationId == conversationId) {
      return; // Already connected to this conversation
    }

    if (_connected) {
      disconnect();
    }

    final token = await ApiService.getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final wsUrl = 'ws://10.0.2.2:8000/ws/chat/$conversationId/';
    try {
      _channel = IOWebSocketChannel.connect(
        Uri.parse(wsUrl),
        headers: {
          'Authorization': 'Token $token',
        },
      );

      _conversationId = conversationId;
      _connected = true;

      _channel!.stream.listen(
        (message) {
          final data = jsonDecode(message);
          if (onMessageReceived != null) {
            onMessageReceived!(data);
          }
        },
        onDone: () {
          _connected = false;
          if (onConnectionClosed != null) {
            onConnectionClosed!();
          }
        },
        onError: (error) {
          print('WebSocket error: $error');
          _connected = false;
          if (onConnectionClosed != null) {
            onConnectionClosed!();
          }
        },
      );
    } catch (e) {
      print('Failed to connect to WebSocket: $e');
      _connected = false;
      rethrow;
    }
  }

  void sendMessage(String message, int senderId) {
    if (!_connected || _channel == null) {
      throw Exception('Not connected to WebSocket');
    }

    _channel!.sink.add(jsonEncode({
      'message': message,
      'sender_id': senderId,
    }));
  }

  void disconnect() {
    if (_channel != null) {
      _channel!.sink.close();
      _channel = null;
    }
    _connected = false;
    _conversationId = null;
  }

  bool get isConnected => _connected;
}
