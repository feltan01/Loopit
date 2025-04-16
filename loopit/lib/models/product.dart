import 'user.dart';

class Product {
  final int id;
  final String name;
  final String brand;
  final double price;
  final String? description;
  final User seller;
  final String image;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    this.description,
    required this.seller,
    required this.image,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      brand: json['brand'],
      price: double.parse(json['price'].toString()),
      description: json['description'],
      seller: User.fromJson(json['seller']),
      image: json['image'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'price': price,
      'description': description,
      'seller': seller.toJson(),
      'image': image,
      'created_at': createdAt.toIso8601String(),
    };
  }

  String get fullImageUrl {
    return 'http://192.168.0.106:8000$image';
  }
}