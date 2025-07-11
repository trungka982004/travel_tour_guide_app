import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gradient Header with Avatar
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1976D2), Color(0xFFE3F0FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundImage: AssetImage('assets/home/view1.png'),
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Alex Guest', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                    SizedBox(height: 6),
                    Text('Carmelina Member', style: TextStyle(color: Colors.white70, fontSize: 15)),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          // Stats
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _statCard('Stays', '5'),
                _statCard('Points', '1200'),
                _statCard('Favorites', '8'),
              ],
            ),
          ),
          SizedBox(height: 24),
          // Profile Actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text('Account', style: Theme.of(context).textTheme.titleLarge),
          ),
          SizedBox(height: 12),
          _profileAction(Icons.person, 'Edit Profile', () {}),
          _profileAction(Icons.lock, 'Change Password', () {}),
          _profileAction(Icons.logout, 'Logout', () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          }, color: Colors.red),
          SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text('About', style: Theme.of(context).textTheme.titleLarge),
          ),
          SizedBox(height: 12),
          _profileAction(Icons.info, 'About Carmelina Resort', () {}),
          SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF1976D2))),
        SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey[700], fontSize: 13)),
      ],
    );
  }

  Widget _profileAction(IconData icon, String label, VoidCallback onTap, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 2,
        child: ListTile(
          leading: Icon(icon, color: color ?? Color(0xFF1976D2)),
          title: Text(label, style: TextStyle(color: color ?? Colors.black)),
          onTap: onTap,
        ),
      ),
    );
  }
} 