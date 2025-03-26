import 'package:flutter/material.dart';
import 'dart:async';
import 'your_listings.dart'; // Import YourListingPage

class ListingSuccessPage extends StatefulWidget {
  final Widget destinationPage;

  const ListingSuccessPage({
    Key? key, 
    required this.destinationPage,
  }) : super(key: key);

  @override
  _ListingSuccessPageState createState() => _ListingSuccessPageState();
}

class _ListingSuccessPageState extends State<ListingSuccessPage> {
  bool _showRedirectText = false;

  @override
  void initState() {
    super.initState();
    
    // First, show the success page
    Timer(const Duration(seconds: 1), () {
      // Then show the redirecting text
      setState(() {
        _showRedirectText = true;
      });
    });

    // Navigate to Your Listings page
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const YourListingPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _showRedirectText 
          ? const _RedirectingPage() 
          : const _SuccessPage(),
      ),
    );
  }

  // Optional: If you want to keep track of the original destination page
  Widget get originalDestinationPage => widget.destinationPage;
}

class _SuccessPage extends StatelessWidget {
  const _SuccessPage();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: const BoxDecoration(
            color: Color(0xFFE6F2E1),
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(
              Icons.check,
              size: 60,
              color: Color(0xFF4E6E39),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Listing Success',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Color(0xFF4E6E39),
          ),
        ),
      ],
    );
  }
}

class _RedirectingPage extends StatelessWidget {
  const _RedirectingPage();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text(
          'Redirecting to Listing',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF5F6B45),
          ),
        ),
        Text(
          'Page...',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF5F6B45),
          ),
        ),
      ],
    );
  }
}