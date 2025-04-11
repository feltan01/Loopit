import 'package:flutter/material.dart';
import 'delivery_detail.dart';
import 'orderdetails_va.dart';

void main() {
  runApp(const DeliveryConfirmation());
}

class DeliveryConfirmation extends StatelessWidget {
  const DeliveryConfirmation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
      home: const DeliveryConfirmationPage(),
    );
  }
}

class DeliveryConfirmationPage extends StatefulWidget {
  const DeliveryConfirmationPage({Key? key}) : super(key: key);

  @override
  State<DeliveryConfirmationPage> createState() => _DeliveryConfirmationPageState();
}

class _DeliveryConfirmationPageState extends State<DeliveryConfirmationPage> {
  final TextEditingController invoiceController = TextEditingController();
  final TextEditingController costController = TextEditingController();

  @override
  void dispose() {
    invoiceController.dispose();
    costController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView(
            children: [
              const SizedBox(height: 16),
              _buildHeader(context),
              const SizedBox(height: 16),
              const Divider(color: Colors.grey, height: 1),
              const SizedBox(height: 20),
              _buildDeliveryDetails(),
              const SizedBox(height: 40),
              _buildInformationForm(context),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
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
                MaterialPageRoute(builder: (context) => const OrderDetailsVA()),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          'Delivery Confirmation',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4D6A46),
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Delivery Detail',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4D6A46),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Standard Shipping (Rp 45.000)',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF4D6A46),
          ),
        ),
        const SizedBox(height: 24),
        _buildAddressSection('From', 'Jalan Gelora Utama', 'Blok HH2 No. 10', 
            'Jalan Gelora Utama Blok HH2 No. 10, Pondok Pucung, Pondok Aren, Tangerang Selatan, Banten, Indonesia'),
        const SizedBox(height: 24),
        _buildAddressSection('To', 'Jalan Gelora Utama', 'Blok HH2 No. 10', 
            'Jalan Gelora Utama Blok HH2 No. 10, Pondok Pucung, Pondok Aren, Tangerang Selatan, Banten, Indonesia'),
      ],
    );
  }

  Widget _buildAddressSection(String title, String address1, String address2, String fullAddress) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 50,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF4D6A46),
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Icon(
          Icons.location_on,
          color: Color(0xFF4D6A46),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                address1,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4D6A46),
                ),
              ),
              Text(
                address2,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4D6A46),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                fullAddress,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInformationForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Information Form',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4D6A46),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Please fill all the information below to confirm the delivery of your product.',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF4D6A46),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          '1. Invoice Number',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF4D6A46),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(30),
          ),
          child: TextField(
            controller: invoiceController,
            decoration: const InputDecoration(
              hintText: 'Enter Invoice Number',
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          '2. Total Cost of Item',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF4D6A46),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(30),
          ),
          child: TextField(
            controller: costController,
            decoration: const InputDecoration(
              hintText: 'Enter Total Cost of Item',
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(height: 32),
        Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const DeliveryDetailPage(), // Redirect to chat_buyer.dart
              ),
            );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEAF2E3),
              foregroundColor: const Color(0xFF4D6A46),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'Complete',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}