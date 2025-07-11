import 'package:flutter/material.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showProfile;
  final bool showSearch;
  final ValueChanged<String>? onSearch;

  Header({
    required this.title,
    this.showProfile = true,
    this.showSearch = false,
    this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        title,
        style: TextStyle(
          color: Color(0xFF1976D2),
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      centerTitle: true,
      actions: showProfile
          ? [
              IconButton(
                icon: Icon(Icons.person, color: Color(0xFF1976D2)),
                onPressed: () => Navigator.pushNamed(context, '/settings'),
              ),
            ]
          : null,
      bottom: showSearch
          ? PreferredSize(
              preferredSize: Size.fromHeight(56),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  onChanged: onSearch,
                  decoration: InputDecoration(
                    hintText: 'Tìm dịch vụ...',
                    prefixIcon: Icon(Icons.search, color: Color(0xFF1976D2)),
                    filled: true,
                    fillColor: Color(0xFFF5F7FA),
                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(showSearch ? 104 : 56);
} 