import 'user.dart';
import 'offer.dart';

class Message {
  final int id;
  final int conversationId;
  final User sender;
  final String text;
  final DateTime createdAt;
  final Offer? offer;
  final bool isUnread;  // Add this field

  Message({
    required this.id,
    required this.conversationId,
    required this.sender,
    required this.text,
    required this.createdAt,
    this.offer,
    this.isUnread = false,  // Default to false
  });

  factory Message.fromJson(Map<String, dynamic> json) {
  try {
    // Check if required fields exist
    if (json['id'] == null) throw Exception('Message ID is null');
    if (json['conversation'] == null) throw Exception('Conversation ID is null');
    if (json['sender'] == null) throw Exception('Sender is null');
    if (json['created_at'] == null) throw Exception('Created at is null');
    
    Offer? messageOffer;
    if (json['offer'] != null) {
      try {
        messageOffer = Offer.fromJson(json['offer']);
      } catch (offerError) {
        print('Error parsing offer: $offerError');
        print('Offer JSON: ${json['offer']}');
        // Continue without the offer rather than failing the whole message
        messageOffer = null;
      }
    }
    
    return Message(
      id: json['id'],
      conversationId: json['conversation'],
      sender: User.fromJson(json['sender']),
      text: json['text'] ?? '', // Handle null text
      createdAt: DateTime.parse(json['created_at']),
      offer: messageOffer,
      isUnread: json['is_unread'] ?? false,
    );
  } catch (e) {
    print('Error parsing message: $e');
    print('Problem JSON: $json');
    rethrow; // Re-throw to be caught by the caller
  }
}

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversation': conversationId,
      'sender': sender.toJson(),
      'text': text,
      'created_at': createdAt.toIso8601String(),
      'offer': offer?.toJson(),
      'is_unread': isUnread,  // Include in JSON
    };
  }

  // Helper function to check if message is from current user
  bool isFromCurrentUser(int currentUserId) {
    return sender.id == currentUserId;
  }
}