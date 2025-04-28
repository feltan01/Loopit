import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'review_complete.dart'; // <-- After submit, go to OrderCompletedScreen

class RatingScreen extends StatefulWidget {
  final String productName;
  final String productImageUrl;
  final String productPrice;

  const RatingScreen({
    Key? key,
    required this.productName,
    required this.productImageUrl,
    required this.productPrice,
  }) : super(key: key);

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  int _rating = 0;
  final TextEditingController _reviewController = TextEditingController();
  File? _proofImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _proofImage = File(image.path);
      });
    }
  }

  void _submitReview() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Review submitted successfully!'),
        backgroundColor: Color(0xFF4D6A56),
      ),
    );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MyApp()),
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
              onPressed: () => Navigator.pop(context),
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderSummary(),
            const Divider(height: 30),
            _buildRatingSection(),
            const Divider(height: 30),
            _buildReviewTextField(),
            const Divider(height: 30),
            _buildOrderInfo(),
            const Divider(height: 30),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Row(
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
            child: Image.network(
              widget.productImageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.productName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4D6A56),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    widget.productPrice,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4D6A56),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9F1E7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text('Deal Done',
                        style:
                            TextStyle(fontSize: 14, color: Color(0xFF4D6A56))),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRatingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Rate your experience',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4D6A56))),
        const SizedBox(height: 16),
        Row(
          children: [
            const CircleAvatar(
                radius: 24, backgroundImage: AssetImage('assets/user1.png')),
            const SizedBox(width: 16),
            const Text('User 1',
                style: TextStyle(fontSize: 16, color: Color(0xFF4D6A56))),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(5, (index) {
            return IconButton(
              icon: Icon(index < _rating ? Icons.star : Icons.star_border,
                  color: const Color(0xFF4D6A56), size: 40),
              onPressed: () {
                setState(() {
                  _rating = index + 1;
                });
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildReviewTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Leave a review',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4D6A56))),
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
                hintStyle: TextStyle(color: Color(0xFF4D6A56))),
            style: const TextStyle(color: Color(0xFF4D6A56)),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Order info',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4D6A56))),
        const SizedBox(height: 16),
        _buildInfoRow('Payment Method', 'BCA Virtual Account'),
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
                Icon(_proofImage == null ? Icons.image : Icons.check_circle,
                    color: const Color(0xFF4D6A56), size: 24),
                const SizedBox(width: 8),
                const Text('Proof of delivery',
                    style: TextStyle(fontSize: 16, color: Color(0xFF4D6A56))),
                if (_proofImage != null) ...[
                  const SizedBox(width: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.file(_proofImage!,
                        width: 40, height: 40, fit: BoxFit.cover),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildInfoRow('Order Number', '00000001'),
      ],
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Row(
      children: [
        Expanded(
            flex: 2,
            child: Text(title,
                style:
                    const TextStyle(fontSize: 16, color: Color(0xFF4D6A56)))),
        Expanded(
            flex: 3,
            child: Text(value,
                style:
                    const TextStyle(fontSize: 16, color: Color(0xFF4D6A56)))),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _submitReview,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE9F1E7),
          foregroundColor: const Color(0xFF4D6A56),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 0,
        ),
        child: const Text('Submit',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }
}