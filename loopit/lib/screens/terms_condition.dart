import 'package:flutter/material.dart';

class TermsConditionPage extends StatelessWidget {
  const TermsConditionPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Color scheme from the images
    const Color darkGreen = Color(0xFF4E6645);
    const Color lightGreen = Color(0xFFABC192);
    const Color backgroundColor = Color(0xFFF9FCF7);
    const Color dividerColor = Color(0xFFABC192);
    
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            children: [
              // Header with logo and title
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/logo.png", // Loopit logo from Image 2
                    height: 40,
                  ),
                  const Spacer(),
                  const Text(
                    "Terms & Conditions",
                    style: TextStyle(
                      fontSize: 22,
                      color: lightGreen,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Green divider line
              const Divider(
                color: dividerColor,
                thickness: 2,
                height: 0,
              ),
              const SizedBox(height: 16),
              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome section
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(fontSize: 16, color: darkGreen),
                          children: [
                            TextSpan(
                              text: "Welcome to Loopit! ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: "By accessing or using our platform, you agree to comply with these Terms and Conditions. Please read them carefully.",
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Terms sections
                      _buildTermSection(
                        "1. Acceptance of Terms",
                        "By using Loopit (\"the App\") You acknowledge and agree to these Terms and Conditions, along with our Privacy Policy. If you do not agree, please do not use the App.",
                      ),
                      
                      _buildTermSection(
                        "2. Eligibility",
                        "Users must register with a valid email address. You must be at least 18 years old or have parental consent.",
                      ),
                      
                      _buildTermSection(
                        "3. Use of the Platform",
                        "The App is strictly for buying and selling second-hand items within the campus area. Users must ensure that listings are accurate and lawful. Transactions must be conducted in-person within the designated campus area.",
                      ),
                      
                      _buildTermSection(
                        "4. Prohibited Activities",
                        ", you agree not to: List prohibited items (illegal goods, weapons, counterfeit products, hazardous materials, etc.). Engage in fraud, harassment, or any illegal activities. Misuse the platform in any way.",
                      ),
                      
                      _buildTermSection(
                        "5. Transactions and Payments",
                        "The App acts as a marketplace and does not process payments or guarantee transactions. Buyers and sellers are responsible for arranging payments and exchanges. The App is not liable for any disputes or issues arising from transactions.",
                      ),
                      
                      _buildTermSection(
                        "6. Content and Intellectual Property",
                        "Users retain ownership of their content but grant the App a license to display listings. The App reserves the right to remove any content that violates these Terms.",
                      ),
                      
                      _buildTermSection(
                        "7. Liability Disclaimer",
                        "The App does not guarantee the quality, authenticity, or condition of listed items. Users assume all risks associated with transactions.",
                      ),
                      
                      _buildTermSection(
                        "8. Account Suspension and Termination",
                        "The App reserves the right to suspend or terminate accounts for violations of these Terms. Users may delete their accounts, but past transactions remain subject to these Terms.",
                      ),
                      
                      _buildTermSection(
                        "9. Privacy and Data Protection",
                        "User data is handled per our Privacy Policy. The App does not sell or distribute personal information without consent.",
                      ),
                      
                      _buildTermSection(
                        "10. Modifications to Terms",
                        "We may update these Terms at any time. Continued use of the App constitutes acceptance of any revisions.",
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Continue button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: lightGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Continue",
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
    );
  }
  
  Widget _buildTermSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF4E6645),
            ),
          ),
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF4E6645),
            ),
          ),
        ],
      ),
    );
  }
}