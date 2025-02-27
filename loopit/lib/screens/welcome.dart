import 'package:flutter/material.dart';
import 'package:loopit/screens/home_page.dart';
import 'dart:async';


class SuccessAnimationPage extends StatefulWidget {
  const SuccessAnimationPage({super.key});

  @override
  _SuccessAnimationPageState createState() => _SuccessAnimationPageState();
}

class _SuccessAnimationPageState extends State<SuccessAnimationPage>
    with TickerProviderStateMixin {
  double opacity1 = 0.0;
  double opacity2 = 0.0;
  bool showLogo = false;
  late AnimationController _logoController;
  late Animation<Offset> _logoAnimation;

  @override
  void initState() {
    super.initState();

    _logoController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _logoAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeOut));

    _startAnimations();
  }

  void _startAnimations() {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        opacity1 = 1.0;
      });
    });

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        opacity1 = 0.0;
      });
    });

    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        opacity2 = 1.0;
      });
    });

    Future.delayed(const Duration(seconds: 7), () {
      setState(() {
        showLogo = true;
      });
      _logoController.forward();
    });

    // Pindah otomatis ke HomePage setelah 10 detik
    Future.delayed(const Duration(seconds: 10), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6EF),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedOpacity(
              opacity: opacity1,
              duration: const Duration(seconds: 1),
              child: const Text(
                "Your all set!",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF556B2F),
                ),
              ),
            ),
            AnimatedOpacity(
              opacity: opacity2,
              duration: const Duration(seconds: 1),
              child: const Text(
                "Welcome to",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF556B2F),
                ),
              ),
            ),
            if (showLogo)
              SlideTransition(
                position: _logoAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 90),
                    Image.asset("assets/images/logo.png", width: 140),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
