import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/activities_screen.dart';
import 'screens/booking_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(ResortApp());
}

class ResortApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Carmelina Resort App',
      theme: ThemeData(
        fontFamily: 'Roboto',
        primaryColor: Color(0xFF1976D2),
        scaffoldBackgroundColor: Color(0xFFF5F7FA),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Color(0xFF1976D2),
          secondary: Color(0xFFF5F7FA),
        ),
        textTheme: TextTheme(
          titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1976D2)),
          bodyMedium: TextStyle(fontSize: 14),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            textStyle: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      home: ResortMainShell(),
    );
  }
}

class ResortMainShell extends StatefulWidget {
  @override
  State<ResortMainShell> createState() => _ResortMainShellState();
}

class _ResortMainShellState extends State<ResortMainShell> {
  int _selectedIndex = 0;
  final List<String> _titles = [
    'Home',
    'Explore',
    'Bookings',
    'Profile',
  ];

  void _onTabChange(int i) {
    setState(() {
      _selectedIndex = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(onTabChange: (i) => _onTabChange(i)),
      ActivitiesScreen(),
      BookingScreen(onBackToHome: (i) => _onTabChange(i)),
      SettingsScreen(),
    ];
    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE3F0FF), Colors.white],
          ),
        ),
        child: SafeArea(child: screens[_selectedIndex]),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (i) => setState(() => _selectedIndex = i),
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color(0xFF1976D2),
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.explore_rounded), label: 'Explore'),
            BottomNavigationBarItem(icon: Icon(Icons.book_online_rounded), label: 'Bookings'),
            BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
