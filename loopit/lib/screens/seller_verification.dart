import 'package:flutter/material.dart';
import 'new_listing.dart';
import 'terms_condition.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Seller Verification',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const SellerVerificationPage(),
    );
  }
}

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
  bool _hasUploadedID = false; // Track if ID has been uploaded

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
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: const Color(0xFF4E6645),
            height: 1,
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
                  // In a real app, you would implement photo picking/camera functionality
                  setState(() {
                    _hasUploadedID =
                        true; // For demo purposes, set to true on tap
                  });
                },
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color(0xFF4E6645), width: 2),
                    borderRadius: BorderRadius.circular(8),
                    color: _hasUploadedID
                        ? const Color(0xFFEAF3DC)
                        : Colors.transparent,
                  ),
                  child: _hasUploadedID
                      ? const Icon(Icons.check,
                          color: Color(0xFF4E6645), size: 40)
                      : const Icon(Icons.add,
                          color: Color(0xFF4E6645), size: 40),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Navigate to the ID Photo Instruction page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const IDPhotoInstructionPage(),
                    ),
                  );
                },
                child: const Text(
                  "Read Instruction >",
                  style: TextStyle(
                      color: Color(0xFF4E6645), fontWeight: FontWeight.bold),
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
                    // Navigate to Terms & Conditions page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TermsConditionPage(),
                      ),
                    );
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
                onPressed: () => _validateAndSubmit(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEAF3DC),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text(
                  "SUBMIT",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4E6645)),
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

  // Function to validate form and submit
  void _validateAndSubmit() {
    // Check if all fields are filled and terms are accepted
    if (_nameController.text.isEmpty ||
        _nikController.text.isEmpty ||
        _accountController.text.isEmpty ||
        _addressController.text.isEmpty ||
        !_hasUploadedID ||
        !_isChecked) {
      // Show the required fields notification
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const RequiredFieldsNotificationPage(),
        ),
      );
    } else {
      // If all requirements are met, proceed to success page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const VerificationSuccessPage(),
        ),
      );
    }
  }
}

// Required Fields Notification Page
class RequiredFieldsNotificationPage extends StatelessWidget {
  const RequiredFieldsNotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Notification container with exclamation mark
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                color: Color(0xFFEDF7E7), // Light green background
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Exclamation mark
                    Container(
                      width: 20,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Color(0xFF4D6A50), // Dark green
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Dot below exclamation mark
                    Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Color(0xFF4D6A50), // Dark green
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Text message
            const Text(
              'Fill the required',
              style: TextStyle(
                color: Color(0xFF4D6A50), // Dark green
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Text(
              'fields',
              style: TextStyle(
                color: Color(0xFF4D6A50), // Dark green
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 40),
            // Back button
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEAF3DC),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Back",
                  style: TextStyle(
                    color: Color(0xFF4D6A50),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
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

class VerificationSuccessPage extends StatefulWidget {
  const VerificationSuccessPage({super.key});

  @override
  _VerificationSuccessPageState createState() =>
      _VerificationSuccessPageState();
}

class _VerificationSuccessPageState extends State<VerificationSuccessPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Setup animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Setup scale animation
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    // Start animation
    _animationController.forward();

    // Set up auto redirect after 3 seconds
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) {
        // Navigate to NewListingPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const NewListingPage(),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Success icon with animation
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEAF3DC),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 80,
                      color: Color(0xFF4E6645),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            // Success message
            const Text(
              "Verification Success",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4E6645),
              ),
            ),
            const SizedBox(height: 16),
            // Redirection message
            Text(
              "Redirecting...",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IDPhotoInstructionPage extends StatelessWidget {
  const IDPhotoInstructionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFEBF1E6),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(8),
            child: const Icon(Icons.arrow_back, color: Color(0xFF4D6447)),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Instruction',
          style: TextStyle(
            color: Color(0xFF4D6447),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Example picture area
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFEBF1E6),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Column(
                children: [
                  // ID card and face icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4D6447),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.person, color: Colors.white, size: 24),
                            SizedBox(width: 4),
                            Icon(Icons.menu, color: Colors.white, size: 24),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: const BoxDecoration(
                              color: Color(0xFF4D6447),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: 100,
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color(0xFF4D6447),
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Example of the picture.',
              style: TextStyle(
                color: Color(0xFF4D6447),
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            // Instruction points
            instructionPoint(
              number: 1,
              text: 'ID card must be landscape and front faced.',
            ),
            const SizedBox(height: 16),
            instructionPoint(
              number: 2,
              text:
                  'Make sure all the ID card and your face are in one frame, and there is no part that is cutted.',
            ),
            const SizedBox(height: 16),
            instructionPoint(
              number: 3,
              text:
                  'The photo must be clear, enough lighting, and no light reflect on the photo that is obstructing the photo.',
            ),
            const SizedBox(height: 16),
            instructionPoint(
              number: 4,
              text: 'The photo must be real, no photocopy, and no edit.',
            ),
          ],
        ),
      ),
    );
  }

  Widget instructionPoint({required int number, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$number.',
          style: const TextStyle(
            color: Color(0xFF4D6447),
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF4D6447),
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}

// Terms and Conditions Page
class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header with logo and title
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  // Logo
                  Text(
                    'Loopit',
                    style: TextStyle(
                      color: Colors.green[800],
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Serif',
                    ),
                  ),
                  const Spacer(),
                  // Terms & Conditions title
                  Text(
                    'Terms & Conditions',
                    style: TextStyle(
                      color: Colors.green[400],
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Divider
            Divider(
              color: Colors.green[100],
              thickness: 1,
              height: 1,
            ),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome text
                    const Text(
                      'Welcome to Loopit! By accessing or using our platform, you agree to comply with these Terms and Conditions. Please read them carefully.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 1. Acceptance of Terms
                    const TermSection(
                      number: '1',
                      title: 'Acceptance of Terms',
                      content:
                          'By using Loopit ("the App"), You acknowledge and agree to these Terms and Conditions, along with our Privacy Policy. If you do not agree, please do not use the App.',
                    ),

                    // 2. Eligibility
                    const TermSection(
                      number: '2',
                      title: 'Eligibility',
                      content:
                          'Users must register with a valid email address. You must be at least 18 years old or have parental consent.',
                    ),

                    // 3. Use of the Platform
                    const TermSection(
                      number: '3',
                      title: 'Use of the Platform',
                      content:
                          'The App is strictly for buying and selling second-hand items within the campus area. Users must ensure that listings are accurate and lawful. Transactions must be conducted in-person within the designated campus area.',
                    ),

                    // 4. Prohibited Activities
                    const TermSection(
                      number: '4',
                      title: 'Prohibited Activities',
                      content:
                          ', you agree not to:\nList prohibited items (illegal goods, weapons, counterfeit products, hazardous materials, etc.). Engage in fraud, harassment, or any illegal activities. Misuse the platform in any way.',
                    ),

                    // 5. Transactions and Payments
                    const TermSection(
                      number: '5',
                      title: 'Transactions and Payments',
                      content:
                          'The App acts as a marketplace and does not process payments or guarantee transactions. Buyers and sellers are responsible for arranging payments and exchanges. The App is not liable for any disputes or issues arising from transactions.',
                    ),

                    // 6. Content and Intellectual Property
                    const TermSection(
                      number: '6',
                      title: 'Content and Intellectual Property',
                      content:
                          'Users retain ownership of their content but grant the App a license to display listings. The App reserves the right to remove any content that violates these Terms.',
                    ),

                    // 7. Liability Disclaimer
                    const TermSection(
                      number: '7',
                      title: 'Liability Disclaimer',
                      content:
                          'The App does not guarantee the quality, authenticity, or condition of listed items. Users assume all risks associated with transactions.',
                    ),

                    // 8. Account Suspension and Termination
                    const TermSection(
                      number: '8',
                      title: 'Account Suspension and Termination',
                      content:
                          'The App reserves the right to suspend or terminate accounts for violations of these Terms. Users may delete their accounts, but past transactions remain subject to these Terms.',
                    ),

                    // 9. Privacy and Data Protection
                    const TermSection(
                      number: '9',
                      title: 'Privacy and Data Protection',
                      content:
                          'User data is handled per our Privacy Policy. The App does not sell or distribute personal information without consent.',
                    ),

                    // 10. Modifications to Terms
                    const TermSection(
                      number: '10',
                      title: 'Modifications to Terms',
                      content:
                          'We may update these Terms at any time. Continued use of the App constitutes acceptance of any revisions.',
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Continue button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[400],
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 16,
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

class TermSection extends StatelessWidget {
  final String number;
  final String title;
  final String content;

  const TermSection({
    super.key,
    required this.number,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 15, color: Colors.black87),
              children: [
                TextSpan(
                  text: '$number. ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
