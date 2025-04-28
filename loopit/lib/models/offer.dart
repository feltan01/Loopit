import 'product.dart';
import 'user.dart';

class Offer {
  final int id;
  final int conversationId;
  final int messageId;
  final Product product;
  final User buyer;
  final double amount;
  final String status; // 'PENDING', 'ACCEPTED', 'REJECTED'
  final DateTime createdAt;

  Offer({
    required this.id,
    required this.conversationId,
    required this.messageId,
    required this.product,
    required this.buyer,
    required this.amount,
    required this.status,
    required this.createdAt,
  });

  /// Factory constructor to create an Offer from JSON
  factory Offer.fromJson(Map<String, dynamic> json) {
    try {
      // Check for nulls and throw if any required field is missing
      if (json['id'] == null) throw Exception('Offer ID is null');
      if (json['conversation'] == null) throw Exception('Conversation ID is null');
      if (json['message'] == null) throw Exception('Message ID is null');
      if (json['product'] == null) throw Exception('Product is null');
      if (json['buyer'] == null) throw Exception('Buyer is null');
      if (json['amount'] == null) throw Exception('Amount is null');
      if (json['status'] == null) throw Exception('Status is null');
      if (json['created_at'] == null) throw Exception('Created at is null');

      return Offer(
        id: json['id'],
        conversationId: json['conversation'],
        messageId: json['message'],
        product: Product.fromJson(json['product']),
        buyer: User.fromJson(json['buyer']),
        amount: double.parse(json['amount'].toString()),
        status: json['status'],
        createdAt: DateTime.parse(json['created_at']),
      );
    } catch (e) {
      print('Error parsing offer: $e');
      print('Problem Offer JSON: $json');
      rethrow;
    }
  }

  /// Convert Offer to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversation': conversationId,
      'message': messageId,
      'product': product.toJson(),
      'buyer': buyer.toJson(),
      'amount': amount,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Helper properties for status checking
  bool get isPending => status == 'PENDING';
  bool get isAccepted => status == 'ACCEPTED';
  bool get isRejected => status == 'REJECTED';

  /// Named constructor for creating static offers for auto-accept
  factory Offer.createStatic({
    required Product product,
    required User buyer,
    required double amount,
    required int conversationId,
  }) {
    return Offer(
      id: DateTime.now().millisecondsSinceEpoch, // Temporary ID
      conversationId: conversationId,
      messageId: 0, // Dummy message ID (since not from server)
      product: product,
      buyer: buyer,
      amount: amount,
      status: 'PENDING', // Initially pending, will be auto-accepted
      createdAt: DateTime.now(),
    );
  }
}
