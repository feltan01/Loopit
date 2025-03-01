import 'package:flutter/material.dart';
import 'package:loopit/screens/create_password.dart'; // Ganti dengan halaman tujuan

class VerificationSuccessPage extends StatefulWidget {
  const VerificationSuccessPage({super.key});

  @override
  State<VerificationSuccessPage> createState() =>
      _VerificationSuccessPageState();
}

class _VerificationSuccessPageState extends State<VerificationSuccessPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1, milliseconds: 500), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CreatePasswordPage()), // Ganti halaman tujuan
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
            // Ikon centang hijau
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF5E6), // Warna hijau muda
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                size: 80,
                color: Color(0xFF4B654F), // Warna hijau tua
              ),
            ),
            const SizedBox(height: 20),
            // Teks "Verification Success"
            const Text(
              "Verification Success",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4B654F), // Warna hijau tua
              ),
            ),
          ],
        ),
      ),
    );
  }
}
