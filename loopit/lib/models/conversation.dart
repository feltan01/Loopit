import 'user.dart';
import 'message.dart';

class Conversation {
  final int id;
  final List<User> participants;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Message? lastMessage;
  final int unreadCount;

  Conversation({
    required this.id,
    required this.participants,
    required this.createdAt,
    required this.updatedAt,
    this.lastMessage,
    this.unreadCount = 0,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
  return Conversation(
    id: json['id'],
    participants: (json['participants'] as List)
        .map((p) => User.fromJson(p))
        .toList(),
    lastMessage: json['last_message'] != null 
        ? Message.fromJson(json['last_message']) 
        : null,
    unreadCount: json['unread_count'] ?? 0,
    createdAt: DateTime.parse(json['created_at']),
    updatedAt: DateTime.parse(json['updated_at']),
  );
}

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'participants': participants.map((participant) => participant.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'last_message': lastMessage?.toJson(),
      'unread_count': unreadCount,
    };
  }
}