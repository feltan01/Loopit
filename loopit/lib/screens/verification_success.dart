import 'package:flutter/material.dart';
import 'package:loopit/screens/create_password.dart';

class VerificationSuccessPage extends StatefulWidget {
  final String uid;
  final String token;

  const VerificationSuccessPage({
    super.key,
    required this.uid,
    required this.token,
  });

  @override
  State<VerificationSuccessPage> createState() => _VerificationSuccessPageState();
}

class _VerificationSuccessPageState extends State<VerificationSuccessPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1, milliseconds: 500), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CreatePasswordPage(
            uid: widget.uid,
            token: widget.token,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: const BoxDecoration(
                color: Color(0xFFEAF5E6),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                size: 80,
                color: Color(0xFF4B654F),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Verification Success",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4B654F),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
