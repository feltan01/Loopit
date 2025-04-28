import 'package:flutter/material.dart';
import '../models/offer.dart'; // IMPORT OFFER MODEL
import 'orderlar.dart'; // IMPORT YOUR ORDER DETAIL SCREEN

class OrderComplete extends StatefulWidget {
  final Offer offer;
  final String totalCost; // <-- ADD totalCost here

  const OrderComplete({
    Key? key,
    required this.offer,
    required this.totalCost, // <-- Constructor accept totalCost
  }) : super(key: key);

  @override
  State<OrderComplete> createState() => _OrderCompletionScreenState();
}

class _OrderCompletionScreenState extends State<OrderComplete>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  bool _showRedirectScreen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
      ),
    );

    Future.delayed(const Duration(milliseconds: 400), () {
      _controller.forward().then((_) {
        setState(() {
          _showRedirectScreen = true;
        });

        Future.delayed(const Duration(milliseconds: 4000), () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => OrderDetailScreen(
                offer: widget.offer,
                totalCost: widget.totalCost, // <-- PASSED CORRECTLY
              ),
            ),
          );
        });
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: _showRedirectScreen
          ? const RedirectScreen()
          : FadeTransition(
              opacity: _fadeAnimation,
              child: const OrderCompletedScreen(),
            ),
    );
  }
}

class OrderCompletedScreen extends StatelessWidget {
  const OrderCompletedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFEDF7ED),
                borderRadius: BorderRadius.circular(60),
              ),
              child: const Center(
                child: Icon(
                  Icons.check,
                  size: 60,
                  color: Color(0xFF5F8D4E),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Payment Completed!',
              style: TextStyle(
                color: Color(0xFF5F8D4E),
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RedirectScreen extends StatefulWidget {
  const RedirectScreen({Key? key}) : super(key: key);

  @override
  State<RedirectScreen> createState() => _RedirectScreenState();
}

class _RedirectScreenState extends State<RedirectScreen> {
  String _text = 'Redirecting';
  int _dotCount = 0;

  @override
  void initState() {
    super.initState();
    _startDotAnimation();
  }

  void _startDotAnimation() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _dotCount = (_dotCount + 1) % 4;
          _text = 'Redirecting' + ('.' * _dotCount);
        });
        _startDotAnimation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          _text,
          style: const TextStyle(
            color: Color(0xFF5F8D4E),
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}