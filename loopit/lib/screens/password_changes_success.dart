import 'dart:async';
import 'package:flutter/material.dart';
import 'login_page.dart'; // Pastikan ini adalah halaman login Anda

class PasswordChangedSuccessPage extends StatefulWidget {
  const PasswordChangedSuccessPage({super.key});

  @override
  _PasswordChangedSuccessPageState createState() => _PasswordChangedSuccessPageState();
}

class _PasswordChangedSuccessPageState extends State<PasswordChangedSuccessPage> {
  @override
  void initState() {
    super.initState();
    // Navigasi ke halaman login setelah 1.5 detik
    Future.delayed(const Duration(milliseconds: 1500), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
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
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green.shade100, // Warna hijau muda
              ),
              padding: const EdgeInsets.all(40),
              child: const Icon(Icons.check, size: 80, color: Colors.green),
            ),
            const SizedBox(height: 20),
            const Text(
              "Password Changed Successfully",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                
              ),
            ),
          ],
        ),
      ),
    );
  }
}
