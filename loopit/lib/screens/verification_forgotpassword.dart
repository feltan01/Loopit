import 'package:flutter/material.dart';
import 'verification_success.dart'; // Import halaman tujuan

class VerificationForgotPasswordPage extends StatefulWidget {
  const VerificationForgotPasswordPage({super.key, required String email});

  @override
  _VerificationForgotPasswordPageState createState() =>
      _VerificationForgotPasswordPageState();
}

class _VerificationForgotPasswordPageState extends State<VerificationForgotPasswordPage> {
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    for (var controller in _controllers) {
      controller.addListener(_checkOTPComplete);
    }
  }

  void _checkOTPComplete() {
    bool allFilled = _controllers.every((controller) =>
        controller.text.isNotEmpty && RegExp(r'^[0-9]$').hasMatch(controller.text));

    setState(() {
      _isButtonEnabled = allFilled;
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _verifyOTP() {
    if (_isButtonEnabled) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const VerificationSuccessPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            "Verify Your Email",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 70),
            Image.asset("assets/images/verifyemail.png", width: 180),
            const SizedBox(height: 50),
            const Text(
              "Please enter the 4 digit code we have sent to your email address",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 50),
            _buildOTPFields(),
            const SizedBox(height: 50),
            GestureDetector(
              onTap: () {
                // TODO: Implement resend code logic
              },
              child: const Text(
                "Resend Code",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isButtonEnabled
                      ? const Color(0xFFABC192) // Warna aktif
                      : Colors.grey.shade400, // Warna disable
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                onPressed: _isButtonEnabled ? _verifyOTP : null,
                child: const Text(
                  "Verify",
                  style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOTPFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return Container(
          width: 50,
          height: 50,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F0E4),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: _controllers[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            decoration: const InputDecoration(
              counterText: "",
              border: InputBorder.none,
            ),
            onChanged: (value) {
              if (value.isNotEmpty && index < 3) {
                FocusScope.of(context).nextFocus(); // Pindah ke field berikutnya
              }
              _checkOTPComplete();
            },
          ),
        );
      }),
    );
  }
}
