import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'payment_complete.dart';

class PaymentConfirmationScreen extends StatefulWidget {
  final String virtualAccountNumber;
  final String totalCost;
  final String paymentMethod;
  final DateTime dueDate;

  const PaymentConfirmationScreen({
    Key? key,
    required this.virtualAccountNumber,
    required this.totalCost,
    required this.paymentMethod,
    required this.dueDate,
  }) : super(key: key);

  @override
  State<PaymentConfirmationScreen> createState() => _PaymentConfirmationScreenState();
}

class _PaymentConfirmationScreenState extends State<PaymentConfirmationScreen> {
  bool _isNumberCopied = false;

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    setState(() {
      _isNumberCopied = true;
    });
    
    // Reset the copied state after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isNumberCopied = false;
        });
      }
    });
  }

  String _formatRemainingTime() {
    final now = DateTime.now();
    final difference = widget.dueDate.difference(now);
    
    final hours = difference.inHours.remainder(24);
    final minutes = difference.inMinutes.remainder(60);
    final seconds = difference.inSeconds.remainder(60);
    
    return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F5E9),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF4A6741)),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Payment confirmation card
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Payment title and countdown
                      Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Color(0xFF4A6741),
                            radius: 20,
                            child: Icon(
                              Icons.access_time,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Complete Payment before",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF4A6741),
                                  ),
                                ),
                                Text(
                                  "${widget.dueDate.day} ${_getMonthName(widget.dueDate.month)} ${widget.dueDate.year}, ${widget.dueDate.hour}:${widget.dueDate.minute.toString().padLeft(2, '0')} WIB",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF4A6741),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Timer
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              _formatRemainingTime(),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF4A6741),
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      const Divider(height: 1, color: Color(0xFFCCDDCC)),
                      const SizedBox(height: 16),
                      
                      // Virtual account number
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Virtual Account Number",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF4A6741),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    widget.virtualAccountNumber,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF4A6741),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      _isNumberCopied ? Icons.check : Icons.copy_outlined,
                                      color: const Color(0xFF4A6741),
                                      size: 20,
                                    ),
                                    onPressed: () => _copyToClipboard(widget.virtualAccountNumber),
                                  ),
                                  const SizedBox(width: 8),
                                  Image.network(
                                    'https://i.imgur.com/rD6O9kW.png', // BCA logo placeholder
                                    width: 40,
                                    height: 24,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Total cost
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Total Cost",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF4A6741),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.totalCost,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF4A6741),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      const Divider(height: 1, color: Color(0xFFCCDDCC)),
                      const SizedBox(height: 16),
                      
                      // Important notes
                      const Text(
                        "Important :",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4A6741),
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "• ",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF4A6741),
                            ),
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF4A6741),
                                ),
                                children: [
                                  const TextSpan(
                                    text: "Transfer into Virtual Account Number only available to the bank that ",
                                  ),
                                  TextSpan(
                                    text: "You have chosen.",
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  const TextSpan(
                                    text: " You cannot transfer into form another different banks.",
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 8),
                      
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "• ",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF4A6741),
                            ),
                          ),
                          const Expanded(
                            child: Text(
                              "Your transaction are only going through to the seller when the payment are verified.",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF4A6741),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 30),
              
              // How to pay button
              OutlinedButton(
                onPressed: () {
                  _showHowToPayDialog(context);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF4A6741),
                  side: const BorderSide(color: Color(0xFF4A6741)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  "How to Pay",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Go to order button
              ElevatedButton(
                   onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>  MyApp(),
                        ),
                      );
                    },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF4A6741),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size(double.infinity, 50),
                  elevation: 0,
                ),
                child: const Text(
                  "Go to Orders",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showHowToPayDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 30),
                  const Text(
                    'How to Pay',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4A6741),
                    ),
                  ),
                ],
              ),
              const Divider(thickness: 1, height: 30),
              
              Expanded(
                child: ListView(
                  children: [
                    const Text(
                      'BCA Virtual Account',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4A6741),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    _buildHowToPayItem(
                      '1. Via ATM BCA',
                      [
                        'Insert your ATM card & enter your PIN',
                        'Select "Other Transactions"',
                        'Select "Transfer"',
                        'Select "To BCA Virtual Account"',
                        'Enter Virtual Account Number: ${widget.virtualAccountNumber}',
                        'Confirm the details & amount',
                        'Complete the transaction',
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    _buildHowToPayItem(
                      '2. Via BCA Mobile Banking',
                      [
                        'Log in to your BCA Mobile app',
                        'Select "m-BCA"',
                        'Select "m-Transfer"',
                        'Select "BCA Virtual Account"',
                        'Enter Virtual Account Number: ${widget.virtualAccountNumber}',
                        'Enter amount: ${widget.totalCost}',
                        'Enter your PIN',
                        'Confirm the transaction',
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    _buildHowToPayItem(
                      '3. Via Internet Banking',
                      [
                        'Log in to KlikBCA',
                        'Select "Fund Transfer"',
                        'Select "Transfer to BCA Virtual Account"',
                        'Enter Virtual Account Number: ${widget.virtualAccountNumber}',
                        'Confirm the transaction details',
                        'Complete the transaction using your KeyBCA',
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHowToPayItem(String title, List<String> steps) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        ...steps.map((step) => Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Text(
            step,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        )).toList(),
      ],
    );
  }

  String _getMonthName(int month) {
    const monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return monthNames[month - 1];
  }
}