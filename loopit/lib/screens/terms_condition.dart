import 'package:flutter/material.dart';

class TermsConditionPage extends StatelessWidget {
  const TermsConditionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // Menghilangkan back button
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset("assets/images/logo.png", width: 90), // Posisi logo di kiri
            const Text(
              "Terms & Conditions",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8CA481),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider( // Garis hijau pembatas
              color: Color(0xFF8CA481),
              thickness: 4,
            ),
            const SizedBox(height: 15),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Welcome to Loopit!",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF4E6645)),
                    ),
                    Text(
                      "By accessing or using our platform, you agree to comply with these Terms and Conditions. Please read them carefully.\n",
                      style: TextStyle(color: Color(0xFF4E6645)),
                    ),
                    _TermsSection("1. Acceptance of Terms", "By using Loopit (\"the App\"), you acknowledge and agree to these Terms and Conditions, along with our Privacy Policy. If you do not agree, please do not use the App."),
                    _TermsSection("2. Eligibility", "Users must register with a valid email address. You must be at least 18 years old or have parental consent."),
                    _TermsSection("3. Use of the Platform", "The App is strictly for buying and selling second-hand items within the campus area. Users must ensure that listings are accurate and lawful. Transactions must be conducted in-person within the designated campus area."),
                    _TermsSection("4. Prohibited Activities", "You agree not to: List prohibited items (illegal goods, weapons, counterfeit products, hazardous materials, etc.). Engage in fraud, harassment, or any illegal activities. Misuse the platform in any way."),
                    _TermsSection("5. Transactions and Payments", "The App acts as a marketplace and does not process payments or guarantee transactions. Buyers and sellers are responsible for arranging payments and exchanges. The App is not liable for any disputes or issues arising from transactions."),
                    _TermsSection("6. Content and Intellectual Property", "Users retain ownership of their content but grant the App a license to display listings. The App reserves the right to remove any content that violates these Terms."),
                    _TermsSection("7. Liability Disclaimer", "The App does not guarantee the quality, authenticity, or condition of listed items. Users assume all risks associated with transactions."),
                    _TermsSection("8. Account Suspension and Termination", "The App reserves the right to suspend or terminate accounts for violations of these Terms. Users may delete their accounts, but past transactions remain subject to these Terms."),
                    _TermsSection("9. Privacy and Data Protection", "User data is handled per our Privacy Policy. The App does not sell or distribute personal information without consent."),
                    _TermsSection("10. Modifications to Terms", "We may update these Terms at any time. Continued use of the App constitutes acceptance of any revisions."),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFABC192),
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
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _TermsSection extends StatelessWidget {
  final String title;
  final String content;
  const _TermsSection(this.title, this.content, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF4E6645)),
          ),
          Text(content, style: const TextStyle(color: Color(0xFF4E6645))),
        ],
      ),
    );
  }
}