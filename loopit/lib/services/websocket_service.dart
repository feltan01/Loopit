import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';

// Corrected: Conditional WebSocket import
import 'package:web_socket_channel/web_socket_channel.dart';
import 'web_socket_stub.dart'; // Uses platform-specific createWebSocketChannel()

class WebSocketService {
  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  Function(Map<String, dynamic>)? onMessageReceived;
  Function()? onConnectionClosed;
  Function(dynamic)? onError;
  int? _conversationId;
  bool _connected = false;
  bool _intentionalDisconnect = false;

  Timer? _pingTimer;
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  static const int MAX_RECONNECT_ATTEMPTS = 5;
  static const Duration RECONNECT_DELAY = Duration(seconds: 3);

  Future<void> connectToConversation(int conversationId) async {
    print('🔵 WebSocket: Starting connection to conversation $conversationId');
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token == null || token.isEmpty) {
        throw Exception('No authentication token available. Please log in again.');
      }

      _intentionalDisconnect = false;

      if (_connected && _conversationId == conversationId) {
        return;
      }

      if (_connected) {
        disconnect();
      }

      final wsUrl = 'ws://192.168.18.65:8000/ws/chat/$conversationId/?token=$token';

      await _cancelSubscription();

      print('🌐 Connecting to: $wsUrl');
      _channel = createWebSocketChannel(wsUrl); // ✅ Platform-specific WebSocket creation

      _conversationId = conversationId;
      _connected = true;
      _reconnectAttempts = 0;

      _subscription = _channel!.stream.listen(
        (message) {
          try {
            final data = jsonDecode(message);
            if (onMessageReceived != null) {
              onMessageReceived!(data);
            }
          } catch (e) {
            if (onError != null) {
              onError!(e);
            }
          }
        },
        onDone: () {
          _handleDisconnection();
        },
        onError: (error) {
          if (onError != null) {
            onError!(error);
          }
          _handleDisconnection();
        },
        cancelOnError: false,
      );

      _setupPingTimer();
      print('✅ WebSocket connected for conversation $conversationId');
    } catch (e) {
      _connected = false;
      if (!_intentionalDisconnect) {
        _scheduleReconnect();
      }
      rethrow;
    }
  }

  void _handleDisconnection() {
    _connected = false;
    _cancelPingTimer();

    if (onConnectionClosed != null) {
      onConnectionClosed!();
    }

    if (!_intentionalDisconnect) {
      _scheduleReconnect();
    }
  }

  void _sendPing() {
    if (_connected && _channel != null) {
      try {
        _channel!.sink.add(jsonEncode({'message': '__ping__', 'sender_id': -1}));
      } catch (_) {}
    }
  }

  void _scheduleReconnect() {
    _reconnectTimer?.cancel();

    if (_reconnectAttempts < MAX_RECONNECT_ATTEMPTS && !_intentionalDisconnect) {
      _reconnectAttempts++;
      _reconnectTimer = Timer(RECONNECT_DELAY, () {
        if (_conversationId != null && !_intentionalDisconnect) {
          connectToConversation(_conversationId!).catchError((_) {});
        }
      });
    }
  }

  void _setupPingTimer() {
    _cancelPingTimer();
    _pingTimer = Timer.periodic(const Duration(seconds: 15), (timer) {
      _sendPing();
    });
  }

  void _cancelPingTimer() {
    _pingTimer?.cancel();
    _pingTimer = null;
  }

  Future<void> _cancelSubscription() async {
    if (_subscription != null) {
      await _subscription!.cancel();
      _subscription = null;
    }
  }

  void sendMessage(String message, int senderId) {
    if (!_connected || _channel == null) {
      throw Exception('Not connected to WebSocket');
    }

    try {
      _channel!.sink.add(jsonEncode({'message': message, 'sender_id': senderId}));
    } catch (e) {
      throw e;
    }
  }

  void disconnect() {
    _intentionalDisconnect = true;

    _cancelPingTimer();
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _cancelSubscription();

    if (_channel != null) {
      try {
        _channel!.sink.close();
      } catch (_) {}
      _channel = null;
    }

    _connected = false;
    _conversationId = null;
    _reconnectAttempts = 0;
  }

  bool get isConnected => _connected;
}
