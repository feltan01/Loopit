import 'package:flutter/material.dart';
import 'home_page.dart';
import 'chat_buyer.dart'; // Add this import

class MessagesPage extends StatelessWidget {
  final List<MessageItem> messages = [
    MessageItem(
        sender: 'User 2',
        message: 'Good Morning! are you taking any offer for...',
        type: MessageType.incoming),
    MessageItem(
        sender: 'Buyer 1',
        message: 'Would you mind if i pay it on the spot?',
        type: MessageType.incoming),
    MessageItem(
        sender: 'Buyer 2',
        message: 'Im sorry, but the shipping process could ta...',
        type: MessageType.incoming),
    MessageItem(
        sender: 'Seller 2',
        message: 'Thank You!!!',
        type: MessageType.outgoing),
    MessageItem(
        sender: 'Seller 3',
        message: 'Do you have it on green?',
        type: MessageType.outgoing),
    MessageItem(
        sender: 'Buyer 3',
        message: 'I like this one.',
        type: MessageType.incoming),
    MessageItem(
        sender: 'Seller 4',
        message: 'I prefer if you raise your offer',
        type: MessageType.outgoing),
    MessageItem(sender: 'Buyer 4', message: '', type: MessageType.incoming),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
        title: Text(
          'Messages',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search direct messages',
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Color(0xFFEAF3DC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Message List
          Expanded(
            child: ListView.separated(
              itemCount: messages.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: Colors.grey[300],
                indent: 80,
              ),
              itemBuilder: (context, index) {
                return _buildMessageTile(context, messages[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageTile(BuildContext context, MessageItem message) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        backgroundColor: Color(0xFFEAF3DC),
        child: Icon(Icons.person, color: Color(0xFF4A6741)),
      ),
      title: Text(
        message.sender,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      subtitle: Text(
        message.message,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.grey),
      ),
      trailing: message.sender != 'User 2'
          ? Icon(Icons.notifications, color: Color(0xFF4A6741))
          : null,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatBuyerScreen()),
        );
      },
    );
  }
}

enum MessageType { incoming, outgoing }

class MessageItem {
  final String sender;
  final String message;
  final MessageType type;

  MessageItem(
      {required this.sender, required this.message, required this.type});
}
