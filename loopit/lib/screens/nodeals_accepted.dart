import 'package:flutter/material.dart';

void main() {
  runApp(const nodeals());
}

class nodeals extends StatelessWidget {
  const nodeals({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const NoDealsPage(),
    );
  }
}

class NoDealsPage extends StatelessWidget {
  const NoDealsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFEDF5ED), // Light green background
                shape: BoxShape.circle,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Exclamation mark stem
                  Container(
                    width: 20,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFF5A715A), // Dark green color
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  // Exclamation mark dot
                  Positioned(
                    bottom: 20,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Color(0xFF5A715A), // Dark green color
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "No deals has been accepted",
              style: TextStyle(
                color: Color(0xFF5A715A), // Dark green text
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}