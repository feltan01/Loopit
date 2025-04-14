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
    return Message(
      id: json['id'],
      conversationId: json['conversation'],
      sender: User.fromJson(json['sender']),
      text: json['text'],
      createdAt: DateTime.parse(json['created_at']),
      offer: json['offer'] != null ? Offer.fromJson(json['offer']) : null,
      isUnread: json['is_unread'] ?? false,  // Parse from JSON
    );
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