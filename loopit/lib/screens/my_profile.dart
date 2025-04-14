import 'package:flutter/material.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top section with cream background
                  Container(
                    width: double.infinity,
                    color: Color(0xFFFAF7F2),
                    padding: EdgeInsets.only(top: 70, bottom: 20),
                    child: SizedBox(height: 50), // Space for back button that's positioned absolutely
                  ),
                  
                  // Profile content (white background)
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Profile image (positioned to overlap sections)
                          Transform.translate(
                            offset: Offset(0, -40),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                // Main content row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Left column with profile photo and info
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Profile image
                                        Container(
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.2),
                                                blurRadius: 4,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                            image: DecorationImage(
                                              image: AssetImage('assets/profile_picture.jpg'),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        
                                        SizedBox(height: 15),
                                        
                                        // Username and rating
                                        Row(
                                          children: [
                                            Text(
                                              'User 2',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFF5D6852),
                                              ),
                                            ),
                                            SizedBox(width: 12),
                                            Row(
                                              children: List.generate(
                                                5,
                                                (index) => Icon(
                                                  Icons.star_border,
                                                  size: 16,
                                                  color: Color(0xFFBDBDBD),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        
                                        SizedBox(height: 14),
                                        
                                        // Description
                                        Text(
                                          'No description.',
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 16,
                                          ),
                                        ),
                                        
                                        SizedBox(height: 14),
                                        
                                        // Location
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on,
                                              color: Color(0xFF5D6852),
                                              size: 18,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              'Location has not been set by user.',
                                              style: TextStyle(
                                                color: Color(0xFF5D6852),
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    
                                    // Edit profile button (positioned to the right)
                                    Positioned(
                                      right: 20,
                                      top: 0,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: Color(0xFFE8F5E9),
                                          borderRadius: BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.05),
                                              blurRadius: 2,
                                              offset: Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          'Edit profile',
                                          style: TextStyle(
                                            color: Color(0xFF5D6852),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                
                                // Edit profile button (positioned correctly)
                                Positioned(
                                  right: -120,
                                  top: 0,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFE8F5E9),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 2,
                                          offset: Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      'Edit profile',
                                      style: TextStyle(
                                        color: Color(0xFF5D6852),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          SizedBox(height: 24),
                          
                          // Divider
                          Container(
                            height: 1,
                            color: Color(0xFFE0E0E0),
                          ),
                          
                          // Empty state
                          Expanded(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Custom box with exclamation icon
                                  Stack(
                                    alignment: Alignment.topCenter,
                                    children: [
                                      SizedBox(
                                        width: 80,
                                        height: 80,
                                        child: CustomPaint(
                                          painter: BoxWithExclamationPainter(color: Color(0xFFCFD8C9)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  
                                  SizedBox(height: 20),
                                  
                                  // Empty state text
                                  Text(
                                    'You currently have nothing for sale',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              
              // Back button positioned in the top-left corner, independent of container padding
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(0xFFE8F5E9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.green[700],
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom painter for the box with exclamation icon
class BoxWithExclamationPainter extends CustomPainter {
  final Color color;
  
  BoxWithExclamationPainter({required this.color});
  
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    // Draw the box
    final double boxWidth = size.width * 0.8;
    final double boxHeight = size.height * 0.75;
    final double topOffset = size.height * 0.25;
    
    // Box bottom part
    final Path boxBottom = Path()
      ..moveTo(size.width * 0.15, size.height * 0.5)
      ..lineTo(size.width * 0.3, size.height * 0.85)
      ..lineTo(size.width * 0.7, size.height * 0.85)
      ..lineTo(size.width * 0.85, size.height * 0.5)
      ..close();
    
    // Box top part
    final Path boxTop = Path()
      ..moveTo(size.width * 0.15, size.height * 0.5)
      ..lineTo(size.width * 0.85, size.height * 0.5)
      ..lineTo(size.width * 0.65, size.height * 0.25)
      ..lineTo(size.width * 0.35, size.height * 0.25)
      ..close();
    
    // Draw the paths
    canvas.drawPath(boxBottom, paint);
    canvas.drawPath(boxTop, paint);
    
    // Draw the exclamation mark
    final Paint exclamationPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    // Dot of exclamation
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.1),
      size.width * 0.03,
      exclamationPaint
    );
    
    // Line of exclamation
    final Rect exclamationRect = Rect.fromLTWH(
      size.width * 0.48,
      size.height * -0.13,
      size.width * 0.04,
      size.height * 0.2
    );
    canvas.drawRect(exclamationRect, exclamationPaint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}