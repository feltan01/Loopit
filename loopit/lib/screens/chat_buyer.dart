import 'package:flutter/material.dart';

class ChatBuyerScreen extends StatefulWidget {
  const ChatBuyerScreen({super.key});

  @override
  State<ChatBuyerScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatBuyerScreen> {
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
      isMe: false,
      time: 'Today',
      hasOffer: true,
      offerAmount: 'Rp 140.000',
      productName: 'Jacket Cream color',
      brandName: 'Brand ABC',
      productImage: 'assets/images/cream_jacket.png',
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
        elevation: 1,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey[300],
            height: 0.5,
          ),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: const AssetImage('assets/images/user_avatar.png'),
              backgroundColor: const Color(0xFF4A6741),
            ),
            const SizedBox(width: 12),
            const Text(
              'User 2',
              style: TextStyle(
                color: Color(0xFF4A6741),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFE6F4E6),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(8),
            child: const Icon(
              Icons.arrow_back,
              color: Color(0xFF4A6741),
              size: 20,
            ),
          ),
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
                return _buildMessageItem(_messages[index], index);
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageItem(ChatMessage message, int index) {
    if (message.hasProduct && !message.hasOffer) {
      // First message with product image
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (index == 0 || (index > 0 && _messages[index - 1].time != message.time))
            Center(
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  message.time,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                ),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF8BAF7F),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        color: const Color(0xFFFFF5EC),
                        child: message.productImage != null
                            ? Image.asset(
                                message.productImage!,
                                fit: BoxFit.cover,
                              )
                            : const Center(
                                child: Icon(
                                  Icons.image,
                                  size: 50,
                                  color: Color(0xFF4A6741),
                                ),
                              ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        message.text,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: Icon(
                  Icons.check_circle_outline,
                  color: Colors.grey[400],
                  size: 16,
                ),
              ),
            ],
          ),
        ],
      );
    } else if (message.hasOffer) {
      // Offer message
      return Column(
        crossAxisAlignment: message.isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          if (index == 0 || (index > 0 && _messages[index - 1].time != message.time))
            Center(
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  message.time,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          Row(
            mainAxisAlignment: message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!message.isMe)
                const SizedBox(width: 8),
              Icon(
                Icons.check_circle_outline,
                color: Colors.grey[400],
                size: 16,
              ),
              const SizedBox(width: 8),
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                ),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF8BAF7F),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF5EC),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: message.productImage != null
                              ? Image.asset(
                                  message.productImage!,
                                  fit: BoxFit.cover,
                                )
                              : const Center(
                                  child: Icon(
                                    Icons.checkroom,
                                    size: 30,
                                    color: Color(0xFF4A6741),
                                  ),
                                ),
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
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              message.brandName,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              message.offerAmount,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'Set',
                                style: TextStyle(
                                  color: Color(0xFF8BAF7F),
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      // Regular text message
      return Container(
        padding: const EdgeInsets.only(bottom: 16),
        alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (index == 0 || (index > 0 && _messages[index - 1].time != message.time))
              Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    message.time,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            Row(
              mainAxisAlignment: message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!message.isMe)
                  const SizedBox(width: 8),
                Icon(
                  Icons.check_circle_outline,
                  color: Colors.grey[400],
                  size: 16,
                ),
                const SizedBox(width: 8),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: message.isMe ? const Color(0xFF8BAF7F) : const Color(0xFFE6F4E6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: message.isMe ? Colors.white : const Color(0xFF4A6741),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
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
              onPressed: () {
                _showBargainBottomSheet();
              },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: Color.fromARGB(255, 226, 220, 175),
                side: const BorderSide(color: Color(0xFF4A6741)),
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
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F4E6).withOpacity(0.6),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.grey[200]!,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: 'Type a message',
                          hintStyle: TextStyle(color: Color(0xFF6B8364)),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
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
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(0xFF4A6741),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
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
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setBottomSheetState) {
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
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Make an Offer',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A6741),
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
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/images/cream_jacket.png',
                            fit: BoxFit.cover,
                          ),
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
                                color: Color(0xFF4A6741),
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
                                color: Colors.black87,
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
                    decoration: const InputDecoration(
                      labelText: 'Your offer (in Rp)',
                      labelStyle: TextStyle(color: Color(0xFF4A6741)),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF4A6741)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF4A6741), width: 2),
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
                            // Validate the input is a valid number
                            double.parse(offerController.text.replaceAll(',', '.'));
                            
                            // Add the offer message
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
                                ),
                              );
                            });
                            
                            // Close the bottom sheet
                            Navigator.pop(context);
                          } catch (e) {
                            // Show an error message for invalid input
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
                        backgroundColor: const Color(0xFF4A6741),
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
  });
}