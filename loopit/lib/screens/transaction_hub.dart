import 'package:flutter/material.dart';
import 'package:loopit/screens/home_page.dart';
import 'transbuyer.dart';
import 'home_page.dart';

void main() {
  runApp(const TransactionHub());
}

class TransactionHub extends StatelessWidget {
  const TransactionHub({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const TransactionHubPage(),
    );
  }
}

class TransactionHubPage extends StatefulWidget {
  const TransactionHubPage({Key? key}) : super(key: key);

  @override
  State<TransactionHubPage> createState() => _TransactionHubPageState();
}

class _TransactionHubPageState extends State<TransactionHubPage> {
  bool isBuyerSelected = false;

  @override
  Widget build(BuildContext context) {
    // Colors from the screenshot
    const Color darkGreen = Color(0xFF556B2F);
    const Color lightGreen = Color(0xFFEEF5E9);
    const Color urgentRed = Color(0xFFC07A77);
    const Color tabTextColor = Color(0xFF54624F);
    const Color borderColor = Color(0xFFE0E0E0);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar with back button and title
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: borderColor,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: darkGreen),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const HomePage(), // Redirect to chat_buyer.dart
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Transaction Hub',
                    style: TextStyle(
                      color: darkGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),

            // Divider
            const Divider(height: 1, color: borderColor),

            // Buyer/Seller Tabs
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const TransactionHubBuyer(), // Redirect to chat_buyer.dart
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            "Buyer",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: tabTextColor,
                            ),
                          ),
                        ),
                        Container(
                          height: 2,
                          color:
                              isBuyerSelected ? darkGreen : Colors.transparent,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  width: 1,
                  color: borderColor,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const TransactionHubBuyer(), // Redirect to chat_buyer.dart
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            "Seller",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: tabTextColor,
                            ),
                          ),
                        ),
                        Container(
                          height: 2,
                          color:
                              !isBuyerSelected ? darkGreen : Colors.transparent,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Divider
            const Divider(height: 1, color: borderColor),

            // Transaction List
            Expanded(
              child: Container(
                color: Colors.white,
                child: ListView(
                  padding: const EdgeInsets.all(12),
                  children: [
                    TransactionCard(
                      urgentColor: urgentRed,
                      iconData: Icons.person_outline,
                      iconData2: Icons.inventory_2_outlined,
                    ),
                    const SizedBox(height: 12),
                    TransactionCard(
                      urgentColor: urgentRed,
                      iconData: Icons.local_shipping_outlined,
                      iconData2: null,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionCard extends StatelessWidget {
  final Color urgentColor;
  final IconData iconData;
  final IconData? iconData2;

  const TransactionCard({
    Key? key,
    required this.urgentColor,
    required this.iconData,
    this.iconData2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEEF5E9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // URGENT label with icon
            Row(
              children: [
                Icon(
                  Icons.watch_later_outlined,
                  color: urgentColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  "URGENT",
                  style: TextStyle(
                    color: urgentColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Product details
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    'https://i.ibb.co/k0mKWJZ/shoes.jpg',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 100,
                        height: 100,
                        color: Colors.grey[300],
                        child: const Icon(Icons.broken_image),
                      );
                    },
                  ),
                ),

                const SizedBox(width: 12),

                // Product info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "INV-20240223-8745",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Sepatu Staccato Original",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color(0xFF556B2F),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Rp 550.000",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF556B2F),
                        ),
                      ),
                    ],
                  ),
                ),

                // Status icons
                Row(
                  children: [
                    Icon(
                      iconData,
                      color: const Color(0xFF556B2F),
                      size: 24,
                    ),
                    if (iconData2 != null)
                      Icon(
                        iconData2,
                        color: const Color(0xFF556B2F),
                        size: 24,
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
