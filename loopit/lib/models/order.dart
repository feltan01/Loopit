import 'user.dart';
import 'product.dart';

class Order {
  final int id;
  final int offerId;
  final User buyer;
  final User seller;
  final Product product;
  final double amount;
  final String status; // 'PENDING', 'PAID', 'SHIPPED', 'DELIVERED', 'CANCELLED'
  final DateTime createdAt;
  final DateTime updatedAt;

  Order({
    required this.id,
    required this.offerId,
    required this.buyer,
    required this.seller,
    required this.product,
    required this.amount,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      offerId: json['offer'],
      buyer: User.fromJson(json['buyer']),
      seller: User.fromJson(json['seller']),
      product: Product.fromJson(json['product']),
      amount: double.parse(json['amount'].toString()),
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'offer': offerId,
      'buyer': buyer.toJson(),
      'seller': seller.toJson(),
      'product': product.toJson(),
      'amount': amount,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  bool get isPending => status == 'PENDING';
  bool get isPaid => status == 'PAID';
  bool get isShipped => status == 'SHIPPED';
  bool get isDelivered => status == 'DELIVERED';
  bool get isCancelled => status == 'CANCELLED';
}