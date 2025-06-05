import 'package:flutter/material.dart';

class Profilepage extends StatelessWidget {
  const Profilepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.deepPurple,
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Column(
              children: const [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    'https://avatars.githubusercontent.com/u/583231?v=4',
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Code Slayer',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'slayer@example.com',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                _buildTile(Icons.person, 'Account Settings', () {}),
                _buildTile(Icons.shopping_bag, 'My Orders', () {}),
                _buildTile(Icons.favorite, 'Favorites', () {}),
                _buildTile(Icons.notifications, 'Notifications', () {}),
                _buildTile(Icons.security, 'Privacy & Security', () {}),
                _buildTile(Icons.help_outline, 'Help & Support', () {}),
                const Divider(),
                _buildTile(Icons.logout, 'Logout', () {
                  // Handle logout logic
                }, iconColor: Colors.red, textColor: Colors.red),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTile(
    IconData icon,
    String title,
    VoidCallback onTap, {
    Color iconColor = Colors.black54,
    Color textColor = Colors.black87,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: TextStyle(color: textColor)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
