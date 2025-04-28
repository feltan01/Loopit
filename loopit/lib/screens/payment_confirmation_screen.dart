import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/offer.dart'; // ← YOU NEED TO IMPORT THIS
import 'payment_complete.dart';

class PaymentConfirmationScreen extends StatefulWidget {
  final Offer offer; // ← ADD OFFER HERE
  final String virtualAccountNumber;
  final String totalCost;
  final String paymentMethod;
  final DateTime dueDate;

  const PaymentConfirmationScreen({
    Key? key,
    required this.offer, // ← ADD OFFER TO CONSTRUCTOR
    required this.virtualAccountNumber,
    required this.totalCost,
    required this.paymentMethod,
    required this.dueDate,
  }) : super(key: key);

  @override
  State<PaymentConfirmationScreen> createState() =>
      _PaymentConfirmationScreenState();
}

class _PaymentConfirmationScreenState extends State<PaymentConfirmationScreen> {
  bool _isNumberCopied = false;

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    setState(() {
      _isNumberCopied = true;
    });

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
    final product = widget.offer.product; // <-- NOW YOU CAN USE OFFER!

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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

              // PAYMENT INFO
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
                      // Timer
                      Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Color(0xFF4A6741),
                            radius: 20,
                            child: Icon(Icons.access_time, color: Colors.white),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Complete Payment before",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF4A6741),
                                    )),
                                Text(
                                  "${widget.dueDate.day} ${_getMonthName(widget.dueDate.month)} ${widget.dueDate.year}, ${widget.dueDate.hour}:${widget.dueDate.minute.toString().padLeft(2, '0')} WIB",
                                  style: const TextStyle(
                                      fontSize: 14, color: Color(0xFF4A6741)),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
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

                      // Virtual Account Number
                      const Text("Virtual Account Number",
                          style: TextStyle(
                              fontSize: 14, color: Color(0xFF4A6741))),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(widget.virtualAccountNumber,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF4A6741),
                              )),
                          IconButton(
                            icon: Icon(
                              _isNumberCopied
                                  ? Icons.check
                                  : Icons.copy_outlined,
                              color: const Color(0xFF4A6741),
                              size: 20,
                            ),
                            onPressed: () =>
                                _copyToClipboard(widget.virtualAccountNumber),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Total Cost
                      const Text("Total Cost",
                          style: TextStyle(
                              fontSize: 14, color: Color(0xFF4A6741))),
                      const SizedBox(height: 4),
                      Text(widget.totalCost,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF4A6741),
                          )),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // BUTTON: Go to Payment Complete
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => OrderComplete(
                        offer: widget.offer,
                        totalCost: widget.totalCost, // <-- PASSED CORRECTLY
                      ),
                    ),
                  );
                },

                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF4A6741),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size(double.infinity, 50),
                  elevation: 0,
                ),
                child: const Text(
                  "Go to Orders",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return monthNames[month - 1];
  }
}