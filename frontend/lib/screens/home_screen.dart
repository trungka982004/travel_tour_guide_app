import 'package:flutter/material.dart';
import 'activities_screen.dart';
import 'excursions_screen.dart';
import 'restaurant_screen.dart';
import 'services_screen.dart';
import 'booking_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  final void Function(int)? onTabChange;
  const HomeScreen({Key? key, this.onTabChange}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 8),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Banner with image background and all corners rounded
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/home/view1.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken),
              ),
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withOpacity(0.5), Colors.transparent],
                ),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Ready to Explore',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.2,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(1, 1),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Carmelina Resort!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(1, 1),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  // Search Bar
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Find places, food, tips... ',
                        hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
                        prefixIcon: Icon(Icons.search, color: Color(0xFF1976D2), size: 20),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24),
          // Top Event
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Top Event',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          SizedBox(height: 12),
          Container(
            height: 170,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              children: [
                _insightInfoCard(
                  title: 'Weather',
                  icon: Icons.wb_sunny,
                  subtitle: '# Sunny, 28°C',
                  bannerColor: Colors.yellow[100]!,
                ),
                _eventInsightCard(
                  title: 'Pool Party Tonight!',
                  imageAsset: 'assets/home/pool.png',
                  location: 'Main Pool',
                  startTime: DateTime.now().add(Duration(hours: 2)),
                ),
                _insightInfoCard(
                  title: 'Dining',
                  imageAsset: 'assets/home/dining.png',
                  subtitle: 'Seafood Buffet',
                  location: 'Blue Sea Restaurant',
                  time: '18:00 - 21:00',
                ),
                _insightInfoCard(
                  title: 'Spa',
                  imageAsset: 'assets/home/spa.png',
                  subtitle: '10% Off Today',
                  location: 'Lotus Spa',
                  time: '09:00 - 20:00',
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          // Categories Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Categories',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1.2,
              children: [
                _categoryIcon(context, Icons.directions_run, 'Activities', ActivitiesScreen(), iconSize: 24, textSize: 12, containerPadding: 8),
                _categoryIcon(context, Icons.nature_people, 'Excursions', ExcursionsScreen(), iconSize: 24, textSize: 12, containerPadding: 8),
                _categoryIcon(context, Icons.restaurant, 'Restaurant', RestaurantScreen(), iconSize: 24, textSize: 12, containerPadding: 8),
                _categoryIcon(context, Icons.room_service, 'Services', ServicesScreen(), iconSize: 24, textSize: 12, containerPadding: 8),
                _categoryIcon(context, Icons.book_online, 'Bookings', null, tabIndex: 2, iconSize: 24, textSize: 12, containerPadding: 8),
                _categoryIcon(context, Icons.person, 'Profile', null, tabIndex: 3, iconSize: 24, textSize: 12, containerPadding: 8),
              ],
            ),
          ),
          SizedBox(height: 24),
          // Locals by AI
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Top destinations',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          SizedBox(height: 16),
          Container(
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              children: [
                _localCard('Sports', 'Join a game or try a new water sport.', 'assets/home/sport.png'),
                _localCard('Ceremony Night', 'Experience local traditions and performances.', 'assets/home/ceremony.png'),
                _localCard('Resort Dining', 'Taste signature dishes at our main restaurant.', 'assets/home/restaurant.png'),
                _localCard('Pool Relax', 'Unwind by the pool with a cool drink.', 'assets/home/pool.png'),
                _localCard('Sunny Beach', 'Enjoy the sun and sand at our private beach.', 'assets/home/beach.png'),
              ],
            ),
          ),
          SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _insightInfoCard({
    required String title,
    String? imageAsset,
    IconData? icon,
    String? subtitle,
    Color? bannerColor,
    String? location,
    String? time,
  }) {
    return Container(
      width: 200,
      margin: EdgeInsets.only(right: 16),
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
        border: Border.all(color: Color(0xFF1976D2).withOpacity(0.12), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageAsset != null)
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              child: Image.asset(
                imageAsset,
                height: 65,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            )
          else if (icon != null && bannerColor != null)
            Container(
              height: 65,
              width: double.infinity,
              decoration: BoxDecoration(
                color: bannerColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Center(
                child: Icon(icon, color: Color(0xFF1976D2), size: 36),
              ),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1976D2)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6),
                  if (subtitle != null)
                    Flexible(
                      child: Text(
                        subtitle,
                        style: TextStyle(color: Colors.grey[700], fontSize: 13),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  if (location != null) ...[
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.place, color: Colors.grey[600], size: 15),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            location,
                            style: TextStyle(color: Colors.grey[700], fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (time != null) ...[
                    SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.access_time, color: Colors.grey[600], size: 15),
                        SizedBox(width: 4),
                        Text(
                          time,
                          style: TextStyle(color: Colors.grey[700], fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _eventInsightCard({
    required String title,
    required String imageAsset,
    required String location,
    required DateTime startTime,
  }) {
    final now = DateTime.now();
    final duration = startTime.difference(now);
    String countdown = '';
    if (duration.inSeconds > 0) {
      final hours = duration.inHours;
      final minutes = duration.inMinutes % 60;
      countdown = '${hours > 0 ? '$hours h ' : ''}${minutes.toString().padLeft(2, '0')} min left';
    }
    return Container(
      width: 200,
      margin: EdgeInsets.only(right: 16),
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
        border: Border.all(color: Color(0xFF1976D2).withOpacity(0.12), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            child: Image.asset(
              imageAsset,
              height: 65,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.event, color: Color(0xFF1976D2), size: 20),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1976D2)),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.place, color: Colors.grey[600], size: 16),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location,
                          style: TextStyle(color: Colors.grey[700], fontSize: 13),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.grey[600], size: 16),
                      SizedBox(width: 4),
                      Text(
                        '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}',
                        style: TextStyle(color: Colors.grey[700], fontSize: 13),
                      ),
                      if (countdown.isNotEmpty) ...[
                        SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Color(0xFF1976D2).withOpacity(0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            countdown,
                            style: TextStyle(color: Color(0xFF1976D2), fontWeight: FontWeight.w600, fontSize: 12),
                          ),
                        ),
                      ]
                    ],
                  ),
                ],
              ),
            ),
          ),
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

  Widget _categoryIcon(BuildContext context, IconData icon, String label, Widget? screen, {int? tabIndex, double iconSize = 32, double textSize = 11, double containerPadding = 10}) {
    return GestureDetector(
      onTap: () {
        if (tabIndex != null && widget.onTabChange != null) {
          widget.onTabChange!(tabIndex);
        } else if (screen != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF1976D2).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.all(containerPadding),
            child: Icon(icon, color: Color(0xFF1976D2), size: iconSize),
          ),
          SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: textSize, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}