import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/offer.dart';
import 'payment_confirmation_screen.dart';

class CheckoutPage extends StatefulWidget {
  final Offer offer;

  const CheckoutPage({Key? key, required this.offer}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String selectedShipping = 'Standard shipping';
  int shippingCost = 45000;
  int serviceFee = 2000;

  String selectedPayment = 'BCA';
  String paymentLabel = 'BCA Virtual Account';

  String formatCurrency(double amount) {
    return 'Rp ${NumberFormat('#,###', 'id').format(amount.round()).replaceAll(',', '.')}';
  }

  double get totalCost => widget.offer.amount + shippingCost + serviceFee;

  void _selectShipping(String shipping, int cost, String duration) {
    setState(() {
      selectedShipping = shipping;
      shippingCost = cost;
    });
    Navigator.pop(context);
  }

  void _showShippingOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildShippingOptionTile(
                  'Standard shipping', '5 - 7 Days', 45000),
              _buildShippingOptionTile('Express shipping', '2 - 3 Days', 75000),
              _buildShippingOptionTile(
                  'Same day delivery', '8 - 20 Hours', 85000),
            ],
          ),
        );
      },
    );
  }

  void _selectPayment(String payment, String label) {
    setState(() {
      selectedPayment = payment;
      paymentLabel = label;
    });
  }

  void _showPaymentOptions() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentMethodScreen(
          onSelectPayment: (payment, label) {
            _selectPayment(payment, label);
          },
          selectedPayment: selectedPayment,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.offer.product;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4A6741)),
          onPressed: () => Navigator.pop(context),
        ),
        title:
            const Text('Checkout', style: TextStyle(color: Color(0xFF4A6741))),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAddressSection(),
                  const Divider(thickness: 1, color: Color(0xFFF0F0F0)),
                  _buildProductSection(product),
                  const Divider(thickness: 1, color: Color(0xFFF0F0F0)),
                  _buildShippingSelectionTile(),
                  const Divider(thickness: 1, color: Color(0xFFF0F0F0)),
                  _buildNotesToSellerTile(),
                  const Divider(thickness: 1, color: Color(0xFFF0F0F0)),
                  _buildPaymentMethodSection(),
                  const Divider(thickness: 1, color: Color(0xFFF0F0F0)),
                  _buildSummarySection(),
                ],
              ),
            ),
          ),
          _buildContinueButton(),
        ],
      ),
    );
  }

  Widget _buildAddressSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Address for shipping',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A6741))),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on, color: Color(0xFF4A6741)),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Home sweet home',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500)),
                    SizedBox(height: 4),
                    Text('Jalan Gelora Utama Blok HH2 No. 10, Pondok Pucung...',
                        style: TextStyle(color: Colors.black54, fontSize: 14)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductSection(product) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFFCF1EE),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.network(product.fullImageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF4A6741),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  formatCurrency(widget.offer.amount),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A6741),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundImage:
                          NetworkImage('https://placeholder.com/user2'),
                      onBackgroundImageError: (_, __) {},
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "User 2",
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      children: const [
                        Icon(Icons.star, color: Color(0xFF4A6741), size: 18),
                        Icon(Icons.star, color: Color(0xFF4A6741), size: 18),
                        Icon(Icons.star, color: Color(0xFF4A6741), size: 18),
                        Icon(Icons.star, color: Color(0xFF4A6741), size: 18),
                        Icon(Icons.star_border,
                            color: Color(0xFF4A6741), size: 18),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShippingSelectionTile() {
    return InkWell(
      onTap: _showShippingOptions,
      child: Container(
        color: const Color(0xFFE8F5E9).withOpacity(0.5),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$selectedShipping (${formatCurrency(shippingCost.toDouble())})",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF4A6741),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    selectedShipping == "Standard shipping"
                        ? "Arriving estimated 5 - 7 Days"
                        : selectedShipping == "Express shipping"
                            ? "Arriving estimated 2 - 3 Days"
                            : "Arriving estimated 8 - 20 Hours",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildShippingOptionTile(String label, String duration, int cost) {
    bool isSelected = selectedShipping == label;

    return ListTile(
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: const Color(0xFF4A6741),
        ),
      ),
      subtitle: Text(
        "$duration - ${formatCurrency(cost.toDouble())}",
        style: const TextStyle(fontSize: 13),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: Color(0xFF4A6741))
          : const Icon(Icons.circle_outlined, color: Colors.grey),
      onTap: () => _selectShipping(label, cost, duration),
    );
  }

  Widget _buildNotesToSellerTile() {
    return ListTile(
      leading: const Icon(Icons.note_alt_outlined, color: Color(0xFF4A6741)),
      title: const Text(
        "Give notes to seller",
        style: TextStyle(
          fontSize: 16,
          color: Color(0xFF4A6741),
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {
        // Show notes input dialog or navigate to notes page
      },
    );
  }

  Widget _buildPaymentMethodSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Payment Method",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A6741),
                ),
              ),
              GestureDetector(
                onTap: _showPaymentOptions,
                child: const Icon(Icons.chevron_right, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildPaymentTile(
              'BCA', 'BCA Virtual Account', selectedPayment == 'BCA'),
          _buildPaymentTile(
              'BNI', 'BNI Virtual Account', selectedPayment == 'BNI'),
          _buildPaymentTile(
              'GoPay', 'GoPay Wallet', selectedPayment == 'GoPay'),
          _buildPaymentTile('COD', 'Cash on delivery (only within 10KM)',
              selectedPayment == 'COD'),
        ],
      ),
    );
  }

  Widget _buildPaymentTile(String code, String label, bool isActive) {
    Widget leadingIcon;

    switch (code) {
      case 'BCA':
        leadingIcon = Image.asset('assets/images/bca_logo.png',
            width: 40,
            height: 24,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.account_balance, color: Colors.blue));
        break;
      case 'BNI':
        leadingIcon = Image.asset('assets/images/bni_logo.png',
            width: 40,
            height: 24,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.account_balance, color: Colors.orange));
        break;
      case 'GoPay':
        leadingIcon = Image.asset('assets/images/gopay_logo.png',
            width: 40,
            height: 24,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.account_balance_wallet, color: Colors.blue));
        break;
      case 'COD':
        leadingIcon = const Icon(Icons.money, color: Colors.green);
        break;
      default:
        leadingIcon =
            const Icon(Icons.account_balance, color: Color(0xFF4A6741));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(width: 40, child: leadingIcon),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Switch(
            value: selectedPayment == code,
            activeColor: const Color(0xFF4A6741),
            activeTrackColor: const Color(0xFF4A6741).withOpacity(0.5),
            onChanged: (value) {
              if (value) {
                _selectPayment(code, label);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Check your transaction again!",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A6741),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Items Total"),
              Text(
                formatCurrency(widget.offer.amount),
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Shipping Cost"),
              Text(
                formatCurrency(shippingCost.toDouble()),
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Service Fee"),
              Text(
                formatCurrency(serviceFee.toDouble()),
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const Divider(height: 24, thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total Cost",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                formatCurrency(totalCost),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF4A6741),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE8F5E9),
            foregroundColor: const Color(0xFF4A6741),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 0,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PaymentConfirmationScreen(
                  offer: widget.offer,
                  virtualAccountNumber: '8077708581119607',
                  totalCost: formatCurrency(totalCost),
                  paymentMethod: selectedPayment,
                  dueDate: DateTime.now().add(const Duration(hours: 24)),
                ),
              ),
            );
          },
          child: const Text(
            'Continue',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}

// Additional screen for payment method selection (can be moved to a separate file)
class PaymentMethodScreen extends StatelessWidget {
  final Function(String, String) onSelectPayment;
  final String selectedPayment;

  const PaymentMethodScreen({
    Key? key,
    required this.onSelectPayment,
    required this.selectedPayment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4A6741)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Payment Method',
          style: TextStyle(color: Color(0xFF4A6741)),
        ),
      ),
      body: ListView(
        children: [
          _buildPaymentOption(context, 'BCA', 'BCA Virtual Account'),
          _buildPaymentOption(context, 'BNI', 'BNI Virtual Account'),
          _buildPaymentOption(context, 'GoPay', 'GoPay Wallet'),
          _buildPaymentOption(
              context, 'COD', 'Cash on delivery (only within 10KM)'),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(BuildContext context, String code, String label) {
    bool isSelected = selectedPayment == code;

    Widget leadingIcon;

    switch (code) {
      case 'BCA':
        leadingIcon = Image.asset('assets/images/bca_logo.png',
            width: 40,
            height: 24,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.account_balance, color: Colors.blue));
        break;
      case 'BNI':
        leadingIcon = Image.asset('assets/images/bni_logo.png',
            width: 40,
            height: 24,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.account_balance, color: Colors.orange));
        break;
      case 'GoPay':
        leadingIcon = Image.asset('assets/images/gopay_logo.png',
            width: 40,
            height: 24,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.account_balance_wallet, color: Colors.blue));
        break;
      case 'COD':
        leadingIcon = const Icon(Icons.money, color: Colors.green);
        break;
      default:
        leadingIcon =
            const Icon(Icons.account_balance, color: Color(0xFF4A6741));
    }

    return ListTile(
      leading: SizedBox(width: 40, child: leadingIcon),
      title: Text(label),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: Color(0xFF4A6741))
          : const Icon(Icons.circle_outlined, color: Colors.grey),
      onTap: () {
        onSelectPayment(code, label);
        Navigator.pop(context);
      },
    );
  }
}