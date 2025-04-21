import 'package:flutter/material.dart';
import 'package:loopit/screens/history_deposited.dart';
import 'package:loopit/screens/history_withdrawn.dart';
import 'package:loopit/screens/wallet.dart';

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
      home: const AllTransactionHistoryScreen(),
    );
  }
}

class AllTransactionHistoryScreen extends StatefulWidget {
  const AllTransactionHistoryScreen({Key? key}) : super(key: key);

  @override
  State<AllTransactionHistoryScreen> createState() => _AllTransactionHistoryScreenState();
}

class _AllTransactionHistoryScreenState extends State<AllTransactionHistoryScreen> {
  String activeFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const WalletBalanceScreen(),
              ),
            );
          },
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
                _buildWithdrawnTab(),
                const SizedBox(width: 8),
                _buildDepositedTab(),
                const SizedBox(width: 8),
                _buildAllTab(),
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // Transaction List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(0),
              children: [
                // Withdrawal section
                if (activeFilter == 'All' || activeFilter == 'Withdrawn')
                  _buildSectionTitle('Withdrawal'),
                
                if (activeFilter == 'All' || activeFilter == 'Withdrawn')
                  _buildTransactionItem(
                    date: '25/02/2025',
                    amount: 'Rp 800.000',
                    status: 'Pending',
                    method: 'mBCA',
                    icon: Icons.calendar_today_outlined,
                    isDeposit: false,
                  ),
                
                if (activeFilter == 'All' || activeFilter == 'Withdrawn')
                  const Divider(height: 1),
                
                if (activeFilter == 'All' || activeFilter == 'Withdrawn')
                  _buildTransactionItem(
                    date: '12/11/2025',
                    amount: 'Rp 50.000',
                    status: 'Success',
                    method: 'mBCA',
                    icon: Icons.calendar_today_outlined,
                    isDeposit: false,
                  ),
                
                // Deposited section
                if (activeFilter == 'All' || activeFilter == 'Deposited')
                  _buildSectionTitle('Deposited'),
                
                if (activeFilter == 'All' || activeFilter == 'Deposited')
                  _buildTransactionItem(
                    date: '26/01/2025',
                    amount: 'Rp 250.000',
                    status: 'Pending',
                    method: 'mBCA',
                    icon: Icons.calendar_today_outlined,
                    isDeposit: true,
                  ),
                
                if (activeFilter == 'All' || activeFilter == 'Deposited')
                  const Divider(height: 1),
                
                if (activeFilter == 'All' || activeFilter == 'Deposited')
                  _buildTransactionItem(
                    date: '30/06/2025',
                    amount: 'Rp 175.000',
                    status: 'Success',
                    method: 'mBCA',
                    icon: Icons.calendar_today_outlined,
                    isDeposit: true,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWithdrawnTab() {
    final isActive = activeFilter == 'Withdrawn';
    
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
                  activeFilter = 'Withdrawn';
                });
                
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WithdrawnHistoryScreen(),
                  ),
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
                  'Withdrawn',
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

  Widget _buildDepositedTab() {
    final isActive = activeFilter == 'Deposited';
    
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
                  activeFilter = 'Deposited';
                });
                
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DepositedHistoryScreen(),
                  ),
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
                  'Deposited',
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

  Widget _buildAllTab() {
    final isActive = activeFilter == 'All';
    
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
                  activeFilter = 'All';
                });
                
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AllTransactionHistoryScreen(),
                  ),
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
                  'All',
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Color.fromARGB(255, 84, 113, 66),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTransactionItem({
    required String date,
    required String amount,
    required String status,
    required String method,
    required IconData icon,
    required bool isDeposit,
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
                  Icon(icon, size: 14, color: const Color.fromARGB(255, 84, 113, 66)),
                  const SizedBox(width: 4),
                  const Text(
                    'Date and Time',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color.fromARGB(255, 84, 113, 66),
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
                    color: const Color.fromARGB(255, 84, 113, 66),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isDeposit ? 'Deposit method' : 'Withdrawal method',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color.fromARGB(255, 84, 113, 66),
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
                      color: Color.fromARGB(255, 84, 113, 66),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                amount,
                style: TextStyle(
                  color: isDeposit ? Colors.green : Colors.red,
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
                      color: Color.fromARGB(255, 84, 113, 66),
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