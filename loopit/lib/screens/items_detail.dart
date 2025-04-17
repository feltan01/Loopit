import 'package:flutter/material.dart';
import 'package:loopit/screens/chat_buyer.dart';
import 'package:loopit/screens/fashion_page.dart';
import 'package:loopit/screens/saved_products.dart';

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
      home: const ItemsDetails(
        name: 'Jacket Cream color Brand ABC',
        price: 'Rp 250.000',
        condition: '77% Good',
        image: 'assets/images/fs1.png',
      ),
    );
  }
}

class ItemsDetails extends StatefulWidget {
  final String name;
  final String price;
  final String condition;
  final String image;
  // Add productId parameter for future backend integration
  final String? productId;

  const ItemsDetails({
    Key? key,
    required this.name,
    required this.price,
    required this.condition,
    required this.image,
    this.productId,
  }) : super(key: key);

  @override
  State<ItemsDetails> createState() => _ItemsDetailsState();
}

class _ItemsDetailsState extends State<ItemsDetails> {
  bool isFavorite = false;
  // Add a controller for the message text field
  final TextEditingController _messageController = TextEditingController();

  // Create sample users for chat functionality - FIXED to use the correct User model
  final User _currentUser = User(
    id: 123,
    username: 'Current User',
    email: 'current@example.com',
  );
  
  final User _sellerUser = User(
    id: 456,
    username: 'User 1',
    email: 'seller@example.com',
  );
  
  // Sample conversation ID
  final int _conversationId = 1;

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
            icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 57, 110, 58), size: 20),
            padding: EdgeInsets.zero,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FashionPage(),
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
              prefixIcon:
                  const Icon(Icons.search, size: 20, color: Color.fromARGB(255, 57, 110, 58)),
              hintText: 'Search it, Loop it',
              hintStyle: const TextStyle(fontSize: 14, color: Color.fromARGB(255, 57, 110, 58)),
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
                                onTap: () {
                                  // When "Send" button is pressed, navigate to ChatDetailScreen with required parameters
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
                                // Add visual feedback effects
                                splashColor: Colors.white.withOpacity(0.3),
                                highlightColor: Colors.green.shade700,
                                borderRadius: BorderRadius.circular(16),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(255, 38, 88, 38),
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
                                      isFavorite ? Icons.favorite : Icons.favorite_border,
                                      color: const Color.fromARGB(255, 42, 87, 44),
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
                          children: const [
                            Text(
                              'Description',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Size M (38)',
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              'The Material: soft material',
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              'The brand maybe today',
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              'Cream Color',
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              '2 front pockets',
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              'Screen Printing Logo',
                              style: TextStyle(fontSize: 12),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Listed on 23rd January 2025',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
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
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: const [
                                  Icon(Icons.star, color: Colors.amber, size: 16),
                                  Icon(Icons.star, color: Colors.amber, size: 16),
                                  Icon(Icons.star, color: Colors.amber, size: 16),
                                  Icon(Icons.star, color: Colors.amber, size: 16),
                                  Icon(Icons.star_half, color: Colors.amber, size: 16),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // OTHER PRODUCTS SECTION - UPDATED FOR BACKEND INTEGRATION
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
                      // GridView to display products
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: 4, // Number of products to display
                        itemBuilder: (context, index) {
                          // This is where you'd integrate with your backend in the future
                          // For now, using sample data
                          final List<Map<String, dynamic>> products = [
                            {
                              'id': '001',
                              'title': 'Jam Saku 1800',
                              'price': 'Rp 400.000',
                              'condition': '75% Fair',
                              'image': 'assets/images/fs1.png',
                            },
                            {
                              'id': '002',
                              'title': 'Mainan piano anak',
                              'price': 'Rp 150.000',
                              'condition': '95% Like New',
                              'image': 'assets/images/fs2.png',
                            },
                            {
                              'id': '003',
                              'title': 'Hot Toys Ant-Man Figure',
                              'price': 'Rp 2.500.000',
                              'condition': '98% Like New',
                              'image': 'assets/images/fs3.png',
                            },
                            {
                              'id': '004',
                              'title': 'Jam Kate Spade Leather',
                              'price': 'Rp 900.000',
                              'condition': '93% Like New',
                              'image': 'assets/images/fs1.png',
                            },
                          ];

                          final product = products[index];
                          
                          // Get badge color based on condition
                          Color badgeColor;
                          Color badgeTextColor;
                          final conditionText = product['condition'] as String;
                          if (conditionText.contains('Like New')) {
                            badgeColor = Colors.green.shade100;
                            badgeTextColor = Colors.green.shade800;
                          } else if (conditionText.contains('Good')) {
                            badgeColor = Colors.blue.shade100;
                            badgeTextColor = Colors.blue.shade800;
                          } else {
                            badgeColor = Colors.amber.shade100;
                            badgeTextColor = Colors.amber.shade800;
                          }

                          return _buildProductItem(
                            product['id'] as String,
                            product['title'] as String,
                            product['price'] as String,
                            product['condition'] as String,
                            badgeColor,
                            badgeTextColor,
                            product['image'] as String,
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

  // Updated product item builder for easier backend integration
  Widget _buildProductItem(
    String id,
    String title,
    String price,
    String condition,
    Color badgeColor,
    Color badgeTextColor,
    String image,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // Navigation to the item details using the same ItemsDetails widget
          // This is where you'd integrate with your backend
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ItemsDetails(
                name: title,
                price: price,
                condition: condition,
                image: image,
                productId: id, // Pass the ID for future backend integration
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
                    child: image.startsWith('http')
                        ? Image.network(image, fit: BoxFit.contain)
                        : Image.asset(image, fit: BoxFit.contain),
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
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
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
                                        leading: const Icon(Icons.favorite_border),
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
                                        leading: const Icon(Icons.report_outlined),
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
    final percentage = int.tryParse(_getConditionPercentage().replaceAll('%', '')) ?? 0;
    
    if (percentage >= 90) {
      return Colors.green;
    } else if (percentage >= 75) {
      return Colors.amber;
    } else {
      return Colors.orange;
    }
  }
}