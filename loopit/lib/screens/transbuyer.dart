import 'package:flutter/material.dart';
import 'package:loopit/screens/home_page.dart';
import 'transaction_hub.dart';
import 'home_page.dart';

void main() {
  runApp(const TransactionHubBuyer());
}

class TransactionHubBuyer extends StatelessWidget {
  const TransactionHubBuyer({Key? key}) : super(key: key);

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
  bool isBuyerSelected = true;

  @override
  Widget build(BuildContext context) {
    // Colors
    const Color darkGreen = Color(0xFF556B2F);
    const Color lightGreen = Color(0xFFA4BE7B);
    const Color backgroundColor = Color(0xFFF9F9F9);
    const Color borderColor = Color(0xFFE0E0E0);
    const Color dealDoneColor = Color(0xFFA4BE7B);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar with back button and title
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              color: Colors.white,
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F6EA),
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
            Container(
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isBuyerSelected = true;
                        });
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
                                color: darkGreen,
                              ),
                            ),
                          ),
                          Container(
                            height: 2,
                            color: isBuyerSelected
                                ? darkGreen
                                : Colors.transparent,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 52,
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
                                const TransactionHub(), // Redirect to chat_buyer.dart
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
                                color: darkGreen,
                              ),
                            ),
                          ),
                          Container(
                            height: 2,
                            color: !isBuyerSelected
                                ? darkGreen
                                : Colors.transparent,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Divider
            const Divider(height: 1, color: borderColor),

            // Transaction List
            Expanded(
              child: Container(
                color: backgroundColor,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Jacket Transaction Card
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor, width: 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Jacket image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                width: 100,
                                height: 100,
                                color: const Color(0xFFF9F6F2),
                                child: Image.network(
                                  'https://i.imgur.com/JmS28g8.png', // Cream colored jacket image
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 100,
                                      height: 100,
                                      color: const Color(0xFFF9F6F2),
                                      child: const Icon(Icons.image,
                                          color: Colors.grey),
                                    );
                                  },
                                ),
                              ),
                            ),

                            const SizedBox(width: 16),

                            // Product info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Jacket Cream color",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      color: darkGreen,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    "Brand ABC",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                      color: darkGreen,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      const Text(
                                        "Rp 140.000",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: darkGreen,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Container(
                                        width: 5,
                                        height: 5,
                                        decoration: const BoxDecoration(
                                          color: Colors.grey,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      const Text(
                                        "Deal Done",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: dealDoneColor,
                                        ),
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
