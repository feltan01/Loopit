import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/user.dart';
import '../models/message.dart';
import '../models/product.dart';
import '../models/offer.dart';
import '../services/api_services.dart';
import 'checkout_page.dart';

class ChatBuyerScreen extends StatefulWidget {
  final int conversationId;
  final User currentUser;
  final User otherUser;
  final String? productName;
  final String? productPrice;
  final String? productImageUrl;
  final String? initialMessage; // ➡️ Tambah untuk support pesan pertama

  const ChatBuyerScreen({
    Key? key,
    required this.conversationId,
    required this.currentUser,
    required this.otherUser,
    this.productName,
    this.productPrice,
    this.productImageUrl,
    this.initialMessage, // ➡️ Tambah untuk support pesan pertama
  }) : super(key: key);

  @override
  State<ChatBuyerScreen> createState() => _ChatBuyerScreenState();
}

class _ChatBuyerScreenState extends State<ChatBuyerScreen> {
  final List<Message> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final Color _themeGreen = const Color(0xFF8DAB87);
  final Color _lightGreen = const Color(0xFFE6F4E6);

  @override
  void initState() {
    super.initState();
    if (widget.initialMessage != null && widget.initialMessage!.isNotEmpty) {
      _messages.add(
        Message(
          id: DateTime.now().millisecondsSinceEpoch,
          conversationId: widget.conversationId,
          sender: widget.currentUser,
          text: widget.initialMessage!,
          createdAt: DateTime.now(),
          isUnread: false,
        ),
      );

      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          _messages.add(
            Message(
              id: DateTime.now().millisecondsSinceEpoch + 1,
              conversationId: widget.conversationId,
              sender: widget.otherUser,
              text: 'Hallo!!',
              createdAt: DateTime.now(),
              isUnread: false,
            ),
          );
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF5EB),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: _themeGreen.withOpacity(0.7),
              child: Text(
                widget.otherUser.username.substring(0, 1).toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
              radius: 20,
            ),
            const SizedBox(width: 10),
            Text(
              'User ${widget.otherUser.id}',
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) => _buildMessageItem(_messages[index], screenWidth),
            ),
          ),
          _buildTextComposer(),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFEEEEEE), width: 1),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            OutlinedButton(
              onPressed: () => _showBargainBottomSheet(),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                side: BorderSide(color: _themeGreen),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              ),
              child: Text(
                'Bargain price',
                style: TextStyle(color: _themeGreen, fontSize: 14),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F9F0),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  controller: _textController,
                  decoration: const InputDecoration(
                    hintText: 'Type a message',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                color: _themeGreen,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () {
                  if (_textController.text.trim().isEmpty) return;
                  setState(() {
                    _messages.add(
                      Message(
                        id: DateTime.now().millisecondsSinceEpoch,
                        conversationId: widget.conversationId,
                        sender: widget.currentUser,
                        text: _textController.text.trim(),
                        createdAt: DateTime.now(),
                        isUnread: false,
                      ),
                    );
                  });
                  _textController.clear();
                  _scrollToBottom();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBargainBottomSheet() {
    final offerController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.25,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: StatefulBuilder(
              builder: (context, setSheetState) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Enter your offer price:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: offerController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          hintText: 'Rp',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            final amount = double.parse(offerController.text.replaceAll('.', ''));

                            final product = Product(
                              id: 1,
                              name: widget.productName ?? 'Unknown Product',
                              brand: 'Unknown',
                              price: double.tryParse(widget.productPrice?.replaceAll('Rp', '').replaceAll('.', '').trim() ?? '0') ?? 0,
                              description: '',
                              image: widget.productImageUrl ?? '',
                              seller: widget.otherUser,
                            );

                            await ApiServices.makeOffer(
                              widget.conversationId,
                              product.id,
                              amount,
                            );

                            final staticOffer = Offer.createStatic(
                              product: product,
                              buyer: widget.currentUser,
                              amount: amount,
                              conversationId: widget.conversationId,
                            );

                            // Close bottom sheet first for better UX
                            // Already handled above

                            // Add delay before auto accepting
                            await Future.delayed(const Duration(seconds: 1));
                            await _autoAcceptOffer(staticOffer);
                            
                            setState(() {
                              _messages.addAll([
                                Message(
                                  id: DateTime.now().millisecondsSinceEpoch,
                                  conversationId: widget.conversationId,
                                  sender: widget.otherUser, // accepted bubble comes from the seller (otherUser)
                                  text: "Accepted",
                                  createdAt: DateTime.now(),
                                  offer: staticOffer,
                                  isUnread: false,
                                ),
                                Message(
                                  id: DateTime.now().millisecondsSinceEpoch + 1,
                                  conversationId: widget.conversationId,
                                  sender: widget.currentUser,
                                  text: "[checkout]",
                                  createdAt: DateTime.now(),
                                  offer: staticOffer,
                                  isUnread: false,
                                ),
                              ]);
                            });

                            Future.microtask(() {
                              if (context.mounted) Navigator.pop(context);
                            });

                            if (!mounted) return;
                            _scrollToBottom();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _themeGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Send Offer'),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _autoAcceptOffer(Offer offer) async {
    try {
      await ApiServices.respondToOffer(offer.id, 'ACCEPTED');
    } catch (e) {
      print('Failed to auto accept offer: $e');
    }
  }

  void _scrollToBottom() {
    print('Scroll to bottom');
  }

  Widget _buildMessageItem(Message message, double screenWidth) {
    final bool isMe = message.isFromCurrentUser(widget.currentUser.id);

    if (message.text == '[checkout]' && message.offer != null) {
      final offer = message.offer!;
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F9F0),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Price changed',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    offer.product.fullImageUrl,
                    height: 100,
                    width: 90,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 100,
                      width: 90,
                      color: Colors.grey[300],
                      child: const Center(child: Icon(Icons.broken_image)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jacket Cream color',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        'Brand ABC',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Rp ${NumberFormat('#,###', 'id').format(offer.amount.toInt()).replaceAll(',', '.')}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold, 
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CheckoutPage(offer: message.offer!),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: _themeGreen,
                          side: BorderSide(color: _themeGreen),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                        ),
                        child: const Text('Check Out'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    if (message.offer != null && message.text == "Accepted") {
      final offer = message.offer!;
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        alignment: Alignment.center,
        child: Container(
          width: screenWidth * 0.85,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _themeGreen.withOpacity(0.7),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      offer.product.fullImageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 80,
                        width: 80,
                        color: Colors.grey[300],
                        child: const Center(child: Icon(Icons.broken_image)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Jacket Cream color',
                          style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'Brand ABC',
                          style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.8)),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Rp ${NumberFormat('#,###', 'id').format(offer.amount.toInt()).replaceAll(',', '.')}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Accepted',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: screenWidth * 0.75),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isMe 
                ? _lightGreen
                : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: isMe ? null : Border.all(color: Colors.grey.shade300),
            ),
            child: Text(
              message.text,
              style: const TextStyle(color: Colors.black87, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}