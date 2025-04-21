import 'package:flutter/material.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back and Title
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFE8F5E9),
                      ),
                      child: const Icon(Icons.arrow_back, color: Color(0xFF4A6741)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "About app",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF4A6741),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Logo
              Center(
                child: Image.asset(
                  'assets/images/logo.png', // Ganti sesuai path logo kamu
                  width: 190,
                  height: 190,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 40),

              // Version
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Version", style: TextStyle(color: Color(0xFF4A6741), fontSize: 16)),
                    Text("1.0", style: TextStyle(color: Color(0xFF4A6741), fontSize: 16)),
                  ],
                ),
              ),

              // Build
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Build", style: TextStyle(color: Color(0xFF4A6741), fontSize: 16)),
                    Text("1", style: TextStyle(color: Color(0xFF4A6741), fontSize: 16)),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Terms and Conditions
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  "Terms and conditions",
                  style: TextStyle(color: Color(0xFF4A6741), fontSize: 16),
                ),
                trailing: const Icon(Icons.chevron_right, color: Color(0xFF4A6741)),
                onTap: () {
                  // TODO: Navigate to terms page
                },
              ),

              // Help
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  "Help",
                  style: TextStyle(color: Color(0xFF4A6741), fontSize: 16),
                ),
                trailing: const Icon(Icons.chevron_right, color: Color(0xFF4A6741)),
                onTap: () {
                  // TODO: Navigate to help page
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
