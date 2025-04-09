import 'package:flutter/material.dart';
import 'checkout_page.dart';

class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({super.key});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [
    ChatMessage(
      sender: 'User 2',
      text: 'Good Morning! are you taking any offer for the jacket you\'re selling?',
      isMe: false,
      time: 'Monday, 1 January',
      hasProduct: true,
      productImage: 'assets/images/cream_jacket.png',
    ),
    ChatMessage(
      sender: 'Me',
      text: 'Sure, just say the number and i\'ll think about it.',
      isMe: false,
      time: 'Today',
    ),
    ChatMessage(
      sender: 'Me',
      text: 'I\'d like to offer',
      isMe: true,
      time: 'Today',
      hasOffer: true,
      offerAmount: 'Rp 140.000',
      productName: 'Jacket Cream color',
      brandName: 'Brand ABC',
      productImage: 'assets/images/cream_jacket.png',
      offerStatus: 'Pending',
    ),
    ChatMessage(
      sender: 'User 2',
      text: 'I\'d like to offer',
      isMe: false,
      time: 'Today',
      hasOffer: true,
      offerAmount: 'Rp 140.000',
      productName: 'Jacket Cream color',
      brandName: 'Brand ABC',
      productImage: 'assets/images/cream_jacket.png',
      offerStatus: 'Accepted',
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: const AssetImage('assets/images/user_avatar.png'),
            ),
            const SizedBox(width: 12),
            const Text(
              'User 2',
              style: TextStyle(
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
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageItem(_messages[index]);
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageItem(ChatMessage message) {
    if (message.hasOffer) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: message.isMe 
              ? MainAxisAlignment.end 
              : MainAxisAlignment.start,
          children: [
            Container(
              width: 280,
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
                        child: Image.asset(
                          message.productImage!,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              message.productName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              message.brandName,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              message.offerAmount,
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
                  if (message.offerStatus == 'Pending')
                    const Text(
                      'Please wait for the seller\'s respond',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  if (message.offerStatus == 'Accepted')
                    ElevatedButton(
                      onPressed: () {Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const Checkout(), // Redirect to chat_buyer.dart
                      ),
                    );},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8BAF7F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Check Out',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
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
        mainAxisAlignment: message.isMe 
            ? MainAxisAlignment.end 
            : MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: message.isMe 
                  ? const Color(0xFFE6F4E6) 
                  : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: message.isMe 
                  ? null 
                  : Border.all(color: Colors.grey.shade300),
            ),
            child: Text(
              message.text,
              style: TextStyle(
                color: message.isMe 
                    ? Colors.black 
                    : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
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
              onPressed: _showBargainBottomSheet,
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
              ),
            ),
            const SizedBox(width: 10),
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFF4A6741),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {
                  if (_messageController.text.isNotEmpty) {
                    setState(() {
                      _messages.add(
                        ChatMessage(
                          sender: 'User',
                          text: _messageController.text,
                          isMe: true,
                          time: 'Today',
                        ),
                      );
                      _messageController.clear();
                    });
                  }
                },
                icon: const Icon(
                  Icons.add,
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

  void _showBargainBottomSheet() {
    final TextEditingController offerController = TextEditingController();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
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
                    child: Image.asset(
                      'assets/images/cream_jacket.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Jacket Cream color',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Brand ABC',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Original Price: Rp 200.000',
                          style: TextStyle(
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
                  onPressed: () {
                    if (offerController.text.isNotEmpty) {
                      try {
                        double.parse(offerController.text.replaceAll(',', '.'));
                        
                        setState(() {
                          _messages.add(
                            ChatMessage(
                              sender: 'User',
                              text: 'I\'d like to offer', 
                              isMe: true,
                              time: 'Today',
                              hasOffer: true,
                              offerAmount: 'Rp ${offerController.text}',
                              productName: 'Jacket Cream color',
                              brandName: 'Brand ABC',
                              productImage: 'assets/images/cream_jacket.png',
                              offerStatus: 'Pending',
                            ),
                          );
                        });
                        
                        Navigator.pop(context);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter a valid number'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8BAF7F),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
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
    ).then((_) {
      offerController.dispose();
    });
  }
}

class ChatMessage {
  final String sender;
  final String text;
  final bool isMe;
  final String time;
  final bool hasProduct;
  final bool hasOffer;
  final String offerAmount;
  final String productName;
  final String brandName;
  final String? productImage;
  final String offerStatus;

  ChatMessage({
    required this.sender,
    required this.text,
    required this.isMe,
    required this.time,
    this.hasProduct = false,
    this.hasOffer = false,
    this.offerAmount = '',
    this.productName = '',
    this.brandName = '',
    this.productImage,
    this.offerStatus = '',
  });
}