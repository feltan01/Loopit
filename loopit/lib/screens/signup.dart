import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loopit/screens/verification_email.dart';
import 'package:loopit/screens/terms_condition.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _termsAccepted = false;
  bool _isFormValid = false;

  final String baseUrl = "http://192.168.18.50:8000/api"; // Gunakan ini untuk Android Emulator
  // final String baseUrl = "http://192.168.0.106:8000/api"; // Gunakan ini untuk Perangkat Fisik (isi dengan IP lokal kamu)

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
    _confirmPasswordController.addListener(_validateForm);
    _phoneController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isFormValid = 
          _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _confirmPasswordController.text.isNotEmpty &&
          _phoneController.text.isNotEmpty &&
          _termsAccepted;
    });
  }

  Future<void> _registerUser() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    try {
      final url = Uri.parse('$baseUrl/signup/');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': _emailController.text,
          'password': _passwordController.text,
          'username': _emailController.text.split('@')[0],
          'phone_number': _phoneController.text,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User registered successfully!')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const VerifyEmailPage()),
        );
      } else {
        final errorResponse = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: ${errorResponse['error'] ?? 'Unknown error'}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFABC192),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 60),
            Container(
              alignment: Alignment.centerLeft,
              child: Image.asset("assets/images/home_box.png", width: 140),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F8EC),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text(
                          "\u2190 Back to log in",
                          style: TextStyle(color: Color(0xFF6B7D50), fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Sign up",
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF6B7D50)),
                      ),
                      const SizedBox(height: 20),
                      _buildInputField(_emailController, Icons.email, "Email"),
                      const SizedBox(height: 15),
                      _buildInputField(_passwordController, Icons.lock, "Password", obscureText: true),
                      const SizedBox(height: 15),
                      _buildInputField(_confirmPasswordController, Icons.lock, "Confirm password", obscureText: true),
                      const SizedBox(height: 15),
                      _buildInputField(_phoneController, Icons.phone, "Phone +62"),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Checkbox(
                            value: _termsAccepted,
                            onChanged: (val) {
                              setState(() {
                                _termsAccepted = val ?? false;
                                _validateForm();
                              });
                            },
                            activeColor: const Color(0xFF6B7D50),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const TermsConditionPage()),
                                );
                              },
                              child: RichText(
                                text: const TextSpan(
                                  style: TextStyle(color: Colors.black),
                                  children: [
                                    TextSpan(text: "I have read and agree with the "),
                                    TextSpan(
                                      text: "Terms & Conditions",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isFormValid 
                                ? const Color(0xFFABC192) 
                                : const Color(0xFFABC192).withOpacity(0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 0,
                          ),
                          onPressed: _isFormValid ? _registerUser : null,
                          child: const Text(
                            "Sign up",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
    TextEditingController controller,
    IconData icon,
    String hintText, {
    bool obscureText = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.grey),
          hintText: hintText,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}
