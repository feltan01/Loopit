import 'package:flutter/material.dart';

void main() {
  runApp(const Dealdone());
}

class Dealdone extends StatelessWidget {
  const Dealdone({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deal Done Page',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const DealDonePage(),
    );
  }
}

class DealDonePage extends StatelessWidget {
  const DealDonePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFEEF7E9), // Light green background
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.check,
                  color: Color(0xFF596B4B), // Dark green checkmark
                  size: 60,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Deal Done!',
              style: TextStyle(
                color: Color(0xFF596B4B), // Dark green text
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}