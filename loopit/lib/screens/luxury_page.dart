import 'package:flutter/material.dart';

class LuxuryPage extends StatefulWidget {
  const LuxuryPage({super.key});

  @override
  State<LuxuryPage> createState() => _LuxuryPageState();
}

class _LuxuryPageState extends State<LuxuryPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<Map<String, dynamic>> _headerData = [
    {
      "title": "Luxury Items",
      "subtitle": "Where exclusivity meets excellence.",
      "image": "assets/images/lux1.png"
    },
    {
      "title": "Timeless Luxe",
      "subtitle": "Iconic pierces that never go out of style.",
      "image": "assets/images/lux2.png"
    },
    {
      "title": "Elevated Elegance",
      "subtitle": "High-end accessories luxury fashion, and rare.",
      "image": "assets/images/lux3.png"
    },
  ];

  @override
  void initState() {
    super.initState();
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
                Text("Filter", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid() {
    List<Map<String, dynamic>> products = [
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
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return _buildProductItem(
            products[index]["name"],
            products[index]["price"],
            products[index]["condition"],
            products[index]["conditionColor"],
            products[index]["image"],
          );
        },
      ),
    );
  }

  Widget _buildProductItem(String name, String price, String condition, Color conditionColor, String image) {
    return Container(
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
    );
  }
}