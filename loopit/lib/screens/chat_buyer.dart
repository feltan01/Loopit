import 'package:flutter/material.dart';
import 'dart:async';
import '../models/user.dart';
import '../models/message.dart';
import '../models/product.dart';
import '../models/offer.dart';
import '../services/api_service.dart';
import '../services/websocket_service.dart';

class ChatDetailScreen extends StatefulWidget {
  final int conversationId;
  final User otherUser;
  final User currentUser;

  const ChatDetailScreen({
    Key? key,
    required this.conversationId,
    required this.otherUser,
    required this.currentUser,
  }) : super(key: key);

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Message> _messages = [];
  final WebSocketService _webSocketService = WebSocketService();
  bool _isLoading = true;
  bool _isWebSocketConnected = false;
  Product? _currentProduct;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _setupWebSocket();
  }

  void _setupWebSocket() async {
    try {
      print('Attempting to connect to WebSocket for conversation: ${widget.conversationId}');
      
      // Connect to WebSocket with timeout
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
          setState(() {
            // Add new message from WebSocket
            final newMessage = Message(
              id: data['message_id'],
              conversationId: widget.conversationId,
              sender: User(
                id: data['sender_id'],
                username: data['sender_id'] == widget.currentUser.id
                    ? widget.currentUser.username
                    : widget.otherUser.username,
                email: '', // Email not available in WebSocket data
              ),
              text: data['message'],
              createdAt: DateTime.parse(data['timestamp']),
            );
            _messages.add(newMessage);
          });
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

  Future<void> _loadMessages() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load conversation to get products and messages without token
      final conversationData = await ApiService.getConversation(widget.conversationId);

      // Check if messages exist in the response
      if (conversationData['messages'] != null) {
        // Parse messages
        final messagesList = List<Map<String, dynamic>>.from(conversationData['messages']);
        final loadedMessages = messagesList.map((msgJson) => Message.fromJson(msgJson)).toList();

        setState(() {
          _messages.clear();
          _messages.addAll(loadedMessages);
          _isLoading = false;
        });

        // Find product if there's any offer
        for (var msg in _messages) {
          if (msg.offer != null) {
            _currentProduct = msg.offer!.product;
            break;
          }
        }
      } else {
        // Handle case where there are no messages
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No messages found.')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load messages: $e')),
        );
      }
    }
  }

  Future<void> _sendMessage() async {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    try {
      // Send message without needing a token
      await ApiService.sendMessage(widget.conversationId, messageText);
      
      // Clear the input field
      _messageController.clear();
      // The new message will come through the WebSocket
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send message: $e')),
        );
      }
    }
  }

  Future<void> _respondToOffer(int offerId, String status) async {
    try {
      await ApiService.respondToOffer(offerId, status);
      
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
      await _loadMessages();
      
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
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return _buildMessageItem(_messages[index], screenWidth);
                    },
                  ),
                ),
                _buildInputArea(),
              ],
            ),
    );
  }

  Widget _buildMessageItem(Message message, double screenWidth) {
    final bool isMe = message.isFromCurrentUser(widget.currentUser.id);
    
    // Check if message has an offer
    if (message.offer != null) {
      final offer = message.offer!;
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
                              'Rp ${offer.amount.toStringAsFixed(0)}',
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
            if (_currentProduct != null)
              OutlinedButton(
                onPressed: () => _showBargainBottomSheet(_currentProduct!),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: const Color(0xFFE6F4E6),
                  side: BorderSide.none,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                child: const Text(
                  'Bargain price',
                  style: TextStyle(
                    color: Color(0xFF4A6741),
                  ),
                ),
              ),
            if (_currentProduct != null) const SizedBox(width: 10),
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
                          final amount = double.parse(offerController.text.replaceAll(',', '.'));
                          
                          try {
                            await ApiService.makeOffer(
                              widget.conversationId,
                              product.id,
                              amount,
                            );
                            
                            // Dispose controller before popping
                            offerController.dispose();
                            
                            // Pop the bottom sheet
                            Navigator.pop(context);
                            
                            // Reload messages to show the new offer
                            if (mounted) {
                              await _loadMessages();
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
}