import 'package:flutter/material.dart';
import 'package:loopit/screens/history_all.dart';
import 'package:loopit/screens/history_deposited.dart';

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
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const WithdrawnHistoryScreen(),
    );
  }
}

class WithdrawnHistoryScreen extends StatefulWidget {
  const WithdrawnHistoryScreen({Key? key}) : super(key: key);

  @override
  State<WithdrawnHistoryScreen> createState() => _WithdrawnHistoryScreenState();
}

class _WithdrawnHistoryScreenState extends State<WithdrawnHistoryScreen> {
  String activeFilter = 'Withdrawn';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Transaction History',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Filter Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                _buildFilterTab('Withdrawn'),
                const SizedBox(width: 8),
                _buildFilterTab('Deposited'),
                const SizedBox(width: 8),
                _buildFilterTab('All'),
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // Transaction List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(0),
              children: [
                _buildTransactionItem(
                  date: '25/02/2025',
                  amount: 'Rp 800.000',
                  status: 'Pending',
                  method: 'mBCA',
                  icon: Icons.calendar_today_outlined,
                ),
                const Divider(height: 1),
                _buildTransactionItem(
                  date: '12/11/2025',
                  amount: 'Rp 50.000',
                  status: 'Success',
                  method: 'mBCA',
                  icon: Icons.calendar_today_outlined,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String text) {
    final isActive = activeFilter == text;
    
    return Expanded(
      child: TweenAnimationBuilder<Color?>(
        duration: const Duration(milliseconds: 300),
        tween: ColorTween(
          begin: isActive ? const Color(0xFF8DB376) : Colors.white,
          end: isActive ? const Color(0xFF8DB376) : Colors.white,
        ),
        builder: (context, color, _) {
          return AnimatedScale(
            scale: isActive ? 1.0 : 0.97,
            duration: const Duration(milliseconds: 200),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  activeFilter = text;
                });
                
                // Navigation logic based on the selected tab
                Widget destinationScreen;
                switch (text) {
                  case 'Withdrawn':
                    destinationScreen = const WithdrawnHistoryScreen();
                    break;
                  case 'Deposited':
                    destinationScreen = const DepositedHistoryScreen();
                    break;
                  case 'All':
                    destinationScreen = const AllTransactionHistoryScreen();
                    break;
                  default:
                    destinationScreen = const WithdrawnHistoryScreen();
                }
                
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => destinationScreen),
                );
              },
              child: Container(
                height: 36,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                  boxShadow: isActive ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ] : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  text,
                  style: TextStyle(
                    color: isActive ? Colors.black87 : Colors.black54,
                    fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTransactionItem({
    required String date,
    required String amount,
    required String status,
    required String method,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date section with icon
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  const Text(
                    'Date and Time',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                date,
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    method == 'mBCA' ? Icons.account_balance : Icons.payment,
                    size: 14,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Withdrawal method',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                method,
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Amount and status
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  const Text(
                    'Amount:',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                amount,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text(
                    'Status:',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                status,
                style: TextStyle(
                  color: status == 'Success' ? Colors.green : Colors.orange,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
