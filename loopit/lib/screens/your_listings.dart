import 'package:flutter/material.dart';
import 'package:loopit/screens/api_service.dart';
import 'edit_listing.dart';
import 'new_listing.dart';
import 'profile.dart';

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

class YourListingPage extends StatefulWidget {
  const YourListingPage({super.key});

  @override
  _YourListingPageState createState() => _YourListingPageState();
}

class _YourListingPageState extends State<YourListingPage> {
  final TextEditingController _searchController = TextEditingController();
  final String baseUrl = 'http://192.168.18.65:8000';
  final String defaultImage = 'https://via.placeholder.com/100';

  String getImageUrl(String? imagePath) {
    if (imagePath != null && imagePath.isNotEmpty) {
      return '$baseUrl$imagePath';
    } else {
      return defaultImage;
    }
  }

  List<ListingModel> _listings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchListings();
  }

  void _fetchListings() async {
    const String baseUrl = 'http://192.168.100.29:8000';

    try {
      final data = await ApiService.getMyListings();

      print(data);
      // Debugging - print image URLs
      for (var item in data) {
        if (item['images'].isNotEmpty) {
          print("🔗 Image URL: $baseUrl${item['images'][0]['image']}");
        } else {
          print("❌ No image for item: ${item['title']}");
        }
      }

      setState(() {
        _listings = data.map<ListingModel>((item) {
          String imageUrl;
          if (item['images'].isNotEmpty && item['images'][0]['image'] != null) {
            imageUrl = item['images'][0]['image'];
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
            imageUrl: imageUrl, // Make sure you're using this correctly
          );
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching listings: $e');
      setState(() => _isLoading = false);
    }
  }

  void _deleteListing(int index) async {
    final listingId = _listings[index].id;

    try {
      final success = await ApiService.deleteListing(listingId);
      if (success) {
        setState(() {
          _listings.removeAt(index);
        });

        // Optionally show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Listing deleted successfully')),
        );
      } else {
        // Show error if delete failed
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete listing')),
        );
      }
    } catch (e) {
      print('Delete error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting listing: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Your Listing',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFE6F2E1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Color(0xFF4E6E39),
                size: 20,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfilePage(),
                  ),
                );
              }),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFE6F2E1),
                    hintText: 'Search your listings',
                    hintStyle: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),

              // Listings
              Expanded(
                child: ListView.builder(
                  itemCount: _listings.length,
                  itemBuilder: (context, index) {
                    final listing = _listings[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              listing
                                  .imageUrl, 
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image_not_supported),
                                );
                              },
                            ),
                          ),

                          const SizedBox(width: 16),

                          // Product details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  listing.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  listing.subtitle,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  listing.price,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE6F2E1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    listing.condition,
                                    style: const TextStyle(
                                      color: Color(0xFF4E6E39),
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // More options button
                          IconButton(
                            icon: const Icon(Icons.more_vert),
                            onPressed: () {
                              // Show options menu
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      leading: const Icon(Icons.edit),
                                      title: const Text('Edit Listing'),
                                      onTap: () async {
                                        Navigator.pop(
                                            context); // Close the bottom sheet

                                        final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditListingPage(
                                              listingId: listing.id,
                                              initialTitle: listing.title,
                                              initialPrice: listing.price,
                                              initialCondition:
                                                  listing.condition,
                                              initialCategory: listing.category,
                                              initialDescription:
                                                  listing.description,
                                              initialProductAge:
                                                  listing.productAge,
                                            ),
                                          ),
                                        );

                                        // ✅ Refresh listings if update was successful
                                        if (result == true) {
                                          _fetchListings();
                                        }
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.delete,
                                          color: Colors.red),
                                      title: const Text('Delete',
                                          style: TextStyle(color: Colors.red)),
                                      onTap: () {
                                        Navigator.pop(context);
                                        // Show delete confirmation
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title:
                                                  const Text('Delete Listing'),
                                              content: const Text(
                                                  'Are you sure you want to delete this listing?'),
                                              actions: [
                                                TextButton(
                                                  child: const Text('Cancel'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                TextButton(
                                                  child: const Text('Delete',
                                                      style: TextStyle(
                                                          color: Colors.red)),
                                                  onPressed: () {
                                                    // Call the delete method
                                                    _deleteListing(index);
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          // Add button
          // Add button
          Positioned(
            right: 16,
            bottom: 16,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFE6F2E1),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.add,
                  color: Color(0xFF4E6E39),
                  size: 30,
                ),
                onPressed: () {
                  // Navigate to create new listing page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NewListingPage(),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
