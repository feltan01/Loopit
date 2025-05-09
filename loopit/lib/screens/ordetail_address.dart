import 'package:flutter/material.dart';
import 'report.dart'; // Import the report screen
import 'cod.dart';


void main() {
  runApp(const OrderdetailsAddress());
}

class OrderdetailsAddress extends StatelessWidget {
  const OrderdetailsAddress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const OrderDetailsPageAddress(),
    );
  }
}

class OrderDetailsPageAddress extends StatelessWidget {
  const OrderDetailsPageAddress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Back button and title bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF1EA),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: Color(0xFF4A6741)),
                      onPressed: () {
                        // Handle back navigation
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Order details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A6741),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),

            // Order content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product info
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'assets/shoes.jpg', // Replace with your actual image
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey[300],
                                  child: const Center(
                                    child: Icon(Icons.image_not_supported),
                                  ),
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
                                const Text(
                                  'Invoice number: INV-20240223-8745',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Sepatu Staccato Original',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF4A6741),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Rp 550.000',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Divider(
                        height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
                    const SizedBox(height: 16),

                    // Order info section
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Order info',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A6741),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Payment method
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          const SizedBox(
                              width: 120, child: Text('Payment method')),
                          const Expanded(child: Text('Cash on delivery')),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Order number
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          const SizedBox(
                              width: 120, child: Text('Order number')),
                          const Expanded(child: Text('00000001')),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Meeting point - UPDATED with Fresh Market Emerald Bintaro address
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                width: 120,
                                child: Text('Decided meeting point'),
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEEF1EA),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.location_on,
                                            color: Color(0xFF4A6741),
                                            size: 16,
                                          ),
                                          const SizedBox(width: 4),
                                          const Expanded(
                                            child: Text(
                                              'Fresh Market Emerald Bintaro',
                                              style: TextStyle(
                                                color: Color(0xFF4A6741),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        'Pintu Selatan Blok PE / KA-01, RW.1, Parigi, Pondok Aren, South Tangerang City, Banten 15227',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF4A6741),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 120.0, top: 4),
                            child: const Text(
                              '*once set, the buyer would be informed and '
                              'meeting point cannot be changed, please '
                              'contact the buyer for further decision '
                              'making.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Divider(
                        height: 32, thickness: 1, color: Color(0xFFEEEEEE)),
                    const SizedBox(height: 8),

                    // Total section
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A6741),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Items total
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Items total'),
                          const Text('Rp 550.000'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Service fee
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Service fee'),
                          const Text('Rp 2.000'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                    const Divider(
                        height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
                    const SizedBox(height: 16),

                    // Final total
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const Text('Rp 552.000',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Report section - UPDATED with navigation
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          const Icon(Icons.warning_amber_rounded,
                              color: Colors.amber),
                          const SizedBox(width: 8),
                          const Text('Products/Transaction trouble?'),
                          TextButton(
                            onPressed: () {
                              // Navigate to the ReportProblemScreen when pressed
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ReportProblemScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Report',
                              style: TextStyle(
                                color: Color(0xFF4A6741),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Confirm button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CashOnDeliveryPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEEF1EA),
                    foregroundColor: const Color(0xFF4A6741),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Confirm',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
