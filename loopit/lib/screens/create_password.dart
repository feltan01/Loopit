import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loopit/screens/password_changes_success.dart';

class CreatePasswordPage extends StatefulWidget {
  final String uid;
  final String token;

  const CreatePasswordPage({super.key, required this.uid, required this.token});

  @override
  _CreatePasswordPageState createState() => _CreatePasswordPageState();
}

class _CreatePasswordPageState extends State<CreatePasswordPage> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isButtonEnabled = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _newPasswordController.addListener(_checkPasswords);
    _confirmPasswordController.addListener(_checkPasswords);
  }

  void _checkPasswords() {
    setState(() {
      _isButtonEnabled = _newPasswordController.text.isNotEmpty &&
          _confirmPasswordController.text.isNotEmpty &&
          _newPasswordController.text == _confirmPasswordController.text;
    });
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _savePassword() async {
    setState(() {
      _isSaving = true;
    });

    final response = await http.post(
      Uri.parse('http://192.168.18.50:8000/api/password/reset/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'password': _newPasswordController.text,
        'uid': widget.uid,
        'token': widget.token,
      }),
    );

    setState(() {
      _isSaving = false;
    });

    if (response.statusCode == 200) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PasswordChangedSuccessPage()),
      );
    } else {
      final error = jsonDecode(response.body);
      final message = error['non_field_errors']?[0] ?? "Failed to reset password.";
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
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
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text("Create New Password", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Container(
              decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFE8F0E4)),
              padding: const EdgeInsets.all(40),
              child: const Icon(Icons.lock, size: 80, color: Color(0xFF7D9E6A)),
            ),
            const SizedBox(height: 20),
            const Text(
              "Your new password must be different from your previous password",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 30),
            _buildPasswordField("New Password", _newPasswordController, _isNewPasswordVisible, () {
              setState(() {
                _isNewPasswordVisible = !_isNewPasswordVisible;
              });
            }),
            const SizedBox(height: 15),
            _buildPasswordField("Confirm Password", _confirmPasswordController, _isConfirmPasswordVisible, () {
              setState(() {
                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
              });
            }),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isButtonEnabled ? const Color(0xFFABC192) : Colors.grey.shade400,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: _isButtonEnabled && !_isSaving ? _savePassword : null,
                child: _isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Save", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller, bool isVisible, VoidCallback toggleVisibility) {
    return TextField(
      controller: controller,
      obscureText: !isVisible,
      decoration: InputDecoration(
        labelText: label,
        border: const UnderlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: toggleVisibility,
        ),
      ),
    );
  }
}
