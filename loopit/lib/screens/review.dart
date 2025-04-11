import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loopit/screens/review_complete.dart';

void main() {
  runApp(const RatingApp());
}

class RatingApp extends StatelessWidget {
  const RatingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rating Screen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4D6A56),
          primary: const Color(0xFF4D6A56),
        ),
        useMaterial3: true,
      ),
      home: const RatingScreen(),
    );
  }
}

class RatingScreen extends StatefulWidget {
  const RatingScreen({Key? key}) : super(key: key);

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  int _rating = 0; // Default to 5 stars
  final TextEditingController _reviewController = TextEditingController();
  File? _proofImage;
  final ImagePicker _picker = ImagePicker();
  
  // Pre-fill review text as shown in the design


  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _proofImage = File(image.path);
      });
    }
  }

  void _submitReview() {
    // Here you would normally send the review to your backend
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Review submitted successfully!'),
        backgroundColor: Color(0xFF4D6A56),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: const Color(0xFFE9F1E7),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF4D6A56)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        title: const Text(
          'Rating',
          style: TextStyle(
            color: Color(0xFF4D6A56),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9F2ED),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/images/cream_jacket.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(
                              child: Text(
                                'Jacket Cream color Brand ABC',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4D6A56),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.more_vert,
                                color: Color(0xFF4D6A56),
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Text(
                              'Rp 140.000',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4D6A56),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE9F1E7),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'Deal Done',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF4D6A56),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Rate your experience',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4D6A56),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: const AssetImage('assets/user1.png'),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'User 1',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF4D6A56),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < _rating ? Icons.star : Icons.star_border,
                          color: const Color(0xFF4D6A56),
                          size: 40,
                        ),
                        onPressed: () {
                          setState(() {
                            _rating = index + 1;
                          });
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Leave a review',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4D6A56),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9F1E7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: _reviewController,
                      maxLines: 6,
                      decoration: const InputDecoration.collapsed(
                        hintText: 'Write your review here...',
                        hintStyle: TextStyle(
                          color: Color(0xFF4D6A56),
                          fontSize: 16,
                        ),
                      ),
                      style: const TextStyle(
                        color: Color(0xFF4D6A56),
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Order info',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4D6A56),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Expanded(
                        flex: 2,
                        child: Text(
                          'Payment Method',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF4D6A56),
                          ),
                        ),
                      ),
                      const Expanded(
                        flex: 3,
                        child: Text(
                          'BCA Virtual Account',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF4D6A56),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE9F1E7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _proofImage == null ? Icons.image : Icons.check_circle,
                            color: const Color(0xFF4D6A56),
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Proof of delivery',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF4D6A56),
                            ),
                          ),
                          if (_proofImage != null) ...[
                            const SizedBox(width: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.file(
                                _proofImage!,
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Expanded(
                        flex: 2,
                        child: Text(
                          'Order Number',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF4D6A56),
                          ),
                        ),
                      ),
                      const Expanded(
                        flex: 3,
                        child: Text(
                          '00000001',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF4D6A56),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(height: 1, color: Color(0xFFEEEEEE)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        Icons.warning_amber_outlined,
                        color: const Color(0xFF4D6A56),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Products/Transaction trouble?',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF4D6A56),
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          // Navigate to report screen
                        },
                        child: const Text(
                          'Report',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4D6A56),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                 const SizedBox(height: 40),
SizedBox(
  width: double.infinity,
  height: 50,
  child: ElevatedButton(
    onPressed: () {
      // Submit review data and navigate to confirmation page
      _submitReview();
      
      // Navigate to a new page
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MyApp(),
        ),
      );
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFE9F1E7),
      foregroundColor: const Color(0xFF4D6A56),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      elevation: 0,
    ),
    child: const Text(
      'Submit',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),
  ),
),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}