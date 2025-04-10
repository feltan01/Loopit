import 'package:flutter/material.dart';
import 'report.dart';
import 'report_alldone.dart'; // Import the confirmation page

void main() {
  runApp(const ReportGeneralfeedback());
}

class ReportGeneralfeedback extends StatelessWidget {
  const ReportGeneralfeedback({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const ReportOptionsPage(),
    );
  }
}

class ReportOptionsPage extends StatefulWidget {
  const ReportOptionsPage({Key? key}) : super(key: key);

  @override
  _ReportOptionsPageState createState() => _ReportOptionsPageState();
}

class _ReportOptionsPageState extends State<ReportOptionsPage> {
  final TextEditingController _detailsController = TextEditingController();

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // More accurate colors based on screenshot
    const Color appBarColor = Color(0xFFB1C9A4);
    const Color backgroundColor = Color.fromARGB(255, 255, 255, 255);
    const Color buttonColor = Color(0xFFB1C9A4);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const ReportProblemScreen(), // Redirect to chat_buyer.dart
              ),
            );
          },
        ),
        title: const Text(
          'Report options',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What happened? be sure to tell us in detail so we can assist you better.',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.withOpacity(0.3),
                      ),
                      child: const Icon(Icons.error_outline,
                          color: Colors.black54),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'General feedback',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _detailsController,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  hintText: "I think the app needs to add...",
                  hintStyle: TextStyle(color: Colors.black45),
                  contentPadding: EdgeInsets.all(16),
                  border: InputBorder.none,
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to the report_alldone.dart page when button is pressed
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AlldonePage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  foregroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  elevation: 2,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child:
                    const Text('Submit form', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
