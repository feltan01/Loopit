import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/offer.dart';

class CheckoutPage extends StatefulWidget {
  final Offer offer;

  const CheckoutPage({Key? key, required this.offer}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String selectedShipping = 'Standard shipping';
  int shippingCost = 45000;

  String formatCurrency(int amount) {
    return 'Rp ${NumberFormat('#,###', 'id').format(amount).replaceAll(',', '.')}';
  }

  void _showShippingOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Shipping Method',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A6741),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildShippingOption('Standard shipping', 45000, '5 - 7 Days', setState),
                  _buildShippingOption('Express shipping', 75000, '2 - 3 Days', setState),
                  _buildShippingOption('Same day delivery', 95000, 'Today', setState),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A6741),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        this.setState(() {}); // Update parent state
                      },
                      child: const Text(
                        'Confirm',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildShippingOption(String name, int cost, String duration, StateSetter modalSetState) {
    return InkWell(
      onTap: () {
        modalSetState(() {
          selectedShipping = name;
          shippingCost = cost;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: selectedShipping == name ? const Color(0xFF4A6741) : Colors.grey.shade300,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              selectedShipping == name ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selectedShipping == name ? const Color(0xFF4A6741) : Colors.grey,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$name (${formatCurrency(cost)})',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Arriving estimated $duration',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.offer.product;
    final serviceFee = 2000;
    final totalCost = widget.offer.amount + shippingCost + serviceFee;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4A6741)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Checkout',
          style: TextStyle(
            color: Color(0xFF4A6741),
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Address for shipping',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4A6741),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: const [
                            Icon(Icons.location_on, color: Color(0xFF4A6741)),
                            SizedBox(width: 8),
                            Text('Home sweet home'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(
                              child: Text(
                                'Jalan Gelora Utama Blok HH2 No. 10, Pondok Pucung.....',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(Icons.chevron_right, color: Colors.grey.shade600),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
                  
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 130,
                          height: 160,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFCF1EE),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Image.network(
                            product.fullImageUrl,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF4A6741),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                formatCurrency(widget.offer.amount.toInt()),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4A6741),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  const CircleAvatar(
                                    radius: 16,
                                    backgroundImage: NetworkImage('https://i.imgur.com/B4Jzrx1.jpg'),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text('User 2'),
                                ],
                              ),
                              const SizedBox(height: 6),
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
                        ),
                      ],
                    ),
                  ),
                  
                  InkWell(
                    onTap: _showShippingOptions,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$selectedShipping (${formatCurrency(shippingCost)})',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF4A6741),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                selectedShipping == 'Standard shipping' 
                                    ? 'Arriving estimated 5 - 7 Days' 
                                    : selectedShipping == 'Express shipping'
                                        ? 'Arriving estimated 2 - 3 Days'
                                        : 'Arriving estimated Today',
                              ),
                            ],
                          ),
                          Icon(Icons.chevron_right, color: Colors.grey.shade600),
                        ],
                      ),
                    ),
                  ),
                  
                  const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
                  
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Row(
                      children: [
                        Icon(Icons.note_alt_outlined, color: Colors.grey.shade700),
                        const SizedBox(width: 16),
                        const Expanded(child: Text('Give notes to seller')),
                        Icon(Icons.chevron_right, color: Colors.grey.shade600),
                      ],
                    ),
                  ),
                  
                  const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
                  
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Payment Method',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4A6741),
                              ),
                            ),
                            Icon(Icons.chevron_right, color: Colors.grey.shade600),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        Row(
                          children: [
                            Image.asset('assets/bca_logo.png', width: 50, height: 30,
                                errorBuilder: (context, error, stackTrace) => 
                                    const Text("BCA", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue))),
                            const SizedBox(width: 12),
                            const Expanded(child: Text('BCA Virtual Account')),
                            Switch(
                              value: true,
                              onChanged: (value) {},
                              activeColor: const Color(0xFF4A6741),
                              activeTrackColor: const Color(0xFFB2DFBC),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        
                        Row(
                          children: [
                            Image.asset('assets/bni_logo.png', width: 50, height: 30,
                                errorBuilder: (context, error, stackTrace) => 
                                    const Text("BNI", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange))),
                            const SizedBox(width: 12),
                            const Expanded(child: Text('BNI Virtual Account')),
                            Switch(
                              value: false,
                              onChanged: (value) {},
                              activeColor: const Color(0xFF4A6741),
                              activeTrackColor: const Color(0xFFB2DFBC),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        
                        Row(
                          children: [
                            Image.asset('assets/gopay_logo.png', width: 50, height: 30,
                                errorBuilder: (context, error, stackTrace) => 
                                    const Text("GoPay", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue))),
                            const SizedBox(width: 12),
                            const Expanded(child: Text('GoPay Wallet')),
                            Switch(
                              value: false,
                              onChanged: (value) {},
                              activeColor: const Color(0xFF4A6741),
                              activeTrackColor: const Color(0xFFB2DFBC),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        
                        Row(
                          children: [
                            Container(
                              width: 50,
                              height: 30,
                              alignment: Alignment.center,
                              child: Icon(Icons.attach_money, color: Colors.green.shade700),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(child: Text('Cash on delivery (only within 10KM)')),
                            Switch(
                              value: false,
                              onChanged: (value) {},
                              activeColor: const Color(0xFF4A6741),
                              activeTrackColor: const Color(0xFFB2DFBC),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
                  
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Check your transaction again!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4A6741),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Items Total'),
                            Text(formatCurrency(widget.offer.amount.toInt())),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Shipping Cost'),
                            Text(formatCurrency(shippingCost)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Service Fee'),
                            Text(formatCurrency(serviceFee)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Fix for the total cost display
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Cost',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              formatCurrency(totalCost.toInt()),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4A6741),
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
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE8F5E9),
                  foregroundColor: const Color(0xFF4A6741),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  // Continue with payment
                },
                child: const Text(
                  'Continue',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}