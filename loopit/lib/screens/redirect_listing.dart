import 'package:flutter/material.dart';
import 'dart:async';

class RedirectingPage extends StatefulWidget {
  final Widget destinationPage;
  final int redirectDuration;

  const RedirectingPage({
    Key? key,
    required this.destinationPage,
    this.redirectDuration = 2000, // Default 2 seconds
  }) : super(key: key);

  @override
  _RedirectingPageState createState() => _RedirectingPageState();
}

class _RedirectingPageState extends State<RedirectingPage> {
  @override
  void initState() {
    super.initState();
    // Set timer to redirect after specified duration
    Timer(Duration(milliseconds: widget.redirectDuration), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => widget.destinationPage),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Loading text
            Text(
              'Redirecting to Listing',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF5F6B45), // Olive green color
              ),
            ),
            Text(
              'Page...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF5F6B45), // Olive green color
              ),
            ),
            // You could add a loading indicator here if desired
            // const SizedBox(height: 24),
            // CircularProgressIndicator(
            //   color: Color(0xFF5F6B45),
            // ),
          ],
        ),
      ),
    );
  }
}

// Example usage:
// To show this page and automatically redirect to the main listing page:
//
// Navigator.pushReplacement(
//   context,
//   MaterialPageRoute(
//     builder: (context) => RedirectingPage(
//       destinationPage: ListingMainPage(),
//       redirectDuration: 2000, // milliseconds
//     ),
//   ),
// );
