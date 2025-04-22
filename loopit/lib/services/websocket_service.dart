import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';

// Conditional import for WebSocket based on the platform
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/html.dart'; // For web support

class WebSocketService {
  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  Function(Map<String, dynamic>)? onMessageReceived;
  Function()? onConnectionClosed; // Callback for connection closed
  Function(dynamic)? onError; // New callback for error handling
  int? _conversationId;
  bool _connected = false;
  bool _intentionalDisconnect = false; // Track if disconnect was intentional
  
  // Ping timer to keep connection alive
  Timer? _pingTimer;
  
  // Reconnection variables
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  static const int MAX_RECONNECT_ATTEMPTS = 5;
  static const Duration RECONNECT_DELAY = Duration(seconds: 3);

  // Connect to WebSocket for a specific conversation
  Future<void> connectToConversation(int conversationId) async {
    print('🔵 WebSocket: Starting connection to conversation $conversationId');
    
    try {
      // Get token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      
      // Debug all stored keys in SharedPreferences
      print('🔍 DEBUG: All SharedPreferences keys:');
      final allKeys = prefs.getKeys();
      for (var key in allKeys) {
        final value = prefs.get(key);
        print('   • $key: ${value != null ? "Has value" : "NULL"}');
      }
      
      final token = prefs.getString('access_token');
      
      print('🔑 Token retrieval attempt: ${token != null ? "Token exists" : "TOKEN IS NULL"}');
      
      if (token == null || token.isEmpty) {
        print('❌ ERROR: No authentication token available in SharedPreferences');
        
        // Try to look for the token under different keys as fallback
        final alternativeKeys = ['token', 'auth_token', 'jwt', 'accessToken'];
        for (var key in alternativeKeys) {
          final altToken = prefs.getString(key);
          if (altToken != null && altToken.isNotEmpty) {
            print('🔄 Found token under alternative key: $key');
            print('🔄 Migrating token to access_token key');
            await prefs.setString('access_token', altToken);
            print('✅ Token migrated successfully!');
            
            // Use the migrated token
            return connectToConversation(conversationId);
          }
        }
        
        throw Exception('No authentication token available. Please log in again.');
      }
      
      // Reset intentional disconnect flag
      _intentionalDisconnect = false;
      
      if (_connected && _conversationId == conversationId) {
        print('ℹ️ Already connected to conversation $conversationId');
        return; // Already connected to this conversation
      }

      if (_connected) {
        print('ℹ️ Disconnecting from previous conversation before connecting to conversation $conversationId');
        disconnect(); // Disconnect from the previous conversation
      }

      // Append token to WebSocket URL as a query parameter
      final wsUrl = 'ws://192.168.0.13:8000/ws/chat/$conversationId/?token=$token';
      print('🔌 Connecting to WebSocket URL: ${wsUrl.substring(0, wsUrl.indexOf('?') + 10)}...[token hidden]');
      
      // Cancel any existing subscription
      await _cancelSubscription();
      
      // Use the appropriate WebSocket channel based on the platform
      if (kIsWeb) {
        print('🌐 Using HtmlWebSocketChannel (Web platform)');
        
        // For web platform, try a direct HtmlWebSocketChannel connection
        try {
          _channel = HtmlWebSocketChannel.connect(Uri.parse(wsUrl));
          print('✅ Web platform: HtmlWebSocketChannel created successfully');
        } catch (e) {
          print('❌ Web platform: Error creating HtmlWebSocketChannel: $e');
          print('❌ Web platform: Error details: ${e.toString()}');
          rethrow;
        }
      } else {
        print('📱 Using IOWebSocketChannel (Native platform)');
        _channel = IOWebSocketChannel.connect(
          Uri.parse(wsUrl),
          pingInterval: const Duration(seconds: 15), // Keep connection alive with shorter interval
        );
      }

      _conversationId = conversationId;
      _connected = true;
      _reconnectAttempts = 0; // Reset reconnect attempts on successful connection
      
      // Set up the stream listener with proper error handling
      _subscription = _channel!.stream.listen(
        (message) {
          try {
            print('📩 Received WebSocket message: $message');
            final data = jsonDecode(message);
            if (onMessageReceived != null) {
              onMessageReceived!(data);
            }
          } catch (e) {
            print('❌ Error processing WebSocket message: $e');
            if (onError != null) {
              onError!(e);
            }
          }
        },
        onDone: () {
          print('🏁 WebSocket connection closed (onDone)');
          _handleDisconnection();
        },
        onError: (error) {
          print('❌ WebSocket error details: ${error.toString()}');
          print('❌ WebSocket error type: ${error.runtimeType}');
          
          if (error is Error) {
            print('❌ WebSocket error stack trace: ${error.stackTrace}');
          }
          
          if (onError != null) {
            onError!(error);
          }
          _handleDisconnection();
        },
        cancelOnError: false, // Don't cancel subscription on error
      );
      
      // Set up periodic ping to keep connection alive
      _setupPingTimer();
      
      print('✅ WebSocket connection established for conversation $conversationId');
    } catch (e) {
      print('❌ Failed to connect to WebSocket: $e');
      print('❌ Error type: ${e.runtimeType}');
      
      if (e is Error) {
        print('❌ Stack trace: ${e.stackTrace}');
      }
      
      _connected = false;
      
      // Start reconnection process if not intentionally disconnected
      if (!_intentionalDisconnect) {
        _scheduleReconnect();
      }
      
      rethrow; // Rethrow the exception for further handling
    }
  }
  
  // Handle disconnection (both error and normal close)
  void _handleDisconnection() {
    _connected = false;
    _cancelPingTimer();
    
    if (onConnectionClosed != null) {
      onConnectionClosed!();
    }
    
    // Attempt to reconnect if not intentionally disconnected
    if (!_intentionalDisconnect) {
      _scheduleReconnect();
    }
  }
  
  // Send a ping message to keep the connection alive
  void _sendPing() {
    if (_connected && _channel != null) {
      try {
        // Send a simple ping message in the format that your Django consumer expects
        _channel!.sink.add(jsonEncode({
          'message': '__ping__',
          'sender_id': -1,  // Use a special ID for ping messages
        }));
        print('📤 Ping sent');
      } catch (e) {
        print('❌ Error sending ping: $e');
      }
    }
  }
  
  // Schedule a reconnection attempt
  void _scheduleReconnect() {
    // Cancel any existing reconnect timer
    _reconnectTimer?.cancel();
    
    if (_reconnectAttempts < MAX_RECONNECT_ATTEMPTS && !_intentionalDisconnect) {
      _reconnectAttempts++;
      print('🔄 Scheduling reconnection attempt $_reconnectAttempts of $MAX_RECONNECT_ATTEMPTS');
      
      _reconnectTimer = Timer(RECONNECT_DELAY, () {
        if (_conversationId != null && !_intentionalDisconnect) {
          print('🔄 Attempting to reconnect to conversation $_conversationId');
          connectToConversation(_conversationId!).catchError((e) {
            print('❌ Reconnection attempt failed: $e');
          });
        }
      });
    } else if (_reconnectAttempts >= MAX_RECONNECT_ATTEMPTS) {
      print('⚠️ Maximum reconnection attempts reached');
    }
  }

  // Set up a timer to periodically send pings to keep the connection alive
  void _setupPingTimer() {
    _cancelPingTimer(); // Cancel any existing timer
    
    // Send a ping every 15 seconds (shorter interval for more reliability)
    _pingTimer = Timer.periodic(const Duration(seconds: 15), (timer) {
      _sendPing();
    });
  }
  
  // Cancel the ping timer
  void _cancelPingTimer() {
    _pingTimer?.cancel();
    _pingTimer = null;
  }
  
  // Cancel any existing subscription
  Future<void> _cancelSubscription() async {
    if (_subscription != null) {
      await _subscription!.cancel();
      _subscription = null;
    }
  }

  // Send a message through the WebSocket
  void sendMessage(String message, int senderId) {
    if (!_connected || _channel == null) {
      throw Exception('Not connected to WebSocket');
    }

    print('📤 Sending message through WebSocket');
    try {
      _channel!.sink.add(jsonEncode({
        'message': message,
        'sender_id': senderId,
      }));
    } catch (e) {
      print('❌ Error sending message: $e');
      throw e;
    }
  }

  // Disconnect from the WebSocket
  void disconnect() {
    print('🔌 Disconnecting from WebSocket');
    _intentionalDisconnect = true; // Mark as intentional disconnect
    
    // Cancel timers and subscription
    _cancelPingTimer();
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _cancelSubscription();
    
    if (_channel != null) {
      try {
        _channel!.sink.close();
      } catch (e) {
        print('❌ Error closing WebSocket: $e');
      }
      _channel = null;
    }
    
    _connected = false;
    _conversationId = null;
    _reconnectAttempts = 0;
    print('✅ WebSocket disconnected');
  }

  // Debug method to check token from anywhere
  static Future<void> debugToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      
      print('🔍 DEBUG TOKEN CHECK:');
      print('   • access_token exists: ${token != null}');
      if (token != null) {
        print('   • Token length: ${token.length}');
        print('   • Token preview: ${token.substring(0, min(10, token.length))}...');
      }
      
      // Check all stored keys
      print('   • All SharedPreferences keys:');
      final allKeys = prefs.getKeys();
      for (var key in allKeys) {
        final value = prefs.get(key);
        print('     - $key: ${value != null ? "Has value" : "NULL"}');
      }
    } catch (e) {
      print('❌ Error during token debug: $e');
    }
  }

  // Min function to avoid importing dart:math
  static int min(int a, int b) {
    return a < b ? a : b;
  }

  // Check if the WebSocket is connected
  bool get isConnected => _connected;
}