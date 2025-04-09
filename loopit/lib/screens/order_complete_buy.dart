import 'package:flutter/material.dart';
import 'orderlar.dart'; // Import for the HomePage

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Order Completion Animation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: const OrderComplete(),
    );
  }
}

class OrderComplete extends StatefulWidget {
  const OrderComplete({Key? key}) : super(key: key);

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

    // Start animation after a short delay to show completion screen
    Future.delayed(const Duration(milliseconds: 400), () {
      _controller.forward().then((_) {
        setState(() {
          _showRedirectScreen = true;
        });
        
        // Wait a bit to show the redirect message, then navigate to HomePage
        Future.delayed(const Duration(milliseconds: 4000), () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const Orders()),
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
              'Order Completed',
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