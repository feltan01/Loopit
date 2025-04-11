import 'package:flutter/material.dart';
import 'address_selection_screen.dart';
import 'payment_method_screen.dart';
import 'payment_confirmation_screen.dart';
import 'chat_buyer.dart';

void main() {
  runApp(const Checkout());
}

class Checkout extends StatelessWidget {
  const Checkout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Roboto',
      ),
      home: const CheckoutPage(),
    );
  }
}

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool _bcaSelected = true;
  bool _bniSelected = false;
  bool _goPaySelected = false;
  bool _codSelected = false;
  
  // Variables for payment method
  String _selectedPaymentId = 'bca';
  String _selectedPaymentName = 'BCA Virtual Account';
  
  // Variables for shipping method
  String _shippingMethod = 'Standard';
  String _shippingCost = 'Rp 45.000';
  String _estimatedDelivery = '5 - 7 Days';
  
  // Variable for notes
  String _notes = '';
  
  // Navigate to payment method screen
  void _navigateToPaymentMethod() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentMethodScreen(
          initialPaymentType: _selectedPaymentId,
          onPaymentSelected: (paymentId, paymentName) {
            setState(() {
              _selectedPaymentId = paymentId;
              _selectedPaymentName = paymentName;
              
              // Update switches based on selected payment
              _bcaSelected = paymentId == 'bca';
              _bniSelected = paymentId == 'bni';
              _goPaySelected = paymentId == 'gopay';
              _codSelected = paymentId == 'cod';
            });
          },
        ),
      ),
    );
  }

  // Show shipping method selection dialog
  void _showShippingMethodDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        const Icon(Icons.close, color: Colors.grey),
                        const SizedBox(width: 80),
                        const Text(
                          'Shipping Method',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF4A6741),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(thickness: 1, height: 30),
                  
                  // Standard shipping option
                  _buildShippingOption(
                    title: 'Standard (Rp 45.000)',
                    subtitle: 'Estimated Arrival 5-7 Days',
                    isSelected: _shippingMethod == 'Standard',
                    onTap: () {
                      _updateShippingMethod('Standard', 'Rp 45.000', '5 - 7 Days');
                      Navigator.pop(context);
                    },
                  ),
                  
                  // Cargo shipping option
                  _buildShippingOption(
                    title: 'Cargo (Rp 20.000)',
                    subtitle: 'Estimated Arrival 7-14 Days',
                    isSelected: _shippingMethod == 'Cargo',
                    onTap: () {
                      _updateShippingMethod('Cargo', 'Rp 20.000', '7 - 14 Days');
                      Navigator.pop(context);
                    },
                  ),
                  
                  // Same day shipping option
                  _buildShippingOption(
                    title: 'Same day 8 hours (Rp 85.000)',
                    subtitle: 'Estimated Arrival 8-20 Hours',
                    isSelected: _shippingMethod == 'Same day',
                    onTap: () {
                      _updateShippingMethod('Same day', 'Rp 85.000', '8 - 20 Hours');
                      Navigator.pop(context);
                    },
                  ),
                  
                  // Instant shipping option
                  _buildShippingOption(
                    title: 'Instant (Rp 130.000)',
                    subtitle: 'Estimated Arrival 3-4 Hours',
                    isSelected: _shippingMethod == 'Instant',
                    onTap: () {
                      _updateShippingMethod('Instant', 'Rp 130.000', '3 - 4 Hours');
                      Navigator.pop(context);
                    },
                  ),
                  
                  // Regular shipping option
                  _buildShippingOption(
                    title: 'Regular (Rp 57.000)',
                    subtitle: 'Estimated Arrival 2-4 Days',
                    isSelected: _shippingMethod == 'Regular',
                    onTap: () {
                      _updateShippingMethod('Regular', 'Rp 57.000', '2 - 4 Days');
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
  
  // Helper method to build shipping option rows
  Widget _buildShippingOption({
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check, color: Color(0xFF4A6741)),
          ],
        ),
      ),
    );
  }
  
  // Update shipping method
  void _updateShippingMethod(String method, String cost, String delivery) {
    setState(() {
      _shippingMethod = method;
      _shippingCost = cost;
      _estimatedDelivery = delivery;
    });
  }
  
  // Show notes dialog
  void _showNotesDialog() {
    TextEditingController notesController = TextEditingController(text: _notes);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 30),
                      const Text(
                        'Write a notes for this order',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4A6741),
                        ),
                      ),
                    ],
                  ),
                  const Divider(thickness: 1, height: 30),
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: notesController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(15),
                        hintText: 'Write your notes here...',
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Make sure no private data ok?',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _notes = notesController.text;
                      });
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFF4A6741),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Checkout',
          style: TextStyle(
            color: Color(0xFF4A6741),
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Color(0xFFE8F5E9),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF4A6741)),
            onPressed: () {Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const ChatDetailScreen(), // Redirect to chat_buyer.dart
                      ),
                    );},
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Address Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Address for shipping',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4A6741),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: const [
                      Icon(
                        Icons.location_on,
                        color: Color(0xFF4A6741),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Home sweet home',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF4A6741),
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddressSelectionScreen()),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Expanded(
                            child: Text(
                              'Jalan Gelora Utama Blok HH2 No. 10, Pondok Pucung.....',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const Divider(thickness: 1, height: 20),
            
            // Product Section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCF1EE),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.network(
                      'assets/images/cream_jacket.png', // Placeholder for cream hoodie image
                      fit: BoxFit.contain,
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
                            color: Color(0xFF4A6741),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Rp 140.000',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 16,
                              backgroundImage: NetworkImage(
                                'https://i.imgur.com/B4Jzrx1.jpg', // Placeholder for user image
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'User 2',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Row(
                              children: const [
                                Icon(Icons.star, color: Colors.amber, size: 20),
                                Icon(Icons.star, color: Colors.amber, size: 20),
                                Icon(Icons.star, color: Colors.amber, size: 20),
                                Icon(Icons.star, color: Colors.amber, size: 20),
                                Icon(Icons.star_border, color: Colors.amber, size: 20),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Shipping Section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: InkWell(
                onTap: _showShippingMethodDialog,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$_shippingMethod shipping   ($_shippingCost)',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF4A6741),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Arriving estimated $_estimatedDelivery',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.chevron_right,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Notes Section
            InkWell(
              onTap: _showNotesDialog,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    const Icon(
                      Icons.note_alt_outlined,
                      color: Colors.black54,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      _notes.isEmpty ? 'Give notes to seller' : _notes,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.chevron_right,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
            ),
            
            const Divider(thickness: 1, height: 1),
            
            // Payment Method Section Header - Now clickable
            InkWell(
              onTap: _navigateToPaymentMethod,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Payment Method',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4A6741),
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
            ),
            
            // BCA
            ListTile(
              leading: Image.network(
                'https://i.imgur.com/rD6O9kW.png', // BCA logo placeholder
                width: 40,
                height: 40,
              ),
              title: const Text(
                'BCA Virtual Account',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Switch(
                value: _bcaSelected,
                onChanged: (value) {
                  setState(() {
                    _bcaSelected = value;
                    if (value) {
                      _bniSelected = false;
                      _goPaySelected = false;
                      _codSelected = false;
                      _selectedPaymentId = 'bca';
                      _selectedPaymentName = 'BCA Virtual Account';
                    }
                  });
                },
                activeTrackColor: const Color(0xFF4A6741).withOpacity(0.4),
                activeColor: const Color(0xFF4A6741),
              ),
              onTap: _navigateToPaymentMethod,
            ),
            
            // BNI
            ListTile(
              leading: Image.network(
                'https://i.imgur.com/nIHQ3H0.png', // BNI logo placeholder
                width: 40,
                height: 40,
              ),
              title: const Text(
                'BNI Virtual Account',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Switch(
                value: _bniSelected,
                onChanged: (value) {
                  setState(() {
                    _bniSelected = value;
                    if (value) {
                      _bcaSelected = false;
                      _goPaySelected = false;
                      _codSelected = false;
                      _selectedPaymentId = 'bni';
                      _selectedPaymentName = 'BNI Virtual Account';
                    }
                  });
                },
                activeTrackColor: const Color(0xFF4A6741).withOpacity(0.4),
                activeColor: const Color(0xFF4A6741),
              ),
              onTap: _navigateToPaymentMethod,
            ),
            
            // GoPay
            ListTile(
              leading: Image.network(
                'https://i.imgur.com/9VKuHWJ.png', // GoPay logo placeholder
                width: 40,
                height: 40,
              ),
              title: const Text(
                'GoPay Wallet',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Switch(
                value: _goPaySelected,
                onChanged: (value) {
                  setState(() {
                    _goPaySelected = value;
                    if (value) {
                      _bcaSelected = false;
                      _bniSelected = false;
                      _codSelected = false;
                      _selectedPaymentId = 'gopay';
                      _selectedPaymentName = 'GoPay Wallet';
                    }
                  });
                },
                activeTrackColor: const Color(0xFF4A6741).withOpacity(0.4),
                activeColor: const Color(0xFF4A6741),
              ),
              onTap: _navigateToPaymentMethod,
            ),
            
            // Cash on Delivery
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                child: const Icon(Icons.monetization_on, color: Colors.green, size: 30),
              ),
              title: const Text(
                'Cash on delivery (only within 10KM)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Switch(
                value: _codSelected,
                onChanged: (value) {
                  setState(() {
                    _codSelected = value;
                    if (value) {
                      _bcaSelected = false;
                      _bniSelected = false;
                      _goPaySelected = false;
                      _selectedPaymentId = 'cod';
                      _selectedPaymentName = 'Cash on delivery (only within 10KM)';
                    }
                  });
                },
                activeTrackColor: const Color(0xFF4A6741).withOpacity(0.4),
                activeColor: const Color(0xFF4A6741),
              ),
              onTap: _navigateToPaymentMethod,
            ),
            
            const Divider(thickness: 1, height: 20),
            
            // Transaction Summary
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Check your transaction again!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4A6741),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Items Total',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        'Rp 140.000',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Shipping Cost',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        _shippingCost,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Service Fee',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        'Rp 2.000',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Cost',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      // Calculate total based on shipping cost selected (simplified calculation)
                      Text(
                        _calculateTotal(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4A6741),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Continue Button
            // Continue Button onPressed event in CheckoutPage class
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () {
                  // Calculate payment due date (24 hours from now)
                  final dueDate = DateTime.now().add(const Duration(hours: 24));
                  
                  // Navigate to payment confirmation page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentConfirmationScreen(
                        virtualAccountNumber: '8077708581119607',
                        totalCost: _calculateTotal(),
                        paymentMethod: _selectedPaymentName,
                        dueDate: dueDate,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF4A6741),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size(double.infinity, 50),
                  elevation: 0,
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Helper method to calculate total cost based on shipping method
  String _calculateTotal() {
    // Extract numeric value from shipping cost string
    String costStr = _shippingCost.replaceAll('Rp ', '').replaceAll('.', '');
    int shippingCost = int.tryParse(costStr) ?? 45000;
    
    // Add item price and service fee
    int total = 140000 + shippingCost + 2000;
    
    // Format the total cost
    String formattedTotal = total.toString();
    if (formattedTotal.length > 3) {
      formattedTotal = 'Rp ${formattedTotal.substring(0, formattedTotal.length - 3)}.${formattedTotal.substring(formattedTotal.length - 3)}';
    } else {
      formattedTotal = 'Rp $formattedTotal';
    }
    
    return formattedTotal;
  }
}