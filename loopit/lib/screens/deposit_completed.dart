import 'package:flutter/material.dart';
import 'package:loopit/screens/wallet.dart';

void main() {
  runApp(const DepositCompleted());
}

class DepositCompleted extends StatelessWidget {
  const DepositCompleted({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const DepositConfirmationScreen(),
    );
  }
}

class DepositConfirmationScreen extends StatelessWidget {
  const DepositConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive layout
    final screenSize = MediaQuery.of(context).size;
    final iconSize = screenSize.width * 0.2; // 20% of screen width for icon
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenSize.width * 0.05, // 5% horizontal padding
              vertical: screenSize.height * 0.02, // 2% vertical padding
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: screenSize.height * 0.05),
                
                // Success icon - more responsive
                Center(
                  child: Container(
                    width: iconSize,
                    height: iconSize,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFE6F7E6),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.check,
                        size: iconSize * 0.6, // 60% of container size
                        color: const Color(0xFF5A8251),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenSize.height * 0.02),
                
                // Title text
                const Center(
                  child: Text(
                    'Deposit Request Sent',
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
                
                SizedBox(height: screenSize.height * 0.03),
                
                // Deposit details card
                Container(
                  padding: EdgeInsets.all(screenSize.width * 0.04),
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
                          fontSize: 24, // Slightly smaller
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5A8251),
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.02),
                      
                      // Deposit details white card
                      Container(
                        padding: EdgeInsets.all(screenSize.width * 0.03),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Deposit Location
                            Text(
                              'Deposit Location:',
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
                                Expanded(
                                  child: Text(
                                    '1234 5678 90X YZ',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[800],
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: screenSize.height * 0.02),
                            
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
                
                SizedBox(height: screenSize.height * 0.03),
                
                // Confirm button - updated to match reference image
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Container(
                    width: double.infinity,
                    height: 56, // Fixed height like in the reference
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to the Wallet screen when button is pressed
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const WalletBalanceScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4E855E), // Darker green like in reference
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Confirm Payment',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white, // White text like in reference
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}