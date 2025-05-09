import 'package:flutter/material.dart';
import 'package:loopit/services/api_services.dart';
import 'fashion_page.dart';
import 'electronics_page.dart';
import 'skincare_page.dart';
import 'books_page.dart';
import 'luxury_page.dart';
import 'toys_page.dart';
import 'others_page.dart';
import 'highest_quality.dart';
import 'profile.dart';
import 'saldo.dart';
import 'seller_verification.dart';
import 'messages.dart';
import 'transaction_hub.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> allListings = [];

  @override
  void initState() {
    super.initState();
    print('🔄 initState: Calling fetchListings');
    fetchListings();
  }

  Future<void> fetchListings() async {
    print('🔄 initState: Calling fetchListings');
    try {
      final listings = await ApiServices.getAllListings();
      print('Fetched Listings: $listings'); // Should not be null

      setState(() {
        allListings = listings ?? []; // Avoid null
      });
    } catch (e) {
      print('Error fetching listings: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 245, 245, 245),
        elevation: 0,
        title: Row(
          children: [
            Image.asset("assets/images/logo.png", width: 90),
            const Spacer(),
            IconButton(
  icon: const Icon(Icons.email_outlined, color: Colors.black),
  onPressed: () async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );
      
      // Get current user info from API
      final currentUser = await ApiServices.getUserInfo();
      
      // Close loading dialog
      if (context.mounted) Navigator.pop(context);
      
      // Navigate to MessagesPage with real or default user
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MessagesPage(currentUser: currentUser),
          ),
        );
      }
    } catch (e) {
      // Close loading dialog if there's an error
      if (context.mounted) Navigator.pop(context);
      
      // Show error message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load user data: $e')),
        );
      }
    }
  },
),

            IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TransactionHub()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.favorite_border, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              _buildSearchBar(),
              const SizedBox(height: 16),
              _buildCashflowSection(context),
              const SizedBox(height: 16),
              _buildQualityBadge(context),
              const SizedBox(height: 16),
              const Text(
                "Categories",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A6741),
                ),
              ),
              const SizedBox(height: 10),
              _buildCategorySection(context),
              const SizedBox(height: 24),
              const Text(
                "Recommendation",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A6741),
                ),
              ),
              const SizedBox(height: 10),
              _buildRecommendationSection(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search it, Loop It",
        hintStyle: const TextStyle(color: Colors.black54),
        prefixIcon: const Icon(Icons.search, color: Colors.black54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: const Color(0xFFEAF3DC),
      ),
    );
  }

  Widget _buildCashflowSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF3DC),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          // Balance section - clickable to navigate to SaldoPage
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SaldoPage()),
              );
            },
            child: Row(
              children: const [
                Icon(Icons.account_balance_wallet_outlined,
                    color: Color(0xFF4A6741)),
                SizedBox(width: 8),
                Text(
                  "Rp 0",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A6741),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          // History section - clickable to navigate to HistoryPage (not yet created)
          GestureDetector(
            onTap: () {
              // This would navigate to HistoryPage once it's created
              // For now, show a message that the page is not yet available
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("History page is not yet available"),
                  duration: Duration(seconds: 2),
                ),
              );

              // Uncomment this code once you create HistoryPage:
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const HistoryPage()),
              // );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: const [
                  Icon(Icons.history, size: 16, color: Colors.black54),
                  SizedBox(width: 6),
                  Text("No recent cashflow",
                      style: TextStyle(color: Colors.black54)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQualityBadge(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HighestQualityPage()),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF4A6741)),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.diamond_outlined, color: Color(0xFF4A6741)),
            SizedBox(width: 8),
            Text(
              "Highest Quality",
              style: TextStyle(
                color: Color(0xFF4A6741),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context) {
    List<Map<String, dynamic>> categories = [
    {
      "title": "Fashion",
      "image": "assets/images/fashion.png",
      "onTap": () {
        final filteredListings = allListings
            .where((l) => l['category'] != null &&
                l['category'].toString().toLowerCase().contains('fashion'))
            .toList();

        print('Filtered Fashion Listings: $filteredListings'); // Debug

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FashionPage(listings: filteredListings),
          ),
        );
      },
    },
    {
        "title": "Electronics",
        "image": "assets/images/electronics.png",
        "onTap": () {
          final filteredListings = allListings
              .where((l) =>
                  l['category'] != null &&
                  l['category']
                      .toString()
                      .toLowerCase()
                      .contains('electronics'))
              .toList();

          print('Filtered Electronics Listings: $filteredListings');

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ElectronicsPage(listings: filteredListings),
            ),
          );
        },
      },
      {
        "title": "Skincare & Perfumes",
        "image": "assets/images/skincare.png",
        "onTap": () {
          final filteredListings = allListings
              .where((l) =>
                  l['category'] != null &&
                  l['category']
                      .toString()
                      .toLowerCase()
                      .contains('skincare & perfumes'))
              .toList();

          print('Filtered Skincare Listings: $filteredListings');

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SkincarePage(listings: filteredListings),
            ),
          );
        },
      },
      {
        "title": "Books & Magazine",
        "image": "assets/images/books.png",
        "onTap": () {
          final filteredListings = allListings
              .where((l) =>
                  l['category'] != null &&
                  l['category']
                      .toString()
                      .toLowerCase()
                      .contains('books & magazines'))
              .toList();

          print('Filtered Books Listings: $filteredListings');

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BooksPage(listings: filteredListings),
            ),
          );
        },
      },
      {
        "title": "Luxury Items",
        "image": "assets/images/luxury.png",
        "onTap": () {
          final filteredListings = allListings
              .where((l) =>
                  l['category'] != null &&
                  l['category'].toString().toLowerCase().contains('luxury'))
              .toList();

          print('Filtered Luxury Listings: $filteredListings');

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LuxuryPage(listings: filteredListings),
            ),
          );
        },
      },
      {
        "title": "Toys",
        "image": "assets/images/toys.png",
        "onTap": () {
          final filteredListings = allListings
              .where((l) =>
                  l['category'] != null &&
                  l['category'].toString().toLowerCase().contains('toys'))
              .toList();

          print('Filtered Toys Listings: $filteredListings');

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ToysPage(listings: filteredListings),
            ),
          );
        },
      },
      {
        "title": "Others",
        "image": "assets/images/others.png",
        "onTap": () {
          final filteredListings = allListings
              .where((l) =>
                  l['category'] != null &&
                  l['category'].toString().toLowerCase().contains('others'))
              .toList();

          print('Filtered Others Listings: $filteredListings');

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OthersPage(listings: filteredListings),
            ),
          );
        },
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return GestureDetector(
          onTap: category["onTap"],
          child: _buildCategoryItem(category["title"], category["image"]),
        );
      },
    );
  }

  Widget _buildCategoryItem(String title, String imagePath) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: const Color(0xFFFFF5EC),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Image.asset(imagePath, width: 80),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF4A6741),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildRecommendationSection() {
    List<Map<String, dynamic>> recommendations = [
      {
        "title": "Gitar Elektrik Parker Hornet Pm10",
        "price": "Rp 2.882.000",
        "image": "assets/images/mock_guitar.png",
        "condition": "95% Like New"
      },
      {
        "title": "Panci Panda",
        "price": "Rp 140.000",
        "image": "assets/images/mock_panci.png",
        "condition": "87% Good"
      },
      {
        "title": "Harry Potter and The Prisoner of Azkaban",
        "price": "",
        "image": "assets/images/mock_buku.png",
        "condition": ""
      },
      {
        "title": "Speaker Bluetooth Minis",
        "price": "",
        "image": "assets/images/mock_speaker.png",
        "condition": ""
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: recommendations.length,
      itemBuilder: (context, index) {
        return _buildRecommendationItem(
          recommendations[index]["title"],
          recommendations[index]["price"],
          recommendations[index]["image"],
          recommendations[index]["condition"],
        );
      },
    );
  }

  Widget _buildRecommendationItem(
      String title, String price, String imagePath, String condition) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
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
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            child: Image.asset(
              imagePath,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (price.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A6741),
                    ),
                  ),
                ],
                if (condition.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: condition.contains("Like New")
                              ? const Color(0xFFE7F5D9)
                              : const Color(0xFFFFF8E0),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          condition,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: condition.contains("Like New")
                                ? const Color(0xFF4CAF50)
                                : const Color(0xFFFFC107),
                          ),
                        ),
                      ),
                      const Icon(Icons.more_horiz, color: Colors.black45),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFFFFF5EE),
      selectedItemColor: const Color(0xFF4A6741),
      unselectedItemColor: Colors.grey,
      currentIndex: 0, // Pastikan index sesuai dengan halaman yang aktif
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        if (index == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else if (index == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const SellerVerificationPage()),
          );
        } else if (index == 2) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ProfilePage()),
          );
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(
              Icons.add_circle_outline), // Navigasi ke SellerVerificationPage
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: '',
        ),
      ],
    );
  }
}
