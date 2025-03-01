import 'package:flutter/material.dart';
import 'package:loopit/screens/verification_email.dart';
import 'package:loopit/screens/terms_condition.dart'; // Import Terms & Conditions page

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // Controllers for text fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  
  // Checkbox state
  bool _termsAccepted = false;
  
  // Form validity state
  bool _isFormValid = false;
  
  @override
  void initState() {
    super.initState();
    // Add listeners to validate form when text changes
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
    _confirmPasswordController.addListener(_validateForm);
    _phoneController.addListener(_validateForm);
  }
  
  @override
  void dispose() {
    // Clean up controllers
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
  
  // Validate form inputs
  void _validateForm() {
    setState(() {
      // Check if all text fields are filled and terms are accepted
      _isFormValid = 
          _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _confirmPasswordController.text.isNotEmpty &&
          _phoneController.text.isNotEmpty &&
          _termsAccepted;
    });
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
              alignment: Alignment.centerLeft, // Gambar mulai dari kiri
              child: Image.asset("assets/images/home_box.png", width: 140),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F8EC),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
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
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6B7D50),
                        ),
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: _termsAccepted,
                            onChanged: (val) {
                              setState(() {
                                _termsAccepted = val ?? false;
                                _validateForm(); // Revalidate form when checkbox changes
                              });
                            },
                            activeColor: const Color(0xFF6B7D50),
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(color: Colors.grey, fontSize: 12),
                                children: [
                                  const TextSpan(text: "I have read and agree with the "),
                                  WidgetSpan(
                                    child: GestureDetector(
                                      onTap: () {
                                        // Navigate to Terms & Conditions page
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const TermsConditionPage(),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        "Terms & Conditions",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
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
                          onPressed: _isFormValid
                              ? () {
                                  // Navigate to verification page when button is clicked
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const VerifyEmailPage()),
                                  );
                                }
                              : null, // Disable button if form is not valid
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 3,
            spreadRadius: 1,
          )
        ],
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