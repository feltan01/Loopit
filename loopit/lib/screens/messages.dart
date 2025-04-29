import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:loopit/screens/home_page.dart';
import '../models/user.dart';
import '../models/conversation.dart';
import '../services/api_services.dart';
import 'chat_buyer.dart';
import 'package:shared_preferences/shared_preferences.dart';  // Import shared_preferences

class MessagesPage extends StatefulWidget {
  final User currentUser;

  const MessagesPage({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Conversation> _conversations = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadConversations();

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  Future<void> _loadConversations() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get token from SharedPreferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');
      print('Token: $token');  // Menambahkan log di sini untuk memastikan token diterima
      if (token == null) {
        throw Exception('No token found. Please log in again.');
      }

      final conversations = await ApiServices.getConversations();
      print('Conversations: $conversations');  // Log percakapan yang diambil dari API

      setState(() {
        _conversations = conversations;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _conversations = []; // Ensure empty list if load fails
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load conversations: $e'),
            action: SnackBarAction(
              label: 'Login Again',
              onPressed: () {
                // Navigate back to login page
                Navigator.of(context).pushReplacementNamed('/login');
              },
            ),
          ),
        );
      }
    }
  }

  List<Conversation> get _filteredConversations {
    if (_searchQuery.isEmpty) return _conversations;

    return _conversations.where((conversation) {
      final otherUser = conversation.participants.firstWhere(
        (user) => user.id != widget.currentUser.id,
        orElse: () => User(id: -1, username: 'Unknown', email: ''),
      );
      return otherUser.username.toLowerCase().contains(_searchQuery);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
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
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredConversations.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'No conversations yet',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadConversations,
                        child: ListView.builder(
                          itemCount: _filteredConversations.length,
                          itemBuilder: (context, index) {
                            final conversation = _filteredConversations[index];
                            final otherUser = conversation.participants.firstWhere(
                              (user) => user.id != widget.currentUser.id,
                              orElse: () => User(id: -1, username: 'Unknown', email: ''),
                            );
                            final lastMessage = conversation.lastMessage;
                            final unreadCount = conversation.unreadCount;

                            return MessageItem(
                              userName: otherUser.username,
                              message: lastMessage?.text ?? 'No messages yet',
                              messageTime: lastMessage?.createdAt ?? DateTime.now(),
                              isUnread: lastMessage != null &&
                                  lastMessage.isUnread &&
                                  !lastMessage.isFromCurrentUser(widget.currentUser.id),
                              unreadCount: unreadCount,
                              isTyping: false, // You can hook this with socket data later
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatBuyerScreen(
                                      conversationId: conversation.id,
                                      otherUser: otherUser,
                                      currentUser: widget.currentUser,
                                    ),
                                  ),
                                ).then((_) => _loadConversations());
                              },
                            );
                          },
                        ),
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
  final DateTime messageTime;
  final bool isUnread;
  final int unreadCount;
  final bool isTyping;
  final VoidCallback onTap;

  const MessageItem({
    Key? key,
    required this.userName,
    required this.message,
    required this.messageTime,
    this.isUnread = false,
    this.unreadCount = 0,
    this.isTyping = false,
    required this.onTap,
  }) : super(key: key);

  String _getMessagePreview() {
    if (message.startsWith('[image]')) return '📷 Photo';
    return message;
  }

  String _getTimeAgo() {
    return timeago.format(messageTime);
  }

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
              child: Text(
                userName.isNotEmpty ? userName[0].toUpperCase() : '?',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.bold,
                ),
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
              isTyping ? 'Typing...' : _getMessagePreview(),
              style: TextStyle(
                color: Colors.black87.withOpacity(0.7),
                fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: unreadCount > 0
                ? Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFF4A6741),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$unreadCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  )
                : Text(
                    _getTimeAgo(),
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
          ),
          const Divider(height: 1),
        ],
      ),
    );
  }
}
