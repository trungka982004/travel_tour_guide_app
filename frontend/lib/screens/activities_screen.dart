import 'package:flutter/material.dart';

class ActivitiesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gradient Header with Search
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
                  Text('Explore New Vibes', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search by activity, place, tag...',
                        prefixIcon: Icon(Icons.search, color: Color(0xFF1976D2)),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _filterChip('Must-See', true),
                        _filterChip('Family', false),
                        _filterChip('Adventure', false),
                        _filterChip('Relax', false),
                        _filterChip('Romantic', false),
                        _filterChip('Wellness', false),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            // Must-See Today
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text('Must-See Today', style: Theme.of(context).textTheme.titleLarge),
            ),
            SizedBox(height: 12),
            Container(
              height: 180,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _activityCard('Kayak Adventure', 'Explore the lagoon by kayak.', 'assets/activites/beach/private_beach.png'),
                  _activityCard('Sunset Yoga', 'Evening yoga on the beach.', 'assets/activites/spa&finess/spa.jpg'),
                  _activityCard('Pool Party', 'Live DJ and games by the pool.', 'assets/activites/spa&finess/gym.jpg'),
                ],
              ),
            ),
            SizedBox(height: 24),
            // Hidden Gems
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text('Hidden Gems Nearby', style: Theme.of(context).textTheme.titleLarge),
            ),
            SizedBox(height: 12),
            Container(
              height: 180,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _activityCard('Secret Garden', 'A quiet spot for reading.', 'assets/activites/gardern/orchid_garden.jpg'),
                  _activityCard('Coconut Grove', 'Shady hammocks and swings.', 'assets/activites/kid_activities/outdoor_playground.png'),
                  _activityCard('Mini Golf', 'Fun for all ages.', 'assets/activites/sport/pickleball.jpg'),
                ],
              ),
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _filterChip(String label, bool selected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        selectedColor: Color(0xFF1976D2),
        labelStyle: TextStyle(color: selected ? Colors.white : Color(0xFF1976D2)),
        backgroundColor: Color(0xFFF5F7FA),
        onSelected: (_) {},
      ),
    );
  }

  Widget _activityCard(String title, String desc, String imageAsset) {
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