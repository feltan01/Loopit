import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loopit/screens/api_service.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  String? username;
  List<dynamic> myListings = [];

  @override
  void initState() {
    super.initState();
    fetchUsername();
    fetchMyListings();
  }

  Future<void> fetchUsername() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUsername = prefs.getString('username');
    setState(() {
      username = storedUsername ?? 'User';
    });
  }

  Future<void> fetchMyListings() async {
    try {
      final data = await ApiService.getMyListings();
      setState(() {
        myListings = data;
      });
    } catch (e) {
      print('Failed to fetch listings: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Header
                Container(
                  width: double.infinity,
                  color: const Color(0xFFFAF7F2),
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: const SizedBox(height: 50),
                ),

                // Profile Info
                // Profile Info
                Container(
                  transform: Matrix4.translationValues(0, -40, 0),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Profile image and user info
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 45,
                            backgroundImage:
                                AssetImage('assets/images/profile_picture.png'),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                username ?? 'User',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF5D6852),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: List.generate(
                                  5,
                                  (index) => const Icon(
                                    Icons.star_border,
                                    size: 16,
                                    color: Color(0xFFBDBDBD),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'No description.',
                                style: TextStyle(color: Colors.black54),
                              ),
                              const SizedBox(height: 10),
                              const Row(
                                children: [
                                  Icon(Icons.location_on,
                                      size: 16, color: Color(0xFF5D6852)),
                                  SizedBox(width: 4),
                                  Text(
                                    'Location has not been set by user.',
                                    style: TextStyle(
                                      color: Color(0xFF5D6852),
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Edit button
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(2, 2),
                            )
                          ],
                        ),
                        child: const Text(
                          'Edit profile',
                          style: TextStyle(
                            color: Color(0xFF5D6852),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),


                const Divider(thickness: 1),

                // Listings
                Expanded(
                  child: myListings.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 40),
                            SizedBox(
                              width: 80,
                              height: 80,
                              child: CustomPaint(
                                painter: BoxWithExclamationPainter(
                                    color: const Color(0xFFCFD8C9)),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'You currently have nothing for sale',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          itemCount: myListings.length,
                          itemBuilder: (context, index) {
                            final item = myListings[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 3,
                                shadowColor: Colors.grey.withOpacity(0.2),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    children: [
                                      // Image section
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          item['images'].isNotEmpty
                                              ? 'http://192.168.18.50:8000${item['images'][0]['image']}'
                                              : 'https://via.placeholder.com/100',
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Container(
                                              width: 80,
                                              height: 80,
                                              color: const Color.fromARGB(255, 247, 245, 245),
                                              child: const Icon(
                                                  Icons.image_not_supported),
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 12),

                                      // Details section
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item['title'],
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Color(0xFF4A6741),
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              item['description'],
                                              style: const TextStyle(
                                                color: Colors.black54,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Price
                                      Text(
                                        'Rp ${item['price']}',
                                        style: const TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },

                        ),
                ),
              ],
            ),

            // Back Button
            Positioned(
              top: 16,
              left: 16,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8F5E9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.arrow_back,
                      color: Colors.green[700], size: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BoxWithExclamationPainter extends CustomPainter {
  final Color color;
  BoxWithExclamationPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final Path boxBottom = Path()
      ..moveTo(size.width * 0.15, size.height * 0.5)
      ..lineTo(size.width * 0.3, size.height * 0.85)
      ..lineTo(size.width * 0.7, size.height * 0.85)
      ..lineTo(size.width * 0.85, size.height * 0.5)
      ..close();

    final Path boxTop = Path()
      ..moveTo(size.width * 0.15, size.height * 0.5)
      ..lineTo(size.width * 0.85, size.height * 0.5)
      ..lineTo(size.width * 0.65, size.height * 0.25)
      ..lineTo(size.width * 0.35, size.height * 0.25)
      ..close();

    canvas.drawPath(boxBottom, paint);
    canvas.drawPath(boxTop, paint);

    canvas.drawCircle(
        Offset(size.width * 0.5, size.height * 0.1), size.width * 0.03, paint);
    final Rect exclamationRect = Rect.fromLTWH(
      size.width * 0.48,
      size.height * -0.13,
      size.width * 0.04,
      size.height * 0.2,
    );
    canvas.drawRect(exclamationRect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
