import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ID Photo Instructions',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const IDPhotoInstructionPage(),
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
            // Handle back button press
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
