import 'package:flutter/material.dart';
import 'order_complete_buy.dart';

void main() {
  runApp(const Orders());
}

class Orders extends StatelessWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Order Detail',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4D6A56),
          primary: const Color(0xFF4D6A56),
        ),
        useMaterial3: true,
      ),
      home: const OrderDetailScreen(),
    );
  }
}

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({Key? key}) : super(key: key);

void _showConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(
                      Icons.close,
                      color: Color(0xFF4D6A56),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Finish this order?',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4D6A56),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF4D6A56),
                    height: 1.5,
                  ),
                  children: [
                    TextSpan(
                      text: 'By clicking confirm, this order is complete and you ',
                    ),
                    TextSpan(
                      text: 'cannot make a complain anymore',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // First bullet point
              const Text(
                'Make sure you receive your item as your order',
                style: TextStyle(
                  fontSize: 16, 
                  color: Color(0xFF4D6A56),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              // Second bullet point
              const Text(
                'Always double check your item sent / receive',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF4D6A56),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              // Third bullet point
              const Text(
                'Check the proof of shipping/transaction before you proceed',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF4D6A56),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>  MyApp(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE9F1E7),
                      foregroundColor: const Color(0xFF4D6A56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Confirm',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

  Widget _buildBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '•',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF4D6A56),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF4D6A56),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: const Color(0xFFE9F1E7),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF4D6A56)),
              onPressed: () {},
            ),
          ),
        ),
        title: const Text(
          'Order Detail',
          style: TextStyle(
            color: Color(0xFF4D6A56),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Delivery information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4D6A56),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Standard shipping: 1Z3X8Y9A0456781234',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF4D6A56),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFE9F1E7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.local_shipping_outlined,
                      color: Color(0xFF4D6A56),
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Your order has arrived at the transit location in Kab. Tangerang, Pagedangan, Pagedangan Hub.',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF4D6A56),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Delivery Address',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4D6A56),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Color(0xFF4D6A56),
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Home sweet home',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4D6A56),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Padding(
                padding: EdgeInsets.only(left: 30.0),
                child: Text(
                  'Edu Town Kavling Edu I No. 1, Jalan BSD Raya Utama, BSD City, Serpong, Tangerang Selatan, Banten 15345, Indonesia',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF4D6A56),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Item Detail',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4D6A56),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    'Invoice number: ',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF4D6A56),
                    ),
                  ),
                  Text(
                    'INV-20240223-8745',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF4D6A56),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Product details section matching Image 1
              Container(
                margin: const EdgeInsets.only(top: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE9F1E7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.shopping_bag_outlined,
                        color: Color(0xFF4D6A56),
                        size: 40,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Jacket Cream color Brand ABC',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF4D6A56),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Rp 140.000',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF4D6A56),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.grey,
                                child: Icon(Icons.person, color: Colors.white, size: 20),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'User 1',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF4D6A56),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      for (int i = 0; i < 4; i++)
                                        const Icon(
                                          Icons.star,
                                          color: Color(0xFF4D6A56),
                                          size: 16,
                                        ),
                                      const Icon(
                                        Icons.star_border,
                                        color: Color(0xFF4D6A56),
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE9F1E7),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(
                                  Icons.chat_bubble_outline,
                                  color: Color(0xFF4D6A56),
                                  size: 20,
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
              const SizedBox(height: 20),
              const Text(
                'Payment Method',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4D6A56),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'BCA',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'BCA Virtual Account',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF4D6A56),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Order Total',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4D6A56),
                ),
              ),
              const SizedBox(height: 10),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Items Total',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF4D6A56),
                    ),
                  ),
                  Text(
                    'Rp 140.000',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF4D6A56),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Shipping Cost',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF4D6A56),
                    ),
                  ),
                  Text(
                    'Rp 45.000',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF4D6A56),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Service Fee',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF4D6A56),
                    ),
                  ),
                  Text(
                    'Rp 2.000',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF4D6A56),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(color: Color(0xFFE9F1E7), thickness: 1),
              const SizedBox(height: 10),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Cost',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF4D6A56),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Rp 187.000',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF4D6A56),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE9F1E7),
                        foregroundColor: const Color(0xFF4D6A56),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'File a Report',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _showConfirmationDialog(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4D6A56),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Package Received',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}