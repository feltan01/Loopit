import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool muteAll = false;
  bool chats = false;
  bool smsEmail = false;
  bool fromLoopit = false;
  bool geolocation = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          children: [
            // Back button and title
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFE8F5E9),
                    ),
                    child: const Icon(Icons.arrow_back, color: Color(0xFF4A6741)),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A6741),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              'Push Notifications',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            _buildSwitchTile("Mute all notifications", muteAll, (val) {
              setState(() => muteAll = val);
            }),

            const Divider(),

            _buildSwitchTile("Chats/DM", chats, (val) {
              setState(() => chats = val);
            }),

            _buildSwitchTile("SMS/Email", smsEmail, (val) {
              setState(() => smsEmail = val);
            }),

            _buildSwitchTile("From  Loopit", fromLoopit, (val) {
              setState(() => fromLoopit = val);
            }),

            const SizedBox(height: 30),

            Row(
              children: const [
                Icon(Icons.lock, color: Color(0xFF4A6741), size: 20),
                SizedBox(width: 8),
                Text(
                  'Privacy Settings',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF4A6741),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            _buildSwitchTile("Geolocation", geolocation, (val) {
              setState(() => geolocation = val);
            }),

            const SizedBox(height: 30),

            _buildSimpleItem("Clear search history"),
            const Divider(height: 1),

            _buildSimpleItem("Change Password"),
            const Divider(height: 1),

            _buildSimpleItem("Report trouble / help"),
            const Divider(height: 1),

            _buildSimpleItem("Shop Shipping Settings"),
            const Divider(height: 1),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(title, style: const TextStyle(fontSize: 16))),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF4A6741),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleItem(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
