import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/message.dart';
import '../models/product.dart';
import '../models/offer.dart';
import '../services/api_services.dart';
import '../services/websocket_service.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    // Remove all existing dots
    String value = newValue.text.replaceAll('.', '');
    
    // Format with dots
    final formatter = NumberFormat('#,###', 'id');
    String newText = formatter.format(int.parse(value));
    
    // Replace commas with dots for Indonesian format
    newText = newText.replaceAll(',', '.');

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class ChatDetailScreen extends StatefulWidget {
  final int conversationId;
  final User otherUser;
  final User currentUser;
  final String? productImageUrl; // <<<<< tambahan


  const ChatDetailScreen({
    Key? key,
    required this.conversationId,
    required this.otherUser,
    required this.currentUser,
    this.productImageUrl, // <<<<< ini tambahan
  }) : super(key: key);

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Message> _messages = [];
  final WebSocketService _webSocketService = WebSocketService();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = true;
  bool _isWebSocketConnected = false;
  Product? _currentProduct;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _setupWebSocket();
    _setupPeriodicRefresh();
  }

  void _setupPeriodicRefresh() {
    // Set up periodic refresh every 15 seconds
    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (mounted) {
        _loadMessages(silent: true);
      }
    });
  }

  void _setupWebSocket() async {
    try {
      print('Attempting to connect to WebSocket for conversation: ${widget.conversationId}');
      
      // Connect to WebSocket with timeout (now the method will get token from SharedPreferences internally)
      await _webSocketService.connectToConversation(widget.conversationId)
          .timeout(const Duration(seconds: 10), onTimeout: () {
        throw TimeoutException('WebSocket connection timed out after 10 seconds');
      });
      
      print('WebSocket connection successful');
      
      if (mounted) {
        setState(() {
          _isWebSocketConnected = true;
        });
      }

      // Set up message handler
      _webSocketService.onMessageReceived = (data) {
        print('WebSocket message received: $data');
        if (mounted) {
          // If it's a new message (not a connection status message)
          if (data['type'] != 'connection_established' && data['message'] != '__ping__') {
            // Load all messages to ensure everything is in sync
            _loadMessages(silent: true);
            
            // Optionally show a notification
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('New message from ${widget.otherUser.username}'),
                duration: const Duration(seconds: 1),
                backgroundColor: const Color(0xFF4A6741),
              ),
            );
          }
        }
      };

      // Set up reconnection logic
      _webSocketService.onConnectionClosed = () {
        print('WebSocket connection closed');
        if (mounted) {
          setState(() {
            _isWebSocketConnected = false;
          });
          
          // Try to reconnect after a delay
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted && !_isWebSocketConnected) {
              print('Attempting to reconnect WebSocket...');
              _setupWebSocket();
            }
          });
        }
      };
    } catch (e, stackTrace) {
      print('WebSocket connection error: $e');
      print('Stack trace: $stackTrace');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('WebSocket connection failed: $e'),
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: _setupWebSocket,
            ),
          ),
        );
        
        setState(() {
          _isWebSocketConnected = false;
        });
        
        // Try to reconnect after a delay
        Future.delayed(const Duration(seconds: 5), () {
          if (mounted && !_isWebSocketConnected) {
            print('Attempting to reconnect WebSocket after error...');
            _setupWebSocket();
          }
        });
      }
    }
  }

  Future<void> _loadMessages({bool silent = false}) async {
    if (!silent) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      print("📩 Loading messages for conversation: ${widget.conversationId}");
      
      // Get token for debugging
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      print("🔑 Token available for API call: ${token != null ? 'YES' : 'NO'}");
      
      // Load conversation to get products and messages
      final conversationData = await ApiServices.getConversation(widget.conversationId);
      print("📊 Conversation data received: ${conversationData != null ? 'YES' : 'NO'}");
      
      // Check if messages exist in the response
      if (conversationData['messages'] != null) {
        print("📝 Messages found: ${conversationData['messages'].length}");
        
        try {
          // Parse messages with error handling for each message
          final messagesList = List<Map<String, dynamic>>.from(conversationData['messages']);
          print("📝 Processing ${messagesList.length} messages");
          
          final List<Message> loadedMessages = [];
          for (int i = 0; i < messagesList.length; i++) {
            try {
              print("🔍 Processing message ${i+1}/${messagesList.length}");
              final message = Message.fromJson(messagesList[i]);
              print("✅ Message ${i+1} parsed successfully");
              loadedMessages.add(message);
            } catch (parseError) {
              print("❌ Failed to parse message ${i+1}: $parseError");
              // Continue to next message without adding this one
            }
          }
          
          print("📝 Successfully parsed ${loadedMessages.length}/${messagesList.length} messages");

          if (loadedMessages.isEmpty && messagesList.isNotEmpty) {
            print("⚠️ Warning: All messages failed to parse!");
          }

          // If we have new messages or different number of messages
          bool hasChanges = _messages.length != loadedMessages.length;
          if (!hasChanges) {
            // Check for content changes
            for (int i = 0; i < _messages.length; i++) {
              if (_messages[i].id != loadedMessages[i].id) {
                hasChanges = true;
                break;
              }
            }
          }

          if (mounted) {
            setState(() {
              _messages.clear();
              _messages.addAll(loadedMessages);
              _isLoading = false;
            });

            // Scroll to bottom if new messages were added
            if (hasChanges) {
              _scrollToBottom();
            }
          }

          // Find product if there's any offer
          for (var msg in _messages) {
            if (msg.offer != null) {
              _currentProduct = msg.offer!.product;
              print("🛒 Found product in offer: ${_currentProduct!.name}");
              break;
            }
          }
        } catch (parsingError) {
          print("❌ Error in message list processing: $parsingError");
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
            
            if (!silent) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error processing messages: $parsingError')),
              );
            }
          }
        }
      } else {
        // Handle case where there are no messages
        print("⚠️ No messages found in conversation data");
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          
          if (!silent) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No messages found.')),
            );
          }
        }
      }
    } catch (e) {
      print("❌ Error loading messages: $e");
      print("❌ Error type: ${e.runtimeType}");
      if (e is Error) {
        print("❌ Stack trace: ${e.stackTrace}");
      }
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        if (!silent) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to load messages: $e')),
          );
        }
      }
    }
  }

  Future<void> _sendMessage() async {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    try {
      // Clear the input field immediately for better UX
      _messageController.clear();
      
      // Send message (token is now retrieved internally)
      await ApiServices.sendMessage(widget.conversationId, messageText);
      
      // Immediately refresh messages to show the sent message
      await _loadMessages(silent: true);
      
      // Scroll to bottom to show the new message
      _scrollToBottom();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send message: $e')),
        );
      }
    }
  }

  void _scrollToBottom() {
    // Add a small delay to ensure the list has been built
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _respondToOffer(int offerId, String status) async {
    try {
      // Respond to offer (token is now retrieved internally)
      await ApiServices.respondToOffer(offerId, status);
      
      // Create a new list of messages with the updated offer
      setState(() {
        final List<Message> updatedMessages = _messages.map((message) {
          if (message.offer?.id == offerId) {
            // Create a new offer with updated status
            final updatedOffer = Offer(
              id: message.offer!.id,
              conversationId: message.offer!.conversationId,
              messageId: message.offer!.messageId,
              product: message.offer!.product,
              buyer: message.offer!.buyer,
              amount: message.offer!.amount,
              status: status,
              createdAt: message.offer!.createdAt,
            );
            
            // Create and return a new message with the updated offer
            return Message(
              id: message.id,
              conversationId: message.conversationId,
              sender: message.sender,
              text: message.text,
              createdAt: message.createdAt,
              offer: updatedOffer,
            );
          }
          return message;
        }).toList();
        
        // Replace the messages list with the updated one
        _messages.clear();
        _messages.addAll(updatedMessages);
      });
      
      // Reload messages to ensure we have the latest data
      await _loadMessages(silent: true);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Offer ${status.toLowerCase()}'),
            backgroundColor: status == 'ACCEPTED' ? Colors.green : Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to respond to offer: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _refreshTimer?.cancel();
    _webSocketService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey[300],
              child: Text(
                widget.otherUser.username.isNotEmpty 
                    ? widget.otherUser.username[0].toUpperCase() 
                    : '?',
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              widget.otherUser.username,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          // Manual refresh button
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.grey),
            onPressed: () => _loadMessages(),
          ),
          // WebSocket connection indicator
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(
              _isWebSocketConnected ? Icons.wifi : Icons.wifi_off,
              color: _isWebSocketConnected ? Colors.green : Colors.red,
              size: 20,
            ),
          ),
        ],
      ),
      body: _isLoading
    ? const Center(child: CircularProgressIndicator())
    : Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: _messages.length + (widget.productImageUrl != null ? 1 : 0),
              itemBuilder: (context, index) {
                if (widget.productImageUrl != null && index == 0) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F5E6),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          widget.productImageUrl!,
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.broken_image, size: 50);
                          },
                        ),
                      ),
                    ),
                  );
                } else {
                  final realIndex = widget.productImageUrl != null ? index - 1 : index;
                  return _buildMessageItem(_messages[realIndex], screenWidth);
                }
              },
            ),
          ),
          _buildInputArea(), // <<< ini jangan ilang bro!
        ],
      ),
    );
  }

 Widget _buildMessageItem(Message message, double screenWidth) {
  final bool isMe = message.isFromCurrentUser (widget.currentUser .id);
  
  // Check if message has an offer
  if (message.offer != null) {
    final offer = message.offer!;
    print("📱 Rendering offer #${offer.id} with product #${offer.product.id}");
    print("🔍 Image URL being used: ${offer.product.fullImageUrl}"); // Debugging line

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            width: screenWidth * 0.8, // Responsive width
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F5E6),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF5EC),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.network(
                        offer.product.fullImageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            print("✅ Image loaded successfully for offer #${offer.id}");
                            return child;
                          }
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          print("❌ IMAGE ERROR for offer #${offer.id}");
                          print("❌ Image URL: ${offer.product.fullImageUrl}");
                          print("❌ Error details: $error");
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.image_not_supported),
                              Text(
                                'Image error',
                                style: TextStyle(fontSize: 10),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            offer.product.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            offer.product.brand,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Rp ${NumberFormat('#,###', 'id').format(offer.amount.toInt()).replaceAll(',', '.')}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Show different UI based on offer status and user role
                _buildOfferStatusUI(offer),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Regular text message
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      mainAxisAlignment: isMe 
          ? MainAxisAlignment.end 
          : MainAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: screenWidth * 0.75,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isMe 
                ? const Color(0xFFE6F4E6) 
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: isMe 
                ? null 
                : Border.all(color: Colors.grey.shade300),
          ),
          child: Text(
            message.text,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ],
    ),
  );
}

  Widget _buildOfferStatusUI(Offer offer) {
    // Buyer waiting for response
    if (offer.isPending && offer.buyer.id == widget.currentUser.id) {
      return const Text(
        'Please wait for the seller\'s response',
        style: TextStyle(
          color: Colors.grey,
          fontSize: 12,
        ),
      );
    }
    
    // Seller needs to respond to offer
    if (offer.isPending && offer.product.seller.id == widget.currentUser.id) {
      return Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => _respondToOffer(offer.id, 'ACCEPTED'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8BAF7F),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Accept',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: OutlinedButton(
              onPressed: () => _respondToOffer(offer.id, 'REJECTED'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Reject'),
            ),
          ),
        ],
      );
    }
    
    // Buyer can checkout after accepted offer
    if (offer.isAccepted && offer.buyer.id == widget.currentUser.id) {
      return ElevatedButton(
        onPressed: () {
          // Implement checkout logic here
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8BAF7F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text(
          'Checkout',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      );
    }
    
    // Seller sees status after accepting
    if (offer.isAccepted && offer.product.seller.id == widget.currentUser.id) {
      return const Text(
        'Offer accepted. Waiting for buyer to checkout.',
        style: TextStyle(
          color: Colors.green,
          fontSize: 12,
        ),
      );
    }
    
    // Rejected offer status
    if (offer.isRejected) {
      return const Text(
        'Offer rejected',
        style: TextStyle(
          color: Colors.red,
          fontSize: 12,
        ),
      );
    }
    
    // Default case (shouldn't happen)
    return const SizedBox.shrink();
  }

Widget _buildInputArea() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border(
        top: BorderSide(
          color: Colors.grey[300]!,
          width: 0.5,
        ),
      ),
    ),
    child: SafeArea(
      child: Row(
        children: [
          OutlinedButton(
            onPressed: () => _showProductSelectionSheet(),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: const Color(0xFFE6F4E6),
              side: BorderSide.none,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            child: const Text(
              'Bargain',
              style: TextStyle(
                color: Color(0xFF4A6741),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message',
                filled: true,
                fillColor: const Color(0xFFE6F4E6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onSubmitted: (_) => _sendMessage(), // Allow sending with Enter key
            ),
          ),
          const SizedBox(width: 10),
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF4A6741),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: _sendMessage,
              icon: const Icon(
                Icons.send,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
  
void _showBargainBottomSheet(Product product) {
  final TextEditingController offerController = TextEditingController();
  
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setSheetState) {
          bool isSubmitting = false;
          
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              top: 20,
              left: 20,
              right: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40.0,
                    height: 4.0,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Make an Offer',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF5EC),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.network(
                        product.fullImageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.image_not_supported),
                              Text(
                                'Image error',
                                style: TextStyle(fontSize: 10),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            product.brand,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Original Price: Rp ${product.price.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: offerController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Your offer (in Rp)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixText: 'Rp ',
                  ),
                  // Add input formatter for currency formatting
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CurrencyInputFormatter(),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isSubmitting ? null : () async {
                      if (offerController.text.isEmpty) return;
                      
                      setSheetState(() {
                        isSubmitting = true;
                      });
                      
                      try {
                        final amount = double.parse(offerController.text.replaceAll('.', ''));
                        
                        try {
                          // Make offer (token is now retrieved internally)
                          await ApiServices.makeOffer(
                            widget.conversationId,
                            product.id,
                            amount
                          );
                          
                          // Dispose controller before popping
                          offerController.dispose();
                          
                          // Pop the bottom sheet
                          Navigator.pop(context);
                          
                          // Show a temporary loading message
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Sending your offer...'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          }
                          
                          // Reload messages to show the new offer
                          if (mounted) {
                            await _loadMessages();
                            
                            // Ensure we scroll to the bottom to show the new offer
                            _scrollToBottom();
                          }
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed to send offer: $e')),
                            );
                          }
                          setSheetState(() {
                            isSubmitting = false;
                          });
                        }
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter a valid number'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                        setSheetState(() {
                          isSubmitting = false;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8BAF7F),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: isSubmitting 
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Send Offer',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      );
    },
  ).whenComplete(() {
    // Ensure the controller is disposed when the sheet is closed
    offerController.dispose();
  });
}

void _showProductSelectionSheet() async {
  try {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    
    // Fetch products 
    List<Map<String, dynamic>> products = [];
    try {
      products = await ApiServices.getProducts();
    } catch (e) {
      print('Error fetching products: $e');
      // Continue execution to show sample product
    }
    
    // Hide loading dialog
    if (context.mounted) Navigator.pop(context);
    
    // If no products from API, add a sample product for testing
    if (products.isEmpty) {
      // Create a sample product for testing
      products = [
        {
          'id': 1,
          'name': 'Sample Guitar',
          'brand': 'Brand X',
          'price': 2500000.0,
          'description': 'A sample product for testing the bargain feature',
          'image': 'https://via.placeholder.com/150',
          'condition': '95% Like New',
          'seller': {
            'id': 2, // Different from current user ID to simulate another seller
            'username': 'TestSeller',
            'email': 'seller@example.com'
          }
        },
        {
          'id': 2,
          'name': 'Luxury Watch',
          'brand': 'Rolex',
          'price': 15000000.0,
          'description': 'Premium luxury watch',
          'image': 'https://via.placeholder.com/150',
          'condition': '98% Like New',
          'seller': {
            'id': 2,
            'username': 'TestSeller',
            'email': 'seller@example.com'
          }
        }
      ];
    }
    
    // Show product selection bottom sheet
    if (context.mounted) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40.0,
                    height: 4.0,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Select a product to bargain',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 300, // Fixed height for the list
                  child: ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = Product.fromJson(products[index]);
                      return ListTile(
                        leading: SizedBox(
                          width: 50,
                          height: 50,
                          child: Image.network(
                            product.fullImageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.image_not_supported);
                            },
                          ),
                        ),
                        title: Text(product.name),
                        subtitle: Text('Rp ${product.price.toStringAsFixed(0)}'),
                        onTap: () {
                          Navigator.pop(context); // Close the selection sheet
                          _showBargainBottomSheet(product); // Show bargain sheet for the selected product
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  } catch (e) {
    // Hide loading dialog if there's an error
    if (context.mounted) Navigator.pop(context);
    
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load products: $e')),
      );
    }
  }
}
}