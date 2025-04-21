import 'package:flutter/material.dart';
import 'package:loopit/main.dart';
import 'package:loopit/screens/items_detail.dart' as detail; // Added alias to resolve ambiguity
import 'package:loopit/screens/home_page.dart';
import 'package:loopit/screens/saved_products.dart';

class FashionPage extends StatefulWidget {
  final List<Map<String, dynamic>> listings;
  
  const FashionPage({super.key, required this.listings});

  @override
  State<FashionPage> createState() => _FashionPageState();
}

class _FashionPageState extends State<FashionPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<Map<String, dynamic>> _headerData = [
    {
      "title": "Fashion",
      "subtitle": "Styles that speaks, fashion that lasts.",
      "image": "assets/images/fs1.png"
    },
    {
      "title": "Refined Style",
      "subtitle": "Elevate your Wardrobe with new fashion finds.",
      "image": "assets/images/fs2.png"
    },
    {
      "title": "Wardrobe Goals",
      "subtitle": "Trendy, Versatile, and made for you.",
      "image": "assets/images/fs3.png"
    },
  ];
  
  // Filter state variables
  RangeValues _priceRange = const RangeValues(0, 1000000);
  String _selectedCondition = "All";
  
  // Available conditions
  final List<String> _conditions = ["All", "Like New", "Good", "Fair"];
  
  // Filtered listings that will be displayed
  late List<Map<String, dynamic>> _filteredListings;

  @override
  void initState() {
    super.initState();
    // Initialize filtered listings with all listings
    _filteredListings = List.from(widget.listings);
    
    // Auto slide every 1.2 seconds
    Future.delayed(const Duration(milliseconds: 100), () {
      _autoSlide();
    });
  }

  void _autoSlide() {
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        _currentPage = (_currentPage + 1) % _headerData.length;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        _autoSlide();
      }
    });
  }

  // Apply filters to listings
  void _applyFilters() {
    setState(() {
      _filteredListings = widget.listings.where((listing) {
        // Price filter
        double price = 0;
        if (listing['price'] != null) {
          // Extract numeric value from price string (removing "Rp " and any commas)
          String priceString = listing['price'].toString();
          priceString = priceString.replaceAll('Rp ', '').replaceAll(',', '');
          price = double.tryParse(priceString) ?? 0;
        }
        
        bool matchesPrice = price >= _priceRange.start && price <= _priceRange.end;
        
        // Condition filter
        bool matchesCondition = _selectedCondition == "All" || 
            (listing['condition'] != null && 
             listing['condition'].toString().contains(_selectedCondition));
        
        return matchesPrice && matchesCondition;
      }).toList();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F5), // Light cream background
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            _buildHeaderCarousel(),
            _buildPageIndicator(),
            const SizedBox(height: 16),
            _buildSearchBar(),
            const SizedBox(height: 16),
            Expanded(child: _buildProductGrid()),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              // Navigate to HomePage when back arrow is tapped
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
            child: Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Color(0xFFEAF3DC),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Color(0xFF4A6741),
              ),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              // Navigate to SavedProducts when heart icon is tapped
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SavedProductPage()),
              );
            },
            child: Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Color(0xFFEAF3DC),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border,
                color: Color(0xFF4A6741),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCarousel() {
    return SizedBox(
      height: 180,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemCount: _headerData.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _headerData[index]["title"],
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A6741),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _headerData[index]["subtitle"],
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF677361),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Image.asset(
                    _headerData[index]["image"],
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _headerData.length,
        (index) => Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index
                ? const Color(0xFF4A6741)
                : const Color(0xFFDDDDDD),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search it, Loop It",
                hintStyle: const TextStyle(color: Colors.black54),
                prefixIcon: const Icon(Icons.search, color: Colors.black54),
                filled: true,
                fillColor: const Color(0xFFEAF3DC),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Material(
            color: Colors.transparent,
            child: Ink(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: const Color(0xFFDDDDDD)),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(25),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (context) => buildFilterBottomSheet(),
                    isScrollControlled: true, // Allow the sheet to be larger than half the screen
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.85, // Set max height to avoid overflow
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: const [
                      Icon(Icons.filter_list, color: Colors.black54),
                      SizedBox(width: 4),
                      Text("Filter", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFilterBottomSheet() {
    return StatefulBuilder(
      builder: (context, setState) {
        // Get the bottom padding to account for safe area (notches, etc.)
        final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
        
        return SingleChildScrollView(
          // Make the content scrollable to prevent overflow
          child: Padding(
            // Add padding at the bottom to account for safe area
            padding: EdgeInsets.only(bottom: bottomPadding + 16),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Take minimum required vertical space
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Filter Products",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A6741),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Price Range Section
                  const Text(
                    "Price Range",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF4A6741),
                    ),
                  ),
                  const SizedBox(height: 10),
                  
                  // Price Range Slider
                  Column(
                    children: [
                      RangeSlider(
                        values: _priceRange,
                        min: 0,
                        max: 1000000,
                        divisions: 10,
                        activeColor: const Color(0xFF4A6741),
                        inactiveColor: const Color(0xFFEAF3DC),
                        labels: RangeLabels(
                          "Rp ${_priceRange.start.round()}",
                          "Rp ${_priceRange.end.round()}",
                        ),
                        onChanged: (RangeValues values) {
                          setState(() {
                            _priceRange = values;
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Rp ${_priceRange.start.round()}",
                              style: const TextStyle(
                                color: Color(0xFF4A6741),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "Rp ${_priceRange.end.round()}",
                              style: const TextStyle(
                                color: Color(0xFF4A6741),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Condition Section
                  const Text(
                    "Condition",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF4A6741),
                    ),
                  ),
                  const SizedBox(height: 10),
                  
                  // Condition Chips - Using Wrap for better layout
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _conditions.map((condition) {
                      bool isSelected = _selectedCondition == condition;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCondition = condition;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF4A6741)
                                : const Color(0xFFEAF3DC),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Text(
                            condition,
                            style: TextStyle(
                              color: isSelected ? Colors.white : const Color(0xFF4A6741),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _priceRange = const RangeValues(0, 1000000);
                              _selectedCondition = "All";
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF4A6741),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                              side: const BorderSide(color: Color(0xFF4A6741)),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text("Reset"),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Apply the filter
                            _applyFilters();
                            // Close the sheet
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4A6741),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text("Apply"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductGrid() {
    // Use the listings from the widget parameter if available
    // Otherwise, use sample data as fallback
    List<Map<String, dynamic>> displayListings = _filteredListings.isNotEmpty ? 
        _filteredListings : 
        [
          {
            "name": "Canon Kalkulator Scientific F-718SGA",
            "price": "Rp 100.000",
            "condition": "87% Good",
            "conditionColor": const Color(0xFFFFC107),
            "image": "assets/images/calculator.png",
          },
          {
            "name": "Tablet Xiaomi Pad 6",
            "price": "Rp 50.000",
            "condition": "99% Like New",
            "conditionColor": const Color(0xFF4CAF50),
            "image": "assets/images/tablet.png",
          },
          {
            "name": "Speaker Bluetooth Minis",
            "price": "Rp 90.000",
            "condition": "90% Like New",
            "conditionColor": const Color(0xFF4CAF50),
            "image": "assets/images/speaker.png",
          },
          {
            "name": "Speaker Bluetooth Minis",
            "price": "Rp 90.000",
            "condition": "90% Like New",
            "conditionColor": const Color(0xFF4CAF50),
            "image": "assets/images/speaker.png",
          },
        ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: displayListings.isEmpty 
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.search_off,
                    size: 64,
                    color: Color(0xFF4A6741),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "No products found",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF4A6741),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Try adjusting your filters",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemCount: displayListings.length,
              itemBuilder: (context, index) {
                final item = displayListings[index];
                return _buildProductItem(
                  context,
                  item["name"] ?? "Unknown Product",
                  item["price"] ?? "Price not available",
                  item["condition"] ?? "Condition not specified",
                  item["conditionColor"] ?? const Color(0xFF4CAF50),
                  item["image"] ?? "assets/images/placeholder.png",
                  index,
                );
              },
            ),
    );
  }

  Widget _buildProductItem(BuildContext context, String name, String price, String condition, Color conditionColor, String image, int index) {
    // Using GestureDetector instead of InkWell to remove hover effect
    return GestureDetector(
      onTap: () {
        // Navigate to the ItemsDetails when item is tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => detail.ItemsDetails(
              name: name,
              price: price,
              condition: condition,
              image: image,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Image.asset(
                image,
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            
            // Product details
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF4A6741),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A6741),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: condition.contains("Like New") 
                              ? const Color(0xFFE7F5D9) 
                              : const Color(0xFFFFF8E0),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          condition,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: conditionColor,
                          ),
                        ),
                      ),
                      const Icon(Icons.more_horiz, color: Colors.black54),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}