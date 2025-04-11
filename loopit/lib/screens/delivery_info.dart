import 'package:flutter/material.dart';

void main() {
  runApp(const DeliveryInfo());
}

class DeliveryInfo extends StatelessWidget {
  const DeliveryInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const DeliveryInfoPage(),
    );
  }
}

class DeliveryInfoPage extends StatelessWidget {
  const DeliveryInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with back button and title - white background like in image
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              color: Colors.white, // White background as requested
              width: double.infinity,
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFECF3E6), // Light green circle background
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          color: Color(0xFF4C6E4C), // Darker green from image
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Delivery Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF4C6E4C), // Darker green from image
                    ),
                  ),
                ],
              ),
            ),
            
            // Add divider after header
            Container(
              color: const Color(0xFFECF3E6), // Very light green color for divider
              height: 1,
              width: double.infinity,
            ),
            
            // Delivery steps list - styled to match the image
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, 
                children: [
                  _buildDeliveryStep(
                    number: 1, 
                    text: 'Send the package to the ABC delivery service.',
                    isCompleted: true,
                    isBold: true,
                  ),
                  _buildDeliveryStep(
                    number: 2, 
                    text: 'The package is being processed by the ABC delivery service.',
                    isCompleted: true,
                  ),
                  _buildDeliveryStep(
                    number: 3, 
                    text: 'The package is being sent by the ABC delivery service.',
                    isCompleted: true,
                  ),
                  _buildDeliveryStep(
                    number: 4, 
                    text: 'The package has been sent by the ABC delivery service.',
                    isCompleted: true,
                  ),
                  _buildDeliveryStep(
                    number: 5, 
                    text: 'Buyer has confirmed the arrival of package.',
                    isCompleted: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryStep({
    required int number,
    required String text,
    required bool isCompleted,
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$number.',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black.withOpacity(0.75),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.black.withOpacity(0.75),
              ),
            ),
          ),
        ],
      ),
    );
  }
}