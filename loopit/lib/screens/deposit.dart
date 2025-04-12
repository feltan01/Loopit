import 'package:flutter/material.dart';
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
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
      ),
      home: const BalanceDepositPage(),
    );
  }
}

class BalanceDepositPage extends StatefulWidget {
  const BalanceDepositPage({Key? key}) : super(key: key);

  @override
  State<BalanceDepositPage> createState() => _BalanceDepositPageState();
}

class _BalanceDepositPageState extends State<BalanceDepositPage> {
  final TextEditingController _depositController = TextEditingController(text: 'Rp 50.000');
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
              const SizedBox(height: 20),
              _buildBalanceCard(),
              const SizedBox(height: 20),
              _buildDepositInput(),
              const SizedBox(height: 20),
              _buildPaymentMethodList(),
              const Spacer(),
              _buildDepositButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 20),
            onPressed: () {
              // Navigate back to wallet screen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const WalletBalanceScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
          const Text(
            'Balance Deposit',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard() {
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Balance Total:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
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
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Monthly\nRefunded Cash:',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      'Rp.000.000',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Total Money gained:',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      'Rp.000.000',
                      style: TextStyle(
                        fontSize: 14,
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

  Widget _buildDepositInput() {
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'How much would you like to Deposit',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
              controller: _depositController,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8E8E8E),
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose your preferred Deposit method',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _paymentMethods.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final method = _paymentMethods[index];
            return _buildPaymentMethodItem(method);
          },
        ),
      ],
    );
  }

  Widget _buildPaymentMethodItem(PaymentMethod method) {
    final index = _paymentMethods.indexOf(method);
    
    return InkWell(
      onTap: () {
        setState(() {
          _selectedBankIndex = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
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
                const SizedBox(width: 12),
                Text(
                  method.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            // Add radio button
            Radio<int>(
              value: index,
              groupValue: _selectedBankIndex,
              onChanged: (value) {
                setState(() {
                  _selectedBankIndex = value;
                });
              },
              activeColor: Colors.green.shade700,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDepositButton() {
    return ElevatedButton(
      onPressed: () {
        // Handle deposit button press
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFD3EAD3),
        foregroundColor: Colors.black,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: const Text(
        'Deposit Balance',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _depositController.dispose();
    super.dispose();
  }
}

class PaymentMethod {
  final String name;
  final String iconPath;

  PaymentMethod(this.name, this.iconPath);
}