import 'package:flutter/material.dart';
import 'transaction_hub.dart';
import 'report.dart'; 
import 'delinfo_confirmed.dart'; 

void main() {
  runApp(const DeliveryDetailConfirmed());
}

class DeliveryDetailConfirmed extends StatelessWidget {
  const DeliveryDetailConfirmed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const DeliveryDetailPage(),
    );
  }
}

class DeliveryDetailPage extends StatelessWidget {
  const DeliveryDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            ListView(
              children: [
                _buildHeader(context), 
                const Divider(height: 1, color: Colors.grey),
                _buildDeliveryInformation(context), // Pass context to access Navigator
                const Divider(height: 1, color: Colors.grey),
                _buildOrderStatus(),
                const Divider(height: 1, color: Colors.grey),
                _buildItemDetail(),
                const Divider(height: 1, color: Colors.grey),
                _buildOrderTotal(),
                const Divider(height: 1, color: Colors.grey),
                _buildReportSection(context),
                // Add extra padding at the bottom to accommodate the finish button
                const SizedBox(height: 100),
              ],
            ),
            // Finish button positioned at the bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildFinishButton(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFEAF2E3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF4D6A46)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TransactionHub(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Delivery Detail',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4D6A46),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryInformation(BuildContext context) { // Add context parameter
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Delivery information',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4D6A46),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Standard shipping: IZ3X8Y9A0456781234',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector( // Wrap container with GestureDetector
            onTap: () {
              // Navigate to DeliveryInfoPage when tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DeliveryInfoConfirmed(),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF2E3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: const [
                  Icon(Icons.local_shipping_outlined, color: Color(0xFF4D6A46)),
                  SizedBox(width: 12),
                  Text(
                    'Buyer has confirmed the arrival of package',
                    style: TextStyle(
                      color: Color(0xFF4D6A46),
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderStatus() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: const [
          Text(
            'Order Status:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4D6A46),
            ),
          ),
          SizedBox(width: 12),
          Text(
            'Complete',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF5CAF5C), // Changed to green for Complete
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemDetail() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Item Detail',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4D6A46),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Invoice number: INV-20240223-8745',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  'https://via.placeholder.com/110',
                  height: 110,
                  width: 110,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Jacket Cream color Brand ABC',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Rp 140.000',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4D6A46),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage('https://via.placeholder.com/40'),
                          radius: 14,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'User 1',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: const [
                            Icon(Icons.star, color: Color(0xFFEBCB53), size: 18),
                            Icon(Icons.star, color: Color(0xFFEBCB53), size: 18),
                            Icon(Icons.star, color: Color(0xFFEBCB53), size: 18),
                            Icon(Icons.star, color: Color(0xFFEBCB53), size: 18),
                            Icon(Icons.star_border, color: Color(0xFFEBCB53), size: 18),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderTotal() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Total',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4D6A46),
            ),
          ),
          const SizedBox(height: 12),
          _buildPriceRow('Items Total', 'Rp 550.000'),
          const SizedBox(height: 8),
          _buildPriceRow('Shipping Cost', 'Rp 45.000'),
          const SizedBox(height: 8),
          _buildPriceRow('Service Fee', 'Rp 2.000'),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Colors.grey),
          const SizedBox(height: 16),
          _buildPriceRow('Total Cost', 'Rp 597.000', isTotal: true),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String price, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: Colors.black87,
          ),
        ),
        Text(
          price,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? const Color(0xFF4D6A46) : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildReportSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.grey),
          const SizedBox(width: 8),
          const Text(
            'Products/Transaction trouble?',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ReportProblemScreen(),
                ),
              );
            },
            child: const Text(
              'Report',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4D6A46),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // New method to build the Finish button
  Widget _buildFinishButton(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          // Add your finish action here
          Navigator.pop(context); // Example: go back to previous screen
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFEAF2E3),
          foregroundColor: const Color(0xFF4D6A46),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Finish',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}