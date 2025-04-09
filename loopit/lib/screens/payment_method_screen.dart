import 'package:flutter/material.dart';

class PaymentMethodScreen extends StatefulWidget {
  final Function(String paymentType, String paymentName) onPaymentSelected;
  final String initialPaymentType;

  const PaymentMethodScreen({
    Key? key, 
    required this.onPaymentSelected,
    this.initialPaymentType = 'bca',
  }) : super(key: key);

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  // Payment selection states
  late String _selectedPayment;
  
  @override
  void initState() {
    super.initState();
    _selectedPayment = widget.initialPaymentType;
  }

  // Payment method data
  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 'bca',
      'name': 'BCA Virtual Account',
      'logo': 'https://i.imgur.com/rD6O9kW.png',
    },
    {
      'id': 'mandiri',
      'name': 'Mandiri Virtual Account',
      'logo': 'https://i.imgur.com/vfZdhzF.png',
    },
    {
      'id': 'bri',
      'name': 'BRI Virtual Account',
      'logo': 'https://i.imgur.com/JRl9Bmp.png',
    },
    {
      'id': 'bni',
      'name': 'BNI Virtual Account',
      'logo': 'https://i.imgur.com/nIHQ3H0.png',
    },
    {
      'id': 'gopay',
      'name': 'GoPay Wallet',
      'logo': 'https://i.imgur.com/9VKuHWJ.png',
    },
    {
      'id': 'cod',
      'name': 'Cash on delivery (only within 10KM)',
      'logo': '',
      'icon': Icons.monetization_on,
      'iconColor': Colors.green,
    },
    {
      'id': 'loopit',
      'name': 'Loopit Wallet',
      'logo': 'https://i.imgur.com/8yXtMDR.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Payment Method',
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
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _paymentMethods.length,
        itemBuilder: (context, index) {
          final payment = _paymentMethods[index];
          final bool isSelected = _selectedPayment == payment['id'];
          
          return ListTile(
            leading: payment['logo'].isNotEmpty 
              ? Image.network(
                  payment['logo'],
                  width: 40,
                  height: 40,
                  errorBuilder: (context, error, stackTrace) => 
                    const Icon(Icons.credit_card, color: Color(0xFF4A6741), size: 30),
                )
              : Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  child: Icon(
                    payment['icon'] ?? Icons.credit_card, 
                    color: payment['iconColor'] ?? const Color(0xFF4A6741), 
                    size: 30
                  ),
                ),
            title: Text(
              payment['name'],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Switch(
              value: isSelected,
              onChanged: (value) {
                if (value) {
                  setState(() {
                    _selectedPayment = payment['id'];
                  });
                }
              },
              activeTrackColor: const Color(0xFF4A6741).withOpacity(0.4),
              activeColor: const Color(0xFF4A6741),
            ),
            onTap: () {
              setState(() {
                _selectedPayment = payment['id'];
              });
              
              // Slight delay to show selection before returning
              Future.delayed(const Duration(milliseconds: 200), () {
                widget.onPaymentSelected(payment['id'], payment['name']);
                Navigator.pop(context);
              });
            },
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: () {
            // Find the selected payment method
            final selectedPayment = _paymentMethods.firstWhere(
              (payment) => payment['id'] == _selectedPayment,
              orElse: () => _paymentMethods.first,
            );
            
            widget.onPaymentSelected(
              selectedPayment['id'], 
              selectedPayment['name']
            );
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
            elevation: 0,
          ),
          child: const Text(
            'Confirm Selection',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}