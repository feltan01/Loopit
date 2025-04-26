import 'package:flutter/material.dart';
import 'package:loopit/screens/api_service.dart';
import 'package:loopit/screens/home_page.dart'; // for Home navigation
import 'package:loopit/screens/items_detail.dart'; // Import ItemsDetails

class FashionPage extends StatefulWidget {
  final List<Map<String, dynamic>> listings; // ✅ Accept listings

  const FashionPage({super.key, required this.listings}); // ✅ Constructor

  @override
  State<FashionPage> createState() => _FashionPageState();
}

class _FashionPageState extends State<FashionPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<Map<String, dynamic>> fashionListings = []; // Dynamic data

  final List<Map<String, dynamic>> _headerData = [
    {
      "title": "Fashion",
      "subtitle": "Styles that speak, fashion that lasts.",
      "image": "assets/images/fs1.png"
    },
    {
      "title": "Refined Style",
      "subtitle": "Elevate your wardrobe with new fashion finds.",
      "image": "assets/images/fs2.png"
    },
    {
      "title": "Wardrobe Goals",
      "subtitle": "Trendy, Versatile, and made for you.",
      "image": "assets/images/fs3.png"
    },
  ];

  @override
  void initState() {
    super.initState();
    _fetchFashionListings();
    Future.delayed(const Duration(milliseconds: 100), () {
      _autoSlide();
    });
  }

  Future<void> _fetchFashionListings() async {
    final allListings = await ApiService.getAllListings();
    setState(() {
      fashionListings = allListings
          .where((listing) => listing['category'].toLowerCase() == 'fashion')
          .cast<Map<String, dynamic>>()
          .toList();
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

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F5),
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
            onTap: () => Navigator.pop(context),
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
          Container(
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: const Color(0xFFDDDDDD)),
            ),
            child: Row(
              children: const [
                Icon(Icons.filter_list, color: Colors.black54),
                SizedBox(width: 4),
                Text("Filter",
                    style: TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: fashionListings.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemCount: fashionListings.length,
              itemBuilder: (context, index) {
                final item = fashionListings[index];
                final imageUrl = item["images"].isNotEmpty
                    ? item["images"][0]["image"]
                    : "assets/images/fallback.png";
                
                // Determine the condition color
                Color conditionColor;
                if (item["condition"] == "NEW" || item["condition"].toString().contains("New")) {
                  conditionColor = const Color(0xFF4CAF50);
                } else if (item["condition"].toString().contains("Good")) {
                  conditionColor = const Color(0xFFFFC107);
                } else {
                  conditionColor = const Color(0xFFFF9800);
                }

                return _buildProductItem(
                  context,
                  item["title"] ?? "No Title",
                  "Rp ${item["price"] ?? "0"}",
                  item["condition"] ?? "Unknown",
                  conditionColor, 
                  imageUrl,
                  productId: item["id"]?.toString(),
                  description: item["description"] ?? ""
                );
              },
            ),
    );
  }

  Widget _buildProductItem(
    BuildContext context,
    String name,
    String price,
    String condition,
    Color conditionColor,
    String imageUrl, {
    String? productId,
    String? description
  }) {
    return GestureDetector(
      onTap: () {
        // Navigate to ItemsDetails page when product is tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ItemsDetails(
              name: name,
              price: price,
              condition: condition,
              image: imageUrl,
              productId: productId,
              description: description ?? "",
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
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: imageUrl.startsWith("http")
                  ? Image.network(
                      imageUrl,
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          "assets/images/fallback.png",
                          height: 140,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : Image.asset(
                      imageUrl,
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
            ),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: condition.contains("Like New") || condition == "NEW"
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