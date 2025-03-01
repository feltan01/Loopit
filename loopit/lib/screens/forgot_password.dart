import 'package:flutter/material.dart';
import 'verification_forgotpassword.dart'; // Import halaman tujuan

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  bool _isEmailValid = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateEmail);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _validateEmail() {
    setState(() {
      _isEmailValid = _emailController.text.isNotEmpty;
    });
  }

  void _sendVerification() {
    if (_isEmailValid) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerificationForgotPasswordPage(
            email: _emailController.text,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Forgot Password",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            // Gambar dari assets
            Image.asset(
              "assets/images/forgot_password.png",
              width: 196,
              height: 196,
            ),
            const SizedBox(height: 60),
            // Teks informasi
            const Text(
              "Please enter your email address to receive a verification code",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 60),
            // Input Email
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Email Address:",
                style: TextStyle(color: Colors.black.withOpacity(0.7)),
              ),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                hintText: "Enter your email",
              ),
            ),
            const SizedBox(height: 30),
            // Tombol Kirim Verifikasi (aktif jika email terisi)
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isEmailValid ? _sendVerification : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isEmailValid
                      ? const Color(0xFFABC192)
                      : const Color(0xFFABC192).withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  "Send Verification",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
