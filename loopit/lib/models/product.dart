import 'user.dart';

class Product {
  final int id;
  final String name;
  final String brand;
  final double price;
  final String? description;
  final User seller;
  final String? image;  // Make this nullable
  final DateTime? createdAt;  // Make this nullable too as it might be missing

  Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    this.description,
    required this.seller,
    this.image,  // No longer required
    this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    try {
      return Product(
        id: json['id'],
        name: json['name'] ?? '',  // Provide default values
        brand: json['brand'] ?? '',
        price: double.parse((json['price'] ?? 0).toString()),
        description: json['description'],
        seller: User.fromJson(json['seller']),
        image: json['image'],  // Can be null now
        createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      );
    } catch (e) {
      print('Error parsing product: $e');
      print('Problem Product JSON: $json');
      rethrow;
    }
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
      'created_at': createdAt?.toIso8601String(),
    };
  }

  String get fullImageUrl {
  // Handle null image
  if (image == null) {
    return 'https://via.placeholder.com/150';
  }
  
  // Safe to use the non-null image from here
  final String imageStr = image!;
  
  // For debugging
  print("Original image path: $imageStr");
  
  // Check if the image already contains the full URL
  if (imageStr.startsWith('http')) {
    return imageStr;
  }
  
  // Check if the image path already includes /media/
  if (imageStr.startsWith('/media/')) {
    return 'http://192.168.18.96:8000$imageStr';
  }
  
  // Try a more general approach - use the image string as is with the server base URL
  return 'http://192.168.18.96:8000/media/product_images/$imageStr';
}
}