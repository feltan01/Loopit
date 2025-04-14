import 'package:flutter/material.dart';
import 'package:loopit/screens/home_page.dart';
import 'package:loopit/screens/seller_verification.dart';
import 'package:loopit/screens/wallet.dart'; // Add this import for the wallet screen
import 'package:loopit/screens/my_profile.dart'; // Add import for the MyProfileScreen

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _buildBottomNav(context),
      body: SafeArea(
        child: Column(
          children: [
            _buildProfileHeader(),
            SizedBox(height: 20),
            _buildItemsSection(),
            SizedBox(height: 20),
            _buildMenuList(context), // Pass context to the menu list
          ],
        ),
      ),
    );
  }
  
  /// Header Profil
  Widget _buildProfileHeader() {
    return Column(
      children: [
        SizedBox(height: 20),
        CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(
            'https://i.imgur.com/your-image-url.jpg'), // Ganti dengan URL gambar profil
        ),
        SizedBox(height: 10),
        Text(
          "User",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[800]),
        ),
      ],
    );
  }
  
  /// Bagian "Your Items"
  Widget _buildItemsSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Your Items",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[800]),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildItemCard("Items on Sell", "0", "Your preloved items still available for sale."),
              _buildItemCard("Items sold", "0", "Preloved items, sold and gone!"),
            ],
          ),
        ],
      ),
    );
  }
  
  /// Kartu "Items on Sell" & "Items Sold"
  Widget _buildItemCard(String title, String count, String description) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Color(0xFFFFF5EE),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green[800]),
            ),
            SizedBox(height: 5),
            Text(
              count,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green[800]),
            ),
            SizedBox(height: 5),
            Text(
              description,
              style: TextStyle(fontSize: 12, color: Colors.green[700]),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.green[700]),
            ),
          ],
        ),
      ),
    );
  }
  
  /// List Menu Profil
  Widget _buildMenuList(BuildContext context) {
    return Column(
      children: [
        _buildMenuItem(Icons.person, "My Profile", () {
          // Navigate to the MyProfileScreen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyProfileScreen()),
          );
        }),
        _buildMenuItem(Icons.account_balance_wallet, "My Balance", () {
          // Navigate to the Wallet/Balance page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const WalletBalanceScreen()),
          );
        }),
        _buildMenuItem(Icons.settings, "Settings", () {}),
        _buildMenuItem(Icons.info, "About App", () {}),
        _buildMenuItem(Icons.logout, "LogOut", () {}),
      ],
    );
  }
  
  /// Item Menu
  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.green[800]),
      title: Text(title, style: TextStyle(color: Colors.green[800])),
      onTap: onTap,
    );
  }
  
  /// Bottom Navigation Bar
  Widget _buildBottomNav(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFFFFF5EE),
      selectedItemColor: const Color(0xFF4A6741),
      unselectedItemColor: Colors.grey,
      currentIndex: 2, // Set to 2 since this is the profile page
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        if (index == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else if (index == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SellerVerificationPage()),
          );
        } else if (index == 2) {
          // No need to navigate - already on ProfilePage
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline), // Navigasi ke SellerVerificationPage
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: '',
        ),
      ],
    );
  }
}