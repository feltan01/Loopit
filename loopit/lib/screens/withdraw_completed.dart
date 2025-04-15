import 'package:flutter/material.dart';
import 'package:loopit/screens/wallet.dart';

void main() {
  runApp(const WithdrawalConfirmationApp());
}

class WithdrawalConfirmationApp extends StatelessWidget {
  const WithdrawalConfirmationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const WithdrawalConfirmationScreen(),
    );
  }
}

class WithdrawalConfirmationScreen extends StatelessWidget {
  const WithdrawalConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Success icon
              Center(
                child: Container(
                  width: 150.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFE6F7E6),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.check,
                      size: 90,
                      color: const Color(0xFF5A8251),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Title text
              const Center(
                child: Text(
                  'Withdrawal Request Sent',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF5A8251),
                  ),
                ),
              ),
              
              // Date and time
              Center(
                child: Text(
                  '12th November 2024    12:07:28 WIB',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Deposit details card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F7E6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Amount
                    Text(
                      'Amount:',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Rp 50.000',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5A8251),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Deposit details white card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Deposit Location
                          Text(
                            'Withdrawal Location:',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0D6EFD).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.water_drop,
                                      size: 14,
                                      color: const Color(0xFF0D6EFD),
                                    ),
                                    const SizedBox(width: 2),
                                    const Text(
                                      'BCA',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF0D6EFD),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '1234 5678 90X YZ',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          
                          // Deposit Status
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Deposit Status:',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[800],
                                ),
                              ),
                              const Text(
                                'Success',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF76C893),
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
              
              const SizedBox(height: 24),
              
              // Confirm button
              SizedBox(
                height: 50,
                child: TextButton(
                  onPressed: () {
                    // Navigate to the Wallet screen when button is pressed
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const WalletBalanceScreen()),
                    );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFE6F7E6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Confirm',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF5A8251),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}