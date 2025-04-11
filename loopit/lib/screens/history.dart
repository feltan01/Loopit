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
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const TransactionHistoryScreen(),
    );
  }
}

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({Key? key}) : super(key: key);

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  int _selectedTabIndex = 0; // Default to 'Withdrawn' tab
  
  // Color definitions
  final Color peachLight = const Color(0xFFFFE5D9);
  final Color peachBorder = const Color.fromARGB(255, 255, 216, 197);
  final Color greenIcon = const Color(0xFFCAE5CA);
  final Color greenCircle = const Color(0xFFF3F9F3);

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
          'History',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.normal,
            fontSize: 16,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Transaction History title
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 12.0),
            child: const Text(
              'Transaction History',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          
          // Filter tabs with proper spacing and layout
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 12.0),
            child: Row(
              children: [
                _buildAnimatedFilterTab('Withdrawn', 0),
                const SizedBox(width: 10),
                _buildAnimatedFilterTab('Deposited', 1),
                const SizedBox(width: 10),
                _buildAnimatedFilterTab('All', 2),
              ],
            ),
          ),
          
          // Divider line
          Container(
            height: 1,
            color: Colors.grey.withOpacity(0.2),
          ),
          
          // Empty state content
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: greenCircle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.history,
                        size: 36,
                        color: greenIcon,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'You haven\'t made any transactions.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedFilterTab(String title, int index) {
    final isSelected = _selectedTabIndex == index;
    
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedTabIndex = index;
            });
            print('$title tab selected');
          },
          borderRadius: BorderRadius.circular(20),
          splashColor: peachLight,
          highlightColor: peachLight.withOpacity(0.5),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? peachBorder : Colors.grey.shade400,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(20),
              color: isSelected ? peachLight : Colors.transparent,
            ),
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}