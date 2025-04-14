import 'package:flutter/material.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with time and status icons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '9:41',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.signal_cellular_4_bar, size: 16),
                      SizedBox(width: 4),
                      Icon(Icons.wifi, size: 16),
                      SizedBox(width: 4),
                      Icon(Icons.battery_full, size: 16),
                    ],
                  ),
                ],
              ),
            ),
            
            // Back button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(0xFFE8F5E9),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.green),
                    onPressed: () {},
                    iconSize: 20,
                  ),
                ),
              ),
            ),
            
            // Profile section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile image
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage('assets/profile_picture.jpg'),
                      ),
                      
                      SizedBox(height: 12),
                      
                      // Username and rating
                      Text(
                        'User 2',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF4D5648),
                        ),
                      ),
                      
                      SizedBox(height: 4),
                      
                      // Rating stars
                      Row(
                        children: List.generate(
                          5,
                          (index) => Icon(
                            Icons.star_border,
                            size: 16,
                            color: Colors.grey[400],
                          ),
                        ),
                      ),
                      
                      SizedBox(height: 8),
                      
                      // Description
                      Text(
                        'No description.',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      
                      SizedBox(height: 12),
                      
                      // Location
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Color(0xFF4D5648),
                            size: 18,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Location has not been set by user.',
                            style: TextStyle(
                              color: Color(0xFF4D5648),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  // Edit profile button
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Edit profile',
                      style: TextStyle(
                        color: Color(0xFF4D5648),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 20),
            
            // Divider
            Divider(
              color: Colors.grey[300],
              thickness: 1,
            ),
            
            // Empty state
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Box icon with exclamation
                    Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 80,
                          color: Color(0xFFD8E2D5),
                        ),
                        Positioned(
                          top: -10,
                          child: Container(
                            height: 20,
                            width: 4,
                            child: Icon(
                              Icons.minimize,
                              size: 16,
                              color: Color(0xFFD8E2D5),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 16),
                    
                    // Empty state text
                    Text(
                      'You currently have nothing for sale',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}