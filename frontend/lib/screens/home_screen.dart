import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Banner
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ready to Explore',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Carmelina Resort!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 24),
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Find places, food, tips... ',
                      prefixIcon: Icon(Icons.search, color: Color(0xFF1976D2)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          // AI Insights Today
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'AI Insights Today',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          SizedBox(height: 12),
          Container(
            height: 110,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              children: [
                _insightCard('Weather', Icons.wb_sunny, '# Sunny, 28°C'),
                _insightCard('Events', Icons.event, 'Pool Party Tonight!'),
                _insightCard('Dining', Icons.restaurant, 'Seafood Buffet'),
                _insightCard('Spa', Icons.spa, '10% Off Today'),
              ],
            ),
          ),
          SizedBox(height: 24),
          // Locals by AI
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Locals by AI',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          SizedBox(height: 12),
          Container(
            height: 180,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              children: [
                _localCard('Beach Yoga', 'Start your day with sunrise yoga on the sand.', 'assets/home/view1.png'),
                _localCard('Sunset BBQ', 'Enjoy a BBQ with live music by the pool.', 'assets/home/view2.jpg'),
                _localCard('Kids Club', 'Fun activities for children all day.', 'assets/home/view3.jpg'),
                _localCard('Romantic Dinner', 'Private dining on the beach for couples.', 'assets/home/view4.png'),
              ],
            ),
          ),
          SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _insightCard(String title, IconData icon, String subtitle) {
    return Container(
      width: 140,
      margin: EdgeInsets.only(right: 16),
      padding: EdgeInsets.all(12), // reduced padding
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // center content vertically
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Color(0xFF1976D2), size: 28), // reduced icon size
          SizedBox(height: 8), // reduced spacing
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)), // slightly smaller font
          SizedBox(height: 2), // reduced spacing
          Flexible(child: Text(subtitle, style: TextStyle(color: Colors.grey[700], fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  Widget _localCard(String title, String desc, String imageAsset) {
    return Container(
      width: 180,
      margin: EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
        image: DecorationImage(
          image: AssetImage(imageAsset),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.15), BlendMode.darken),
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [Colors.black.withOpacity(0.05), Colors.transparent],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18, shadows: [Shadow(color: Colors.black26, blurRadius: 4)])),
            SizedBox(height: 6),
            Text(desc, style: TextStyle(color: Colors.white, fontSize: 13, shadows: [Shadow(color: Colors.black26, blurRadius: 4)])),
          ],
        ),
      ),
    );
  }
} 