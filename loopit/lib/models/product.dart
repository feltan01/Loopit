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
    print("🔍 Parsing product from JSON: ${json['id']}");
    print("🔍 Image in JSON: ${json['image']}");
    
    return Product(
      id: json['id'],
      name: json['name'] ?? '',
      brand: json['brand'] ?? '',
      price: double.parse((json['price'] ?? 0).toString()),
      description: json['description'],
      seller: User.fromJson(json['seller']),
      image: json['image'], 
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
    );
  } catch (e) {
    print('❌ Error parsing product: $e');
    print('❌ Problem Product JSON: $json');
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
  // Add detailed debugging
  print("🔍 Product: $name (ID: $id)");
  print("🔍 Image value: $image");
  
  // Handle null image
  if (image == null) {
    print("⚠️ Image is null, using placeholder");
    return 'https://via.placeholder.com/150';
  }
  
  // Safe to use the non-null image from here
  final String imageStr = image!;
  
  // Check if the image already contains the full URL
  if (imageStr.startsWith('http')) {
    print("✅ Image is already a full URL: $imageStr");
    return imageStr;
  }
  
  // For local development server
  const String baseUrl = 'http://192.168.0.30:8000';
  
  // Check if the image path already includes /media/
  if (imageStr.startsWith('/media/')) {
    final url = '$baseUrl$imageStr';
    print("✅ Adding base URL to media path: $url");
    return url;
  }
  
  // Default approach - use the image string as is with the server base URL
  final url = '$baseUrl/media/product_images/$imageStr';
  print("✅ Using default image path construction: $url");
  return url;
}
}