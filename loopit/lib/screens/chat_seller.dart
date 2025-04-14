import 'package:flutter/material.dart';
import 'package:loopit/screens/nodeals_accepted.dart';
import 'messages.dart';


void main() {
  runApp(const ChatSellerScreen());
}

class ChatSellerScreen extends StatelessWidget {
  const ChatSellerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: const Color(0xFF4A6741),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
      ),
      home: const ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [
    ChatMessage(
      text:
          "Good Morning! are you taking any offer for the shoes you're selling?",
      isMe: false,
      time: DateTime(2024, 1, 1, 9, 30),
      hasImage: true,
      imagePath: 'assets/shoes.jpg',
    ),
    ChatMessage(
      text: "Sure, just say the number and I'll think about it.",
      isMe: true,
      time: DateTime.now(),
    ),
    ChatMessage(
      text: "Sepatu Staccato Original\nRp 400.000",
      isMe: false,
      time: DateTime.now(),
      hasImage: true,
      imagePath: 'assets/shoes.jpg',
      showButtons: true,
    ),
    ChatMessage(
      text:
          "I think its too low, i need to think this through. Give me a second",
      isMe: true,
      time: DateTime.now(),
    ),
  ];

  // Updated color scheme to match the reference image
  final Color primaryGreen = const Color(0xFF4A6741);
  final Color lightGreen = const Color(0xFFE6F4E6);
  final Color mediumGreen = const Color(0xFF8EA987);
  final Color buttonGreen = const Color(0xFF8EA987);

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSubmitted(String text) {
    _messageController.clear();
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isMe: true,
        time: DateTime.now(),
      ));
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
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

  void _sendProductCard() {
    setState(() {
      _messages.add(ChatMessage(
        text: "Sepatu Staccato Original\nRp 0",
        isMe: true,
        time: DateTime.now(),
        hasImage: true,
        imagePath: 'assets/shoes.jpg',
        isProductCard: true,
      ));
    });

    _scrollToBottom();
  }

  void _handleSetButtonPress() {
    setState(() {
      // Find the product card message and replace it with an accepted version
      for (int i = 0; i < _messages.length; i++) {
        if (_messages[i].isMe && _messages[i].isProductCard) {
          // Replace the product card with an accepted version
          _messages[i] = ChatMessage(
            text: "Sepatu Staccato Original\nRp 550.000",
            isMe: true,
            time: DateTime.now(),
            hasImage: true,
            imagePath: 'assets/shoes.jpg',
            isAccepted: true,
          );
          break;
        }
      }
    });
  }

  void _showFinishDealDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color(0xFFF2F7F2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE6F4E6),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Color(0xFF4A6741),
                          size: 20,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        'Finish Deal ?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4A6741),
                        ),
                      ),
                    ),
                    const SizedBox(width: 40), // Balance the layout
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF8EA987),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      // Product image with rounded corners
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                        child: Image.asset(
                          'assets/shoes.jpg',
                          height: 120,
                          width: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Product details
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Sepatu Staccato Original',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Rp 550.000',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Once you click send, all price are final and the buyer are able to proceed to the checkout page.',
                  style: TextStyle(
                    color: Color(0xFF4A6741),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Close dialog first
                      Navigator.of(context).pop();

                      // Check if any product has been accepted
                      bool hasAcceptedProduct = false;
                      for (var message in _messages) {
                        if (message.isMe && message.isAccepted) {
                          hasAcceptedProduct = true;
                          break;
                        }
                      }

                      // If no product has been accepted, navigate to NoDealsPage
                      if (!hasAcceptedProduct) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const nodeals(),
                          ),
                        );
                      } else {
                        // Otherwise navigate to OrderDetailsPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChatSellerScreen(),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8EA987),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 12),
                    ),
                    child: const Text(
                      'Send',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button style matching reference image
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade200, width: 1),
                ),
              ),
              child: Row(
                children: [
                  // Back button with circular light green background
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const MessagesPage(),
                        ),
                      );
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE6F4E6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF4A6741),
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/images/shoes.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'User 1',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF4A6741),
                    ),
                  ),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Monday, 1 January',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ),

            // Chat messages
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return _buildMessage(message, index);
                },
              ),
            ),

            // Today divider
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Today',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ),

            // Input field and finish deal button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Colors.grey.shade200),
                ),
              ),
              child: Row(
                children: [
                  OutlinedButton(
                    onPressed: _showFinishDealDialog,
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      side: BorderSide(color: primaryGreen),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    child: Text(
                      'Finish Deal',
                      style: TextStyle(color: primaryGreen, fontSize: 14),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: lightGreen,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              decoration: const InputDecoration(
                                hintText: 'Type a message',
                                hintStyle: TextStyle(color: Color(0xFF8EA987)),
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 16),
                              ),
                              onSubmitted: _handleSubmitted,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Color(0xFF4A6741),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.add, color: Colors.white),
                              onPressed: _sendProductCard,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessage(ChatMessage message, int index) {
    if (message.isProductCard && message.isMe) {
      // Updated product card styling to match reference
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Align(
          alignment: Alignment.centerRight,
          child: Container(
            width: 250,
            margin:
                const EdgeInsets.only(left: 48, right: 4, top: 4, bottom: 4),
            decoration: BoxDecoration(
              color: primaryGreen,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: Image.asset(
                    message.imagePath ?? 'assets/shoes.jpg',
                    height: 125,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Sepatu Staccato Original",
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Rp 0",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        height: 36,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: Colors.white.withOpacity(0.9),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _handleSetButtonPress,
                            borderRadius: BorderRadius.circular(18),
                            child: Center(
                              child: Text(
                                "Set",
                                style: TextStyle(
                                  color: primaryGreen,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Accepted product card (seller side) - updated styling
    if (message.isMe && message.hasImage && message.isAccepted) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Align(
          alignment: Alignment.centerRight,
          child: Container(
            width: 250,
            margin:
                const EdgeInsets.only(left: 48, right: 4, top: 4, bottom: 4),
            decoration: BoxDecoration(
              color: lightGreen,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: Image.asset(
                    message.imagePath ?? 'assets/shoes.jpg',
                    height: 125,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Sepatu Staccato Original",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Rp 550.000",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        height: 36,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: buttonGreen,
                        ),
                        child: const Center(
                          child: Text(
                            "Accepted",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Product Card from other user (left side) - updated styling
    if (!message.isMe && message.hasImage && message.showButtons) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 230,
            margin: const EdgeInsets.only(right: 48, top: 2, bottom: 6),
            decoration: BoxDecoration(
              color: lightGreen,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: Image.asset(
                    message.imagePath!,
                    height: 125,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Sepatu Staccato Original",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Rp 400.000",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Accept/Reject buttons - updated styling
          Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    side: BorderSide(color: primaryGreen),
                    backgroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  ),
                  child: Text(
                    'Accept',
                    style: TextStyle(color: primaryGreen),
                  ),
                ),
                const SizedBox(width: 10),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    side: const BorderSide(color: Colors.grey),
                    backgroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  ),
                  child: const Text(
                    'Reject',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    // Text message bubble - updated styling
    if (!message.isProductCard && !message.isAccepted) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Column(
          crossAxisAlignment:
              message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!message.isMe && message.hasImage && !message.isProductCard)
              Container(
                margin: const EdgeInsets.only(right: 48, bottom: 4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    message.imagePath!,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              margin: EdgeInsets.only(
                left: message.isMe ? 48 : 0,
                right: message.isMe ? 0 : 48,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isMe ? primaryGreen : lightGreen,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isMe ? Colors.white : Colors.black87,
                  fontSize: 14,
                ),
              ),
            ),

            // Double check mark for sent messages
            if (message.isMe)
              Padding(
                padding: const EdgeInsets.only(top: 4.0, right: 4.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.done_all, size: 16, color: mediumGreen),
                  ],
                ),
              ),
          ],
        ),
      );
    }

    return const SizedBox.shrink(); // Fallback for any unhandled cases
  }
}

class ChatMessage {
  final String text;
  final bool isMe;
  final DateTime time;
  final bool hasImage;
  final String? imagePath;
  final bool showButtons;
  final bool isProductCard;
  final bool isAccepted;

  ChatMessage({
    required this.text,
    required this.isMe,
    required this.time,
    this.hasImage = false,
    this.imagePath,
    this.showButtons = false,
    this.isProductCard = false,
    this.isAccepted = false,
  });
}
