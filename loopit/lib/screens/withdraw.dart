import 'package:flutter/material.dart';
import 'package:loopit/screens/wallet.dart';
import 'package:loopit/screens/withdraw_completed.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
      ),
      home: const BalanceWithdrawalPage(),
    );
  }
}

class BalanceWithdrawalPage extends StatefulWidget {
  const BalanceWithdrawalPage({super.key});

  @override
  State<BalanceWithdrawalPage> createState() => _BalanceWithdrawalPageState();
}

class _BalanceWithdrawalPageState extends State<BalanceWithdrawalPage> {
  final TextEditingController _withdrawalController = TextEditingController(text: 'Rp 50.000');
  int? _selectedBankIndex;
  final List<PaymentMethod> _paymentMethods = [
    PaymentMethod("BCA", "assets/icons/bca.png"),
    PaymentMethod("Mandiri", "assets/icons/mandiri.png"),
    PaymentMethod("BRI", "assets/icons/bri.png"),
    PaymentMethod("BNI", "assets/icons/bni.png"),
    PaymentMethod("GoPay Wallet", "assets/icons/gopay.png"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              // Use a reduced height balance card
              _buildBalanceCardCompact(),
              const SizedBox(height: 10),
              // Use a reduced height withdrawal input
              _buildWithdrawalInputCompact(),
              const SizedBox(height: 10),
              // Show fewer payment methods
              _buildPaymentMethodCompact(),
              const Spacer(flex: 1),
              _buildWithdrawalButton(),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, size: 20),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WalletBalanceScreen(),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
          const Text(
            'Balance Withdrawal',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCardCompact() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFD3EAD3),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Balance Total:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 0,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Rp.000.000',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Monthly Refunded Cash:',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      'Rp.000.000',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Total Money gained:',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      'Rp.000.000',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWithdrawalInputCompact() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFD3EAD3),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'How much would you like to Withdraw',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 0,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _withdrawalController,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8E8E8E),
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodCompact() {
    // Only show first 3 payment methods to prevent overflow
    final displayMethods = _paymentMethods.take(3).toList();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose your preferred Withdrawal method',
          style: TextStyle(
            fontSize: 12,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        // Build fixed-sized payment method items
        Column(
          children: [
            for (int i = 0; i < displayMethods.length; i++) ...[
              _buildPaymentMethodItemCompact(displayMethods[i]),
              if (i < displayMethods.length - 1) 
                const Divider(height: 1, thickness: 0.5),
            ],
          ],
        ),
        // Add a "View more" option if needed
        if (_paymentMethods.length > 3) 
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    // Show modal with all payment methods
                    _showAllPaymentMethods();
                  },
                  child: const Text(
                    'View more payment options',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildPaymentMethodItemCompact(PaymentMethod method) {
    final index = _paymentMethods.indexOf(method);
    
    return InkWell(
      onTap: () {
        setState(() {
          _selectedBankIndex = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  method.iconPath,
                  width: 20,
                  height: 20,
                  errorBuilder: (context, error, stackTrace) => 
                    Container(
                      width: 20, 
                      height: 20, 
                      color: Colors.grey.withOpacity(0.3),
                      child: const Icon(Icons.account_balance, size: 14, color: Colors.blue),
                    ),
                ),
                const SizedBox(width: 8),
                Text(
                  method.name,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            // Use a more compact radio button
            SizedBox(
              width: 20,
              height: 20,
              child: Radio<int>(
                value: index,
                groupValue: _selectedBankIndex,
                onChanged: (value) {
                  setState(() {
                    _selectedBankIndex = value;
                  });
                },
                activeColor: Colors.green.shade700,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: const VisualDensity(
                  horizontal: VisualDensity.minimumDensity,
                  vertical: VisualDensity.minimumDensity,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAllPaymentMethods() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'All Payment Methods',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: _paymentMethods.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final method = _paymentMethods[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Image.asset(
                        method.iconPath,
                        width: 24,
                        height: 24,
                        errorBuilder: (context, error, stackTrace) => 
                          Container(
                            width: 24, 
                            height: 24, 
                            color: Colors.grey.withOpacity(0.3),
                            child: const Icon(Icons.account_balance, size: 16, color: Colors.blue),
                          ),
                      ),
                      title: Text(method.name),
                      trailing: Radio<int>(
                        value: index,
                        groupValue: _selectedBankIndex,
                        onChanged: (value) {
                          setState(() {
                            _selectedBankIndex = value;
                          });
                          Navigator.pop(context);
                        },
                      ),
                      onTap: () {
                        setState(() {
                          _selectedBankIndex = index;
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWithdrawalButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const WithdrawalConfirmationScreen(),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFD3EAD3),
        foregroundColor: Colors.black,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: const Text(
        'Withdraw Balance',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _withdrawalController.dispose();
    super.dispose();
  }
}

class PaymentMethod {
  final String name;
  final String iconPath;

  PaymentMethod(this.name, this.iconPath);
}

