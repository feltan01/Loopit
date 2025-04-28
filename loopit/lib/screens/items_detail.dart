import 'package:flutter/material.dart';
import 'package:loopit/screens/chat_buyer.dart';
import 'package:loopit/screens/fashion_page.dart';
import 'package:loopit/screens/home_page.dart';
import 'package:loopit/screens/saved_products.dart';
import 'package:loopit/screens/api_service.dart'; // Import API service
import 'package:loopit/services/api_services.dart';
import 'dart:convert';



// Import the proper User model
import 'package:loopit/models/user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
    );
  }
}

// Import ListingModel from your_listing.dart to use the same model
class ListingModel {
  final String title;
  final String subtitle;
  final String price;
  final String condition;
  final String imageUrl;
  final int id;
  final String category;
  final String description;
  final String productAge;

  ListingModel({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.condition,
    required this.imageUrl,
    required this.id,
    required this.category,
    required this.description,
    required this.productAge,
  });
}

class ItemsDetails extends StatefulWidget {
  final String name;
  final String price;
  final String condition;
  final String image;
  // Add productId parameter for future backend integration
  final String? productId;
  final String description;

  const ItemsDetails({
    Key? key,
    required this.name,
    required this.price,
    required this.condition,
    required this.image,
    this.productId,
    required this.description
  }) : super(key: key);

  @override
  State<ItemsDetails> createState() => _ItemsDetailsState();
}

class _ItemsDetailsState extends State<ItemsDetails> {
  bool isFavorite = false;
  // Add a controller for the message text field
  final TextEditingController _messageController = TextEditingController();
  // List to store fetched listings
  List<ListingModel> _otherProducts = [];
  bool _isLoading = true;

  // Create sample users for chat functionality - FIXED to use the correct User model
  final User _currentUser = User(
    id: 123,
    username: 'Current User',
    email: 'current@example.com',
  );

  final User _sellerUser = User(
    id: 1,
    username: 'User 1',
    email: 'seller@example.com',
  );

  // Sample conversation ID
  final int _conversationId = 1;

  @override
  void initState() {
    super.initState();
    _fetchOtherProducts();
  }

  // Method to fetch other products from the API service
Future<int> _createConversation(int sellerId) async {
  final response = await ApiServices.post(
    '/chat/conversations/start/',
    body: {
      "user_id": sellerId,
    },
  );

  print('Status Code: ${response.statusCode}');
  print('Body: ${response.body}');

  if (response.statusCode == 200 || response.statusCode == 201) {
    final data = jsonDecode(response.body);
    return data['id'];
  } else {
    // Ini supaya kalau error, lebih jelas kenapa
    try {
      final error = jsonDecode(response.body);
      throw Exception('Failed: ${error['error'] ?? response.body}');
    } catch (e) {
      // Kalau JSON parsing gagal
      throw Exception('Failed with status ${response.statusCode}: ${response.body}');
    }
  }
}



  void _fetchOtherProducts() async {
    try {
      final data = await ApiService.getMyListings(); // Using the same API method from YourListingPage
      
      setState(() {
        _otherProducts = data.map<ListingModel>((item) {
          String imageUrl;
          if (item['images'].isNotEmpty && item['images'][0]['image'] != null) {
            final baseUrl = 'http://192.168.18.65:8000'; // Same base URL from your_listing.dart
            imageUrl = '$baseUrl${item['images'][0]['image']}';
          } else {
            imageUrl = 'https://via.placeholder.com/100';
          }

          return ListingModel(
            id: item['id'],
            title: item['title'],
            subtitle: item['description'],
            price: item['price'].toString(),
            condition: item['condition'],
            category: item['category'],
            description: item['description'],
            productAge: item['product_age'],
            imageUrl: imageUrl,
          );
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching other products: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    // Dispose the controller when the widget is removed
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9), // Light green background color
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back,
                color: Color.fromARGB(255, 57, 110, 58), size: 20),
            padding: EdgeInsets.zero,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              );
            },
          ),
        ),
        title: Container(
          height: 38,
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              prefixIcon: const Icon(Icons.search,
                  size: 20, color: Color.fromARGB(255, 57, 110, 58)),
              hintText: 'Search it, Loop it',
              hintStyle: const TextStyle(
                  fontSize: 14, color: Color.fromARGB(255, 57, 110, 58)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        actions: [
          // Updated heart button with circular background - fixed styling
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9), // Light green background color
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.favorite_border,
                  color: Color.fromARGB(255, 57, 110, 58), size: 20),
              iconSize: 20,
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SavedProductPage(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 8), // Add a bit of padding on the right side
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Container(
                  height: 320,
                  color: const Color(0xFFFCECEE),
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  child: Center(
                    child: widget.image.startsWith('http')
                        ? Image.network(
                            widget.image,
                            fit: BoxFit.contain,
                          )
                        : Image.asset(
                            widget.image,
                            fit: BoxFit.contain,
                          ),
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 140,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 16,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.arrow_forward_ios,
                          size: 16, color: Colors.green),
                      onPressed: () {
                        // Next image navigation logic here
                      },
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.price,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Message input area
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Send seller a message',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                // Replace static text with TextField
                                child: TextField(
                                  controller: _messageController,
                                  decoration: const InputDecoration(
                                    hintText:
                                        'Hi, is this item still available?',
                                    hintStyle: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Updated Send button with Ink and InkWell for press effect
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () async {
                                  if (widget.productId == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Product ID not available')),
                                    );
                                    return;
                                  }

                                  try {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (_) => const Center(child: CircularProgressIndicator()),
                                    );

                                    final conversationId = await _createConversation(
                                      _sellerUser.id,
                                    );

                                    if (mounted) Navigator.pop(context);

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatDetailScreen(
                                          conversationId: conversationId,
                                          otherUser: _sellerUser,
                                          currentUser: _currentUser,
                                          productImageUrl: widget.image,
                                        ),
                                      ),
                                    );
                                  } catch (e) {
                                    if (mounted) Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Failed: $e')),
                                    );
                                  }
                                },

                                // Add visual feedback effects
                                splashColor: Colors.white.withOpacity(0.3),
                                highlightColor: Colors.green.shade700,
                                borderRadius: BorderRadius.circular(16),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 38, 88, 38),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  child: const Text(
                                    'Send',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Action buttons - MODIFIED TO HAVE CIRCULAR HOVER EFFECTS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Send offer button with circular hover
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 3 - 16,
                        child: Column(
                          children: [
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  // Navigate to ChatDetailScreen with proper User objects
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatDetailScreen(
                                        conversationId: _conversationId,
                                        otherUser: _sellerUser,
                                        currentUser: _currentUser,
                                      ),
                                    ),
                                  );
                                },
                                // Circular splash and highlight effects
                                borderRadius: BorderRadius.circular(20),
                                splashColor: Colors.green.withOpacity(0.3),
                                highlightColor: Colors.green.withOpacity(0.1),
                                child: Ink(
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFE8F5E9),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.local_offer_outlined,
                                        color: Color.fromARGB(255, 38, 87, 39),
                                        size: 20),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Send offer',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),

                      // Share button with circular hover
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 3 - 16,
                        child: Column(
                          children: [
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  // Add your share logic here
                                  // This would connect to backend sharing feature
                                },
                                // Circular splash and highlight effects
                                borderRadius: BorderRadius.circular(20),
                                splashColor: Colors.green.withOpacity(0.3),
                                highlightColor: Colors.green.withOpacity(0.1),
                                child: Ink(
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFE8F5E9),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.share_outlined,
                                        color: Color.fromARGB(255, 37, 81, 39),
                                        size: 20),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Share',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),

                      // Save button with circular hover
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 3 - 16,
                        child: Column(
                          children: [
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  // Logic to save this item to favorites
                                  // This would connect to backend save feature
                                  setState(() {
                                    isFavorite = !isFavorite;
                                  });
                                },
                                // Circular splash and highlight effects
                                borderRadius: BorderRadius.circular(20),
                                splashColor: Colors.green.withOpacity(0.3),
                                highlightColor: Colors.green.withOpacity(0.1),
                                child: Ink(
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFE8F5E9),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Icon(
                                      isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color:
                                          const Color.fromARGB(255, 42, 87, 44),
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Save',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Description and Condition sections
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Description section
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Description',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.description ?? 'No description available',
                              style: const TextStyle(fontSize: 12),
                            ),
                            // Removed "Listed on 23rd January 2025" text
                          ],
                        ),
                      ),
                      // Condition section
                      Column(
                        children: [
                          const Text(
                            'Condition',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: _getConditionColor().withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                _getConditionPercentage(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _getConditionColor(),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _getConditionText(),
                            style: TextStyle(
                              color: _getConditionColor(),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Seller Information
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Seller Information',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.purple.shade100,
                            radius: 20,
                            child: Text(
                              _sellerUser.username.isNotEmpty
                                  ? _sellerUser.username[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _sellerUser.username,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: const [
                                  Icon(Icons.star,
                                      color: Colors.amber, size: 16),
                                  Icon(Icons.star,
                                      color: Colors.amber, size: 16),
                                  Icon(Icons.star,
                                      color: Colors.amber, size: 16),
                                  Icon(Icons.star,
                                      color: Colors.amber, size: 16),
                                  Icon(Icons.star_half,
                                      color: Colors.amber, size: 16),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // OTHER PRODUCTS SECTION - UPDATED WITH REAL DATA FROM API
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Other Products',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Show loading indicator while data is being fetched
                      _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _otherProducts.isEmpty
                              ? const Center(
                                  child: Text('No other products available'))
                              : GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 8,
                                    childAspectRatio: 0.75,
                                  ),
                                  itemCount: _otherProducts.length > 4
                                      ? 4
                                      : _otherProducts.length, // Limit to 4 items
                                  itemBuilder: (context, index) {
                                    // Get the product from the fetched data
                                    final product = _otherProducts[index];

                                    // Get badge color based on condition
                                    Color badgeColor;
                                    Color badgeTextColor;
                                    final conditionText = product.condition;
                                    if (conditionText.contains('Like New') ||
                                        conditionText.contains('99') ||
                                        conditionText.contains('95')) {
                                      badgeColor = Colors.green.shade100;
                                      badgeTextColor = Colors.green.shade800;
                                    } else if (conditionText.contains('Good') ||
                                        conditionText.contains('85') ||
                                        conditionText.contains('80')) {
                                      badgeColor = Colors.blue.shade100;
                                      badgeTextColor = Colors.blue.shade800;
                                    } else {
                                      badgeColor = Colors.amber.shade100;
                                      badgeTextColor = Colors.amber.shade800;
                                    }

                                    return _buildProductItem(
                                      product.id.toString(),
                                      product.title,
                                      product.price,
                                      product.condition,
                                      badgeColor,
                                      badgeTextColor,
                                      product.imageUrl,
                                      product.description,
                                    );
                                  },
                                ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Updated product item builder to use real data
Widget _buildProductItem(
  String id,
  String title,
  String price,
  String condition,
  Color badgeColor,
  Color badgeTextColor,
  String imageUrl,
  String description,
) {
  // Fix for duplicate base URL issue
  // Check if imageUrl already contains the base URL and fix it if needed
  const String baseUrl = 'http:/192.168.18.65:8000';
  String processedImageUrl = imageUrl;
  
  // Prevent duplicate base URLs
  if (imageUrl.contains(baseUrl + baseUrl)) {
    processedImageUrl = imageUrl.replaceFirst(baseUrl + baseUrl, baseUrl);
  } else if (!imageUrl.startsWith('http') && !imageUrl.startsWith('assets/')) {
    // If it's a relative path without the base URL, add the base URL
    processedImageUrl = baseUrl + imageUrl;
  }
  
  // Debug output
  print('Original imageUrl: $imageUrl');
  print('Processed imageUrl: $processedImageUrl');

  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: () {
        // Navigation to the item details using the same ItemsDetails widget
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ItemsDetails(
              name: title,
              price: price,
              condition: condition,
              image: processedImageUrl, // Pass the processed image URL
              productId: id,
              description: description,
            ),
          ),
        );
      },
      // Visual feedback effects
      borderRadius: BorderRadius.circular(8),
      splashColor: Colors.green.withOpacity(0.3),
      highlightColor: Colors.green.withOpacity(0.1),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            AspectRatio(
              aspectRatio: 1.0, // Square image
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFCECEE), // Match the main product background
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: Center(
                  // Handle image based on URL format (network or asset)
                  child: processedImageUrl.startsWith('http')
                      ? Image.network(
                          processedImageUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            print('Error loading image: $error');
                            return Image.asset(
                              'assets/images/fallback.png',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.image_not_supported, size: 40);
                              },
                            );
                          },
                        )
                      : Image.asset(
                          processedImageUrl.isNotEmpty ? processedImageUrl : 'assets/images/fallback.png',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.image_not_supported, size: 40);
                          },
                        ),
                ),
              ),
            ),
            // Product details
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    price,
                    style: const TextStyle(fontSize: 10),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Condition badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          color: badgeColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          condition,
                          style: TextStyle(
                            fontSize: 9,
                            color: badgeTextColor,
                          ),
                        ),
                      ),
                      // Options menu button
                      GestureDetector(
                        onTap: () {
                          // Show product options bottom sheet
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return SafeArea(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(
                                      leading:
                                          const Icon(Icons.favorite_border),
                                      title: const Text('Add to favorites'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        // Future backend integration: Save to favorites
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.share),
                                      title: const Text('Share product'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        // Future backend integration: Share product
                                      },
                                    ),
                                    ListTile(
                                      leading:
                                          const Icon(Icons.report_outlined),
                                      title: const Text('Report item'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        // Future backend integration: Report product
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: const Icon(Icons.more_horiz, size: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  // Helper methods for condition display
  String _getConditionPercentage() {
    if (widget.condition.contains('%')) {
      return widget.condition.split('%')[0] + '%';
    }
    return '77%'; // Default if percentage not found
  }

  String _getConditionText() {
    if (widget.condition.contains('%')) {
      final parts = widget.condition.split('%');
      if (parts.length > 1) {
        return parts[1].trim();
      }
    }
    return 'Good'; // Default if condition text not found
  }

  Color _getConditionColor() {
    final percentage =
        int.tryParse(_getConditionPercentage().replaceAll('%', '')) ?? 0;

    if (percentage >= 90) {
      return Colors.green;
    } else if (percentage >= 75) {
      return Colors.amber;
    } else {
      return Colors.orange;
    }
  }
}