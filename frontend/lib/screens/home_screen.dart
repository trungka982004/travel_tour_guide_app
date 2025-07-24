import 'package:flutter/material.dart';
import 'activities_screen.dart';
import 'excursions_screen.dart';
import 'restaurant_screen.dart';
import 'services_screen.dart';
import 'booking_screen.dart';
import 'settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/user_db_helper.dart';
import '../models/user.dart';
import 'dart:io';

class HomeScreen extends StatefulWidget {
  final void Function(int)? onTabChange;
  const HomeScreen({Key? key, this.onTabChange}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  String? _userName;
  String? _avatarPath;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 8),
      vsync: this,
    )..repeat();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('userEmail');
    if (email != null) {
      final user = await UserDbHelper().getUserByEmail(email);
      setState(() {
        _userName = user?.fullName ?? '';
        _avatarPath = user?.avatarPath;
      });
    }
  }

  void _onAvatarChanged() {
    _loadUserInfo();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: Text(
                'Welcome${_userName != null && _userName!.isNotEmpty ? ' ' + _userName! : ''}',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            CircleAvatar(
              backgroundColor: Color(0xFF0288D1),
              radius: 20,
              backgroundImage: _avatarPath != null && _avatarPath!.isNotEmpty
                  ? FileImage(File(_avatarPath!))
                  : AssetImage('assets/home/view1.png') as ImageProvider,
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0288D1), Color(0xFF00ACC1)],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2)],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Banner with image background
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/home/view1.png'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.4),
                      BlendMode.darken,
                    ),
                  ),
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF0288D1).withOpacity(0.3),
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
                      colors: [
                        Color(0xFF01579B).withOpacity(0.5),
                        Colors.transparent,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: Color(0xFFF5F6F5).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Ready to Explore',
                        style: TextStyle(
                          color: Color(0xFFF5F6F5),
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.2,
                          shadows: [
                            Shadow(
                              color: Color(0xFF0288D1).withOpacity(0.5),
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
                          color: Color(0xFFF5F6F5),
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          shadows: [
                            Shadow(
                              color: Color(0xFF0288D1).withOpacity(0.5),
                              offset: Offset(1, 1),
                              blurRadius: 3,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color(0xFFD1E8F1),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF0288D1).withOpacity(0.2),
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Find beaches, food, adventures...',
                            hintStyle: TextStyle(
                              color: Color(0xFF01579B),
                              fontSize: 14,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Color(0xFF01579B),
                              size: 20,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            filled: true,
                            fillColor: Color(0xFFD1E8F1),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 16,
                            ),
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
                  'Top Ocean Events',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: Color(0xFF01579B), fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 12),
              Container(
                height: 200,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _insightInfoCard(
                      title: 'Weather',
                      icon: Icons.wb_sunny,
                      subtitle: '# Sunny, 28°C',
                      bannerColor: Color(0xFFBBDEFB),
                    ),
                    _eventInsightCard(
                      title: 'Beach Party Tonight!',
                      imageAsset: 'assets/home/beach.png',
                      location: 'Coral Beach',
                      startTime: DateTime.now().add(Duration(hours: 2)),
                    ),
                    _insightInfoCard(
                      title: 'Seafood Dining',
                      imageAsset: 'assets/home/dining.png',
                      subtitle: 'Fresh Catch Buffet',
                      location: 'Ocean Breeze Restaurant',
                      time: '18:00 - 21:00',
                    ),
                    _insightInfoCard(
                      title: 'Spa by the Sea',
                      imageAsset: 'assets/home/spa.png',
                      subtitle: '15% Off Coastal Massage',
                      location: 'Seaside Spa',
                      time: '09:00 - 20:00',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              // Ocean Adventures Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Ocean Adventures',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: Color(0xFF01579B), fontWeight: FontWeight.bold),
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
                    _categoryIcon(
                      context,
                      Icons.directions_run,
                      'Activities',
                      ActivitiesScreen(),
                      iconSize: 24,
                      textSize: 12,
                      containerPadding: 8,
                    ),
                    _categoryIcon(
                      context,
                      Icons.kayaking,
                      'Excursions',
                      ExcursionsScreen(),
                      iconSize: 24,
                      textSize: 12,
                      containerPadding: 8,
                    ),
                    _categoryIcon(
                      context,
                      Icons.restaurant,
                      'Dining',
                      RestaurantScreen(),
                      iconSize: 24,
                      textSize: 12,
                      containerPadding: 8,
                    ),
                    _categoryIcon(
                      context,
                      Icons.room_service,
                      'Services',
                      ServicesScreen(),
                      iconSize: 24,
                      textSize: 12,
                      containerPadding: 8,
                    ),
                    _categoryIcon(
                      context,
                      Icons.book_online,
                      'Bookings',
                      null,
                      tabIndex: 2,
                      iconSize: 24,
                      textSize: 12,
                      containerPadding: 8,
                    ),
                    _categoryIcon(
                      context,
                      Icons.person,
                      'Profile',
                      null,
                      tabIndex: 3,
                      iconSize: 24,
                      textSize: 12,
                      containerPadding: 8,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              // Top Coastal Destinations
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Top Coastal Destinations',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: Color(0xFF01579B), fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 16),
              Container(
                height: 220,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _localCard(
                      'Water Sports',
                      'Dive into thrilling ocean adventures.',
                      'assets/home/sport.png',
                    ),
                    _localCard(
                      'Sunset Ceremony',
                      'Sail under the vibrant coastal sunset.',
                      'assets/home/ceremony.png',
                    ),
                    _localCard(
                      'Seafood Dining',
                      'Savor fresh ocean delicacies.',
                      'assets/home/restaurant.png',
                    ),
                    _localCard(
                      'Beachfront Relax',
                      'Unwind by the turquoise waves.',
                      'assets/home/pool.png',
                    ),
                    _localCard(
                      'Coral Reef Tour',
                      'Explore vibrant underwater ecosystems.',
                      'assets/home/beach.png',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
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
        color: Color(0xFFD1E8F1),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF0288D1).withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(color: Color(0xFF0288D1).withOpacity(0.2), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
                child: Icon(icon, color: Color(0xFF01579B), size: 36),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF01579B),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: TextStyle(color: Color(0xFF455A64), fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                if (location != null) ...[
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.place, color: Color(0xFF90A4AE), size: 15),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location,
                          style: TextStyle(
                            color: Color(0xFF455A64),
                            fontSize: 12,
                          ),
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
                      Icon(
                        Icons.access_time,
                        color: Color(0xFF90A4AE),
                        size: 15,
                      ),
                      SizedBox(width: 4),
                      Text(
                        time,
                        style: TextStyle(
                          color: Color(0xFF455A64),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
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
      countdown =
          '${hours > 0 ? '$hours h ' : ''}${minutes.toString().padLeft(2, '0')} min left';
    }
    return Container(
      width: 200,
      margin: EdgeInsets.only(right: 16),
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: Color(0xFFD1E8F1),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF0288D1).withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(color: Color(0xFF0288D1).withOpacity(0.2), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.event, color: Color(0xFF01579B), size: 20),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF01579B),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.place, color: Color(0xFF90A4AE), size: 16),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        location,
                        style: TextStyle(
                          color: Color(0xFF455A64),
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.access_time, color: Color(0xFF90A4AE), size: 16),
                    SizedBox(width: 4),
                    Text(
                      '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(color: Color(0xFF455A64), fontSize: 13),
                    ),
                    if (countdown.isNotEmpty) ...[
                      SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFF80DEEA).withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          countdown,
                          style: TextStyle(
                            color: Color(0xFF01579B),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
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
        color: Color(0xFFD1E8F1),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Color(0xFF0288D1).withOpacity(0.2), blurRadius: 6),
        ],
        image: DecorationImage(
          image: AssetImage(imageAsset),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.25),
            BlendMode.darken,
          ),
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [Color(0xFF01579B).withOpacity(0.1), Colors.transparent],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Color(0xFFF5F6F5),
                fontWeight: FontWeight.bold,
                fontSize: 18,
                shadows: [
                  Shadow(
                    color: Color(0xFF0288D1).withOpacity(0.5),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
            SizedBox(height: 6),
            Text(
              desc,
              style: TextStyle(
                color: Color(0xFFF5F6F5),
                fontSize: 13,
                shadows: [
                  Shadow(
                    color: Color(0xFF0288D1).withOpacity(0.5),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoryIcon(
    BuildContext context,
    IconData icon,
    String label,
    Widget? screen, {
    int? tabIndex,
    double iconSize = 32,
    double textSize = 11,
    double containerPadding = 10,
  }) {
    return GestureDetector(
      onTap: () {
        if (tabIndex != null && widget.onTabChange != null) {
          widget.onTabChange!(tabIndex);
        } else if (screen != null) {
          if (label == 'Profile') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    SettingsScreen(onAvatarChanged: _onAvatarChanged),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => screen),
            );
          }
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF80DEEA).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xFF80DEEA).withOpacity(0.5), width: 1),
            ),
            padding: EdgeInsets.all(containerPadding),
            child: Icon(icon, color: Color(0xFF01579B), size: iconSize),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: textSize,
              fontWeight: FontWeight.w500,
              color: Color(0xFF01579B),
            ),
          ),
        ],
      ),
    );
  }
}