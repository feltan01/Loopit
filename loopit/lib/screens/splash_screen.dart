import 'package:flutter/material.dart';
import 'dart:async';
import 'login_page.dart'; // Pastikan HomePage diimport

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _lController;
  late Animation<Offset> _lAnimation;

  late AnimationController _oopitController;
  late Animation<Offset> _oopitAnimation;
  late Animation<double> _oopitOpacity;

  double lOffsetX = 0;
  double oopitOffsetX = -27;

  @override
  void initState() {
    super.initState();

    _lController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _lAnimation = Tween<Offset>(
      begin: Offset(lOffsetX, 2),
      end: Offset(lOffsetX, 0),
    ).animate(CurvedAnimation(
      parent: _lController,
      curve: Curves.easeOut,
    ));

    _oopitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _oopitAnimation = Tween<Offset>(
      begin: Offset(oopitOffsetX, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _oopitController,
      curve: Curves.easeOut,
    ));

    _oopitOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _oopitController,
      curve: Curves.easeIn,
    ));

    _startAnimation();
  }

  void _startAnimation() async {
    _lController.forward();
    await Future.delayed(const Duration(milliseconds: 700));
    _oopitController.forward();

    // Delay total 4 detik sebelum pindah ke HomePage
    await Future.delayed(const Duration(seconds: 3));
    _navigateToHome();
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  void dispose() {
    _lController.dispose();
    _oopitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double centerY = screenHeight / 2 - 50;

    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F2),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: MediaQuery.of(context).size.width / 2 - 90 + lOffsetX,
            top: centerY,
            child: SlideTransition(
              position: _lAnimation,
              child: Image.asset("assets/images/logo_L.png", width: 100),
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width / 2 - 10 + oopitOffsetX,
            top: centerY,
            child: FadeTransition(
              opacity: _oopitOpacity,
              child: SlideTransition(
                position: _oopitAnimation,
                child: Image.asset("assets/images/logo_oopit.png", width: 140),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
