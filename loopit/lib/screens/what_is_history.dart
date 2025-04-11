import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const TransactionHistoryInfoScreen(),
    );
  }
}

class TransactionHistoryInfoScreen extends StatelessWidget {
  const TransactionHistoryInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Go back action
            print('Back button pressed');
          },
        ),
        title: const Text(
          'What is History',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.normal,
            fontSize: 16,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What is this for?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'The Transaction History keeps a record of all the deposits and withdrawals you\'ve made in Loga\'s e-wallet. This allows you to track your balance, check past transactions, and verify completed payments.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Each transaction will show:',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoItem('Date & Time - When the deposit or withdrawal was made.'),
            _buildInfoItem('Amount - How much was added or withdrawn.'),
            _buildInfoItem('Status - Whether the transaction is Pending, Successful, or Failed.'),
            const SizedBox(height: 20),
            const Text(
              'If a transaction is pending, it may take some time to process. If a transaction fails, you may need to check your payment details or contact support.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Keeping an eye on your history helps you stay on top of your wallet balance and ensure all transactions are accurate.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2.0),
            child: Icon(
              Icons.check,
              size: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}