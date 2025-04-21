import 'package:flutter/material.dart';
import 'package:loopit/screens/cod.dart';

void main() {
  runApp(const Deliveryproof());
}

class Deliveryproof extends StatelessWidget {
  const Deliveryproof({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProofOfDeliveryPage(),
    );
  }
}

class ProofOfDeliveryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header with back button and title
          Container(
            padding:
                const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 16),
            child: Row(
              children: [
                // Back button in light green circle with navigation
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CashOnDeliveryPage()),
                    );
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDF7ED),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF4A6741),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Title
                const Text(
                  'Proof of delivery',
                  style: TextStyle(
                    color: Color(0xFF4A6741),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Image with black borders
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height - 100,
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.black, width: 2),
                bottom: BorderSide(color: Colors.black, width: 2),
              ),
            ),
            child: FittedBox(
              fit: BoxFit.contain,
              child: Image.asset(
                'assets/images/cod.jpg',
                errorBuilder: (context, error, stackTrace) {
                  // Fallback content if image fails to load
                  return Container(
                    width: 300,
                    height: 400,
                    color: Colors.grey[300],
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.image_not_supported,
                              size: 50, color: Colors.grey),
                          SizedBox(height: 8),
                          Text("Delivery confirmation photo"),
                        ],
                      ),
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
}
