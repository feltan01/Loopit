import 'package:flutter/material.dart';
import 'package:loopit/screens/orderdetails_cod_seller.dart';
import 'orderdetails_cod_seller.dart';
import 'report_listingproblems.dart'; // Import the listing problems page
import 'report_chatspam.dart'; // Import the chat spam report page


class ReportProblemScreen extends StatelessWidget {
  const ReportProblemScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Custom light green color from the image
    final Color lightGreen = Color(0xFFADC9A1);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: lightGreen,
        title: Text('Report a problem'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const OrderdetailsCodSeller(), // Redirect to chat_buyer.dart
              ),
            );
          },
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: Text(
              'We will do our best to assist your issue as soon as\nyou are able to fill our report options',
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
          SizedBox(height: 1), // Small gap
          InkWell(
            onTap: () {
              // Navigate to the ReportListingproblems page when pressed
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ReportListingproblems()),
              );
            },
            child: _buildReportOption(
              icon: Icons.list_alt,
              text: 'Listing problems',
              color: lightGreen,
            ),
          ),
          SizedBox(height: 1), // Small gap
          InkWell(
            onTap: () {
              // Navigate to the ReportChatSpam page when pressed
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReportChatSpam()),
              );
            },
            child: _buildReportOption(
              icon: Icons.chat_bubble_outline,
              text: 'Chat spam/harassment',
              color: lightGreen,
            ),
          ),
          SizedBox(height: 1), // Small gap
          _buildReportOption(
            icon: Icons.chat,
            text: 'General feedback',
            color: lightGreen,
          ),
          SizedBox(height: 1), // Small gap
          _buildReportOption(
            icon: Icons.bug_report_outlined,
            text: 'Report of a bug',
            color: lightGreen,
          ),
        ],
      ),
    );
  }

  Widget _buildReportOption({
    required IconData icon,
    required String text,
    required Color color,
    bool isSelected = false,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      color: color,
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isSelected ? Colors.green[700] : Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey,
              size: 20,
            ),
          ),
          SizedBox(width: 16),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
