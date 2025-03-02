import 'package:flutter/material.dart';

class SellerVerificationPage extends StatefulWidget {
  const SellerVerificationPage({super.key});

  @override
  _SellerVerificationPageState createState() => _SellerVerificationPageState();
}

class _SellerVerificationPageState extends State<SellerVerificationPage> {
  bool _isChecked = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Verification",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1), // Tinggi garis
          child: Container(
            color: const Color(0xFF4E6645), // Warna hijau tipis
            height: 1, // Ketebalan garis
            width: double.infinity,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              "To list an item on LoopIt, you must fill a verification form first to prevent malicious activities.",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              "Follow the following instructions to complete the form",
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),

            // Step 1: Upload ID
            _buildSectionTitle("1. We need to verify your ID"),
            const Text(
              "Take a photo with your face and ID side by side. Make sure that we can see your ID information clearly.",
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            Center(
              child: GestureDetector(
                onTap: () {
                  // Function to handle image upload
                },
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF4E6645), width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.add, color: Color(0xFF4E6645), size: 40),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Open instructions
                },
                child: const Text(
                  "Read Instruction >",
                  style: TextStyle(color: Color(0xFF4E6645), fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Step 2: Verify Information
            _buildSectionTitle("2. We need to verify your information"),
            _buildTextField(_nameController, "Name"),
            _buildTextField(_nikController, "NIK"),
            _buildTextField(_accountController, "Account number"),
            _buildTextField(_addressController, "Address according to ID card"),
            const SizedBox(height: 16),

            // Step 3: Terms & Conditions
            _buildSectionTitle("3. Understand the terms and condition"),
            Row(
              children: [
                Checkbox(
                  value: _isChecked,
                  onChanged: (value) {
                    setState(() {
                      _isChecked = value!;
                    });
                  },
                  activeColor: const Color(0xFF4E6645),
                ),
                GestureDetector(
                  onTap: () {
                    // Open Terms & Conditions
                  },
                  child: const Text.rich(
                    TextSpan(
                      text: "I agree the ",
                      style: TextStyle(fontSize: 14),
                      children: [
                        TextSpan(
                          text: "Terms and Conditions",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4E6645),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Terms and conditions details
            const Padding(
              padding: EdgeInsets.only(left: 36),
              child: Text(
                "By completing this form, the user has stated that:\n"
                "• All information sent to LoopIt is accurate, valid, and up to date.\n"
                "• The user has full permission to sell products on LoopIt.\n"
                "• All actions performed by the user are valid and follow the agreement.",
                style: TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(height: 16),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isChecked ? _submitForm : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isChecked ? const Color(0xFFEAF3DC) : Colors.grey.shade400,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text(
                  "SUBMIT",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF4E6645)),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Function to build section title
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Function to build text field
  Widget _buildTextField(TextEditingController controller, String hint) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF3DC),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
        ),
      ),
    );
  }

  // Function to handle form submission
  void _submitForm() {
    // Implement form submission logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Form Submitted Successfully")),
    );
  }
}
