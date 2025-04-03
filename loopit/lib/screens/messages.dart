import 'package:flutter/material.dart';
import 'chat_buyer.dart';
import 'chat_seller.dart'; // Ensure this file exists

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Messages',
          style: TextStyle(
            color: Color(0xFF4A6741),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
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
          onPressed: () {},
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFE6F4E6),
                hintText: 'Search direct messages',
                hintStyle: const TextStyle(
                  color: Color(0xFF6B8364),
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Color(0xFF6B8364),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              children: [
                MessageItem(
                  userName: 'User 2',
                  message: 'Good Morning! are you taking any offer for...',
                  isUnread: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChatBuyerScreen(), // Redirect to chat_buyer.dart
                      ),
                    );
                  },
                ),
                MessageItem(
                  userName: 'Buyer 1',
                  message: 'Would you mind if i pay it on the spot?',
                  isUnread: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChatSellerScreen(), // Redirect to chat_seller.dart
                      ),
                    );
                  },
                ),
                MessageItem(
                  userName: 'Buyer 2',
                  message: 'Im sorry, but the shipping process could ta...',
                  isUnread: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChatSellerScreen(), // You can adjust this as needed
                      ),
                    );
                  },
                ),
                // ... rest of the message items can be similarly configured
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageItem extends StatelessWidget {
  final String userName;
  final String message;
  final bool isUnread;
  final VoidCallback onTap;

  const MessageItem({
    super.key,
    required this.userName,
    required this.message,
    this.isUnread = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: const Color(0xFF4A6741),
              radius: 20,
              child: Icon(
                Icons.person,
                size: 18,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            title: Text(
              userName,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Color(0xFF4A6741),
              ),
            ),
            subtitle: Text(
              message,
              style: TextStyle(
                color: Colors.black87.withOpacity(0.7),
                overflow: TextOverflow.ellipsis,
              ),
              maxLines: 1,
            ),
            trailing: isUnread
                ? const Icon(
                    Icons.notifications,
                    color: Color(0xFF4A6741),
                  )
                : null,
          ),
          const Divider(height: 1),
        ],
      ),
    );
  }
}