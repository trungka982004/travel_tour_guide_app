import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/user_db_helper.dart';
import '../models/user.dart';
import 'login_screen.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../data/activity_db_helper.dart';
import '../models/activity_booking.dart';
import '../data/excursion_db_helper.dart';
import '../models/excursion_booking.dart';
import '../data/restaurant_order_db_helper.dart';
import '../models/restaurant_order.dart';
import '../data/service_order_db_helper.dart';
import '../models/service_order.dart';
import '../models/room_booking.dart';
import '../data/room_booking_db_helper.dart';
import '../models/activity.dart';
import '../models/excursion.dart';

class SettingsScreen extends StatefulWidget {
  final VoidCallback? onAvatarChanged;
  const SettingsScreen({Key? key, this.onAvatarChanged}) : super(key: key);
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  User? _user;
  bool _isLoading = true;
  bool _isEditingProfile = false;
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  bool _obscurePassword = true;
  bool _canEditPassword = false;
  String? _avatarPath;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('userEmail');
    if (email != null) {
      final user = await UserDbHelper().getUserByEmail(email);
      if (user != null) {
        setState(() {
          _user = user;
          _fullNameController.text = user.fullName;
          _usernameController.text = user.username;
          _phoneController.text = user.phone;
          _emailController.text = user.email;
          _passwordController.text = user.password;
          _dateOfBirthController.text = user.dateOfBirth;
          _avatarPath = user.avatarPath;
        });
      }
    }
    setState(() => _isLoading = false);
  }

  Future<void> _pickAvatar(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: source, imageQuality: 85);
      if (picked != null) {
        final appDir = await getApplicationDocumentsDirectory();
        final fileName = 'avatar_${_user?.id ?? DateTime.now().millisecondsSinceEpoch}.png';
        final saved = await File(picked.path).copy('${appDir.path}/$fileName');
        setState(() {
          _avatarPath = saved.path;
        });
        if (_user != null) {
          final updatedUser = User(
            id: _user!.id,
            fullName: _fullNameController.text.trim(),
            username: _usernameController.text.trim(),
            phone: _phoneController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
            dateOfBirth: _dateOfBirthController.text.trim(),
            avatarPath: saved.path,
          );
          await UserDbHelper().updateUser(updatedUser);
          setState(() {
            _user = updatedUser;
          });
          if (widget.onAvatarChanged != null) widget.onAvatarChanged!();
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to pick image: $e')));
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate() || _user == null) return;
    setState(() => _isLoading = true);
    final updatedUser = User(
      id: _user!.id,
      fullName: _fullNameController.text.trim(),
      username: _usernameController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      dateOfBirth: _dateOfBirthController.text.trim(),
      avatarPath: _avatarPath,
    );
    await UserDbHelper().updateUser(updatedUser);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userEmail', updatedUser.email);
    setState(() {
      _user = updatedUser;
      _isLoading = false;
      _isEditingProfile = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile updated successfully!')));
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(color: Colors.white)),
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
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 36,
                          backgroundImage: _avatarPath != null && _avatarPath!.isNotEmpty
                              ? FileImage(File(_avatarPath!))
                              : AssetImage('assets/home/view1.png') as ImageProvider,
                          backgroundColor: Color(0xFFD1E8F1),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                ),
                                builder: (context) => Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2)],
                                    ),
                                  ),
                                  child: SafeArea(
                                    child: Wrap(
                                      children: [
                                        ListTile(
                                          leading: Icon(Icons.camera_alt, color: Color(0xFF01579B)),
                                          title: Text('Take Photo', style: TextStyle(color: Color(0xFF01579B))),
                                          onTap: () {
                                            Navigator.pop(context);
                                            _pickAvatar(ImageSource.camera);
                                          },
                                        ),
                                        ListTile(
                                          leading: Icon(Icons.photo_library, color: Color(0xFF01579B)),
                                          title: Text('Choose from Gallery', style: TextStyle(color: Color(0xFF01579B))),
                                          onTap: () {
                                            Navigator.pop(context);
                                            _pickAvatar(ImageSource.gallery);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xFF80DEEA),
                                shape: BoxShape.circle,
                                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)],
                              ),
                              padding: EdgeInsets.all(4),
                              child: Icon(Icons.add, color: Colors.white, size: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    if (_usernameController.text.isNotEmpty)
                      Text(
                        _usernameController.text,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF01579B)),
                      ),
                    SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isEditingProfile = !_isEditingProfile;
                        });
                      },
                      child: Text('Edit Profile', style: TextStyle(color: Color(0xFF01579B), fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              if (_isEditingProfile) ...[
                SizedBox(height: 24),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _fullNameController,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          prefixIcon: Icon(Icons.person, color: Color(0xFF01579B)),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Color(0xFF80DEEA))),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Color(0xFF80DEEA))),
                        ),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          prefixIcon: Icon(Icons.account_circle, color: Color(0xFF01579B)),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Color(0xFF80DEEA))),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Color(0xFF80DEEA))),
                        ),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          prefixIcon: Icon(Icons.phone, color: Color(0xFF01579B)),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Color(0xFF80DEEA))),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Color(0xFF80DEEA))),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email, color: Color(0xFF01579B)),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Color(0xFF80DEEA))),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Color(0xFF80DEEA))),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Required';
                          final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                          if (!emailRegex.hasMatch(v.trim())) return 'Invalid email';
                          return null;
                        },
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: _passwordController,
                        readOnly: !_canEditPassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock, color: Color(0xFF01579B)),
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Color(0xFF01579B)),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Color(0xFF80DEEA))),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Color(0xFF80DEEA))),
                        ),
                        obscureText: _obscurePassword,
                        validator: (v) => v == null || v.length < 6 ? 'Min 6 characters' : null,
                        onTap: () async {
                          if (!_canEditPassword) {
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                title: Text('Change Password?', style: TextStyle(color: Color(0xFF01579B))),
                                content: Text('Changing your password will affect how you log in next time. Are you sure you want to continue?', style: TextStyle(color: Color(0xFF455A64))),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, false),
                                    child: Text('Cancel', style: TextStyle(color: Color(0xFF01579B))),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF80DEEA), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                                    onPressed: () => Navigator.pop(ctx, true),
                                    child: Text('Continue', style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              ),
                            );
                            if (confirmed == true) {
                              setState(() {
                                _canEditPassword = true;
                              });
                            }
                          }
                        },
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: _dateOfBirthController,
                        decoration: InputDecoration(
                          labelText: 'Date of Birth',
                          prefixIcon: Icon(Icons.cake, color: Color(0xFF01579B)),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Color(0xFF80DEEA))),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Color(0xFF80DEEA))),
                        ),
                        onTap: () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.tryParse(_dateOfBirthController.text) ?? DateTime(2000, 1, 1),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            _dateOfBirthController.text = picked.toIso8601String().split('T')[0];
                          }
                        },
                      ),
                      SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _saveProfile,
                              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF80DEEA), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                              child: _isLoading ? CircularProgressIndicator(color: Colors.white) : Text('Save Changes', style: TextStyle(color: Colors.white)),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  _isEditingProfile = false;
                                });
                              },
                              style: OutlinedButton.styleFrom(side: BorderSide(color: Color(0xFF80DEEA)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                              child: Text('Cancel', style: TextStyle(color: Color(0xFF01579B))),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
              SizedBox(height: 24),
              Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text('Appearance', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF01579B))),
              ),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 2,
                color: Color(0xFFD1E8F1),
                child: SwitchListTile(
                  value: false,
                  onChanged: null,
                  title: Text('Dark Mode', style: TextStyle(color: Color(0xFF01579B))),
                  secondary: Icon(Icons.dark_mode, color: Color(0xFF01579B)),
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text('Action History / Booking', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF01579B))),
              ),
              SizedBox(
                height: 400,
                child: DefaultTabController(
                  length: 5,
                  child: Column(
                    children: [
                      TabBar(
                        isScrollable: true,
                        labelColor: Color(0xFF01579B),
                        indicatorColor: Color(0xFF80DEEA),
                        tabs: [
                          Tab(text: 'Rooms'),
                          Tab(text: 'Activities'),
                          Tab(text: 'Excursions'),
                          Tab(text: 'Restaurant'),
                          Tab(text: 'Services'),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            _RoomBookingTab(),
                            _ActivityBookingTab(),
                            _ExcursionBookingTab(),
                            _RestaurantBookingTab(),
                            _ServiceBookingTab(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _profileAction(Icons.logout, 'Logout', () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isLoggedIn', false);
                await prefs.remove('userEmail');
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                  (route) => false,
                );
              }, color: Color(0xFFFF5722)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileAction(IconData icon, String label, VoidCallback onTap, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 2,
        color: Color(0xFFD1E8F1),
        child: ListTile(
          leading: Icon(icon, color: color ?? Color(0xFF01579B)),
          title: Text(label, style: TextStyle(color: color ?? Color(0xFF01579B))),
          onTap: onTap,
        ),
      ),
    );
  }
}

class _RoomBookingTab extends StatefulWidget {
  @override
  State<_RoomBookingTab> createState() => _RoomBookingTabState();
}

class _RoomBookingTabState extends State<_RoomBookingTab> {
  List<BookingOrder> _bookings = [];
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    _bookings = await RoomBookingDbHelper().getAllBookings();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_bookings.isEmpty) return Center(child: Text('No room bookings.', style: TextStyle(color: Color(0xFF455A64))));
    return ListView.builder(
      itemCount: _bookings.length,
      itemBuilder: (ctx, i) {
        final b = _bookings[i];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          color: Color(0xFFD1E8F1),
          child: ListTile(
            title: Text(b.roomName, style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF01579B))),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Check-in: ${b.checkIn.toString().split(" ")[0]}', style: TextStyle(color: Color(0xFF455A64))),
                Text('Check-out: ${b.checkOut.toString().split(" ")[0]}', style: TextStyle(color: Color(0xFF455A64))),
                Text('Guests: ${b.adults} adults, ${b.children} children', style: TextStyle(color: Color(0xFF455A64))),
                Text('Status: ${b.status}', style: TextStyle(color: Color(0xFF455A64))),
              ],
            ),
            onTap: () {
              showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
                builder: (ctx) => Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2)],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Room Booking Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF01579B))),
                        SizedBox(height: 8),
                        Text('Room: ${b.roomName}', style: TextStyle(color: Color(0xFF455A64))),
                        Text('Check-in: ${b.checkIn}', style: TextStyle(color: Color(0xFF455A64))),
                        Text('Check-out: ${b.checkOut}', style: TextStyle(color: Color(0xFF455A64))),
                        Text('Adults: ${b.adults}', style: TextStyle(color: Color(0xFF455A64))),
                        Text('Children: ${b.children}', style: TextStyle(color: Color(0xFF455A64))),
                        Text('Guest: ${b.guestName}', style: TextStyle(color: Color(0xFF455A64))),
                        Text('Status: ${b.status}', style: TextStyle(color: Color(0xFF455A64))),
                        Text('Booking ID: ${b.id}', style: TextStyle(color: Color(0xFF455A64))),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _ActivityBookingTab extends StatefulWidget {
  @override
  State<_ActivityBookingTab> createState() => _ActivityBookingTabState();
}

class _ActivityBookingTabState extends State<_ActivityBookingTab> {
  List<ActivityBooking> _bookings = [];
  Map<int, Activity> _activityMap = {};
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('userEmail');
    if (email != null) {
      final maps = await ActivityDbHelper().getBookingsByUser(email);
      _bookings = maps.map((e) => ActivityBooking.fromMap(e)).toList();
      final activities = await ActivityDbHelper().getAllActivities();
      _activityMap = {for (var a in activities) a.id!: a};
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_bookings.isEmpty) return Center(child: Text('No activity bookings.', style: TextStyle(color: Color(0xFF455A64))));
    return ListView.builder(
      itemCount: _bookings.length,
      itemBuilder: (ctx, i) {
        final b = _bookings[i];
        final activity = _activityMap[b.activityId];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          color: Color(0xFFD1E8F1),
          child: ListTile(
            leading: activity != null
                ? Image.asset(activity.image, width: 48, height: 48, fit: BoxFit.cover)
                : null,
            title: Text(activity?.name ?? 'Activity ${b.activityId}', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF01579B))),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Date: ${b.bookingDate}', style: TextStyle(color: Color(0xFF455A64))),
                Text('People: ${b.numberOfPeople}', style: TextStyle(color: Color(0xFF455A64))),
                Text('Status: ${b.status}', style: TextStyle(color: Color(0xFF455A64))),
              ],
            ),
            onTap: () {
              showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
                builder: (ctx) => Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2)],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Activity Booking Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF01579B))),
                        SizedBox(height: 8),
                        if (activity != null) ...[
                          Image.asset(activity.image, width: 80, height: 80, fit: BoxFit.cover),
                          SizedBox(height: 8),
                          Text('Activity: ${activity.name}', style: TextStyle(color: Color(0xFF455A64))),
                          Text('Category: ${activity.category}', style: TextStyle(color: Color(0xFF455A64))),
                          Text('Location: ${activity.location}', style: TextStyle(color: Color(0xFF455A64))),
                          Text('Time: ${activity.time}', style: TextStyle(color: Color(0xFF455A64))),
                          Text('Audience: ${activity.audience}', style: TextStyle(color: Color(0xFF455A64))),
                          Text('Description: ${activity.description}', style: TextStyle(color: Color(0xFF455A64))),
                        ],
                        Text('Date: ${b.bookingDate}', style: TextStyle(color: Color(0xFF455A64))),
                        Text('People: ${b.numberOfPeople}', style: TextStyle(color: Color(0xFF455A64))),
                        Text('Status: ${b.status}', style: TextStyle(color: Color(0xFF455A64))),
                        Text('Booking ID: ${b.id}', style: TextStyle(color: Color(0xFF455A64))),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _ExcursionBookingTab extends StatefulWidget {
  @override
  State<_ExcursionBookingTab> createState() => _ExcursionBookingTabState();
}

class _ExcursionBookingTabState extends State<_ExcursionBookingTab> {
  List<ExcursionBooking> _bookings = [];
  Map<int, Excursion> _excursionMap = {};
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('userEmail');
    if (email != null) {
      final maps = await ExcursionDbHelper().getBookingsByUser(email);
      _bookings = maps.map((e) => ExcursionBooking.fromMap(e)).toList();
      final excursions = await ExcursionDbHelper().getAllExcursions();
      _excursionMap = {for (var e in excursions) e.id!: e};
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_bookings.isEmpty) return Center(child: Text('No excursion bookings.', style: TextStyle(color: Color(0xFF455A64))));
    return ListView.builder(
      itemCount: _bookings.length,
      itemBuilder: (ctx, i) {
        final b = _bookings[i];
        final excursion = _excursionMap[b.excursionId];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          color: Color(0xFFD1E8F1),
          child: ListTile(
            leading: excursion != null
                ? Image.asset(excursion.image, width: 48, height: 48, fit: BoxFit.cover)
                : null,
            title: Text(excursion?.name ?? 'Excursion ${b.excursionId}', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF01579B))),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Date: ${b.bookingDate}', style: TextStyle(color: Color(0xFF455A64))),
                Text('People: ${b.numberOfPeople}', style: TextStyle(color: Color(0xFF455A64))),
                Text('Status: ${b.status}', style: TextStyle(color: Color(0xFF455A64))),
              ],
            ),
            onTap: () {
              showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
                builder: (ctx) => Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2)],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Excursion Booking Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF01579B))),
                        SizedBox(height: 8),
                        if (excursion != null) ...[
                          Image.asset(excursion.image, width: 80, height: 80, fit: BoxFit.cover),
                          SizedBox(height: 8),
                          Text('Excursion: ${excursion.name}', style: TextStyle(color: Color(0xFF455A64))),
                          Text('Category: ${excursion.category}', style: TextStyle(color: Color(0xFF455A64))),
                          Text('Location: ${excursion.location}', style: TextStyle(color: Color(0xFF455A64))),
                          Text('Time: ${excursion.time}', style: TextStyle(color: Color(0xFF455A64))),
                          Text('Description: ${excursion.description}', style: TextStyle(color: Color(0xFF455A64))),
                        ],
                        Text('Date: ${b.bookingDate}', style: TextStyle(color: Color(0xFF455A64))),
                        Text('People: ${b.numberOfPeople}', style: TextStyle(color: Color(0xFF455A64))),
                        Text('Status: ${b.status}', style: TextStyle(color: Color(0xFF455A64))),
                        Text('Booking ID: ${b.id}', style: TextStyle(color: Color(0xFF455A64))),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _RestaurantBookingTab extends StatefulWidget {
  @override
  State<_RestaurantBookingTab> createState() => _RestaurantBookingTabState();
}

class _RestaurantBookingTabState extends State<_RestaurantBookingTab> {
  List<RestaurantOrder> _orders = [];
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    _orders = await RestaurantOrderDbHelper().getAllOrders();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_orders.isEmpty) return Center(child: Text('No restaurant orders.', style: TextStyle(color: Color(0xFF455A64))));
    return ListView.builder(
      itemCount: _orders.length,
      itemBuilder: (ctx, i) {
        final o = _orders[i];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          color: Color(0xFFD1E8F1),
          child: ListTile(
            title: Text('Order ID: ${o.id}', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF01579B))),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Items: ${o.items.map((item) => item['restaurant'] ?? item['name'] ?? '').join(", ")}', style: TextStyle(color: Color(0xFF455A64))),
                Text('Paid: ${o.isPaid ? 'Yes' : 'No'}', style: TextStyle(color: Color(0xFF455A64))),
              ],
            ),
            onTap: () {
              showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
                builder: (ctx) => Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2)],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Restaurant Order Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF01579B))),
                        SizedBox(height: 8),
                        Text('Order ID: ${o.id}', style: TextStyle(color: Color(0xFF455A64))),
                        Text('Paid: ${o.isPaid ? 'Yes' : 'No'}', style: TextStyle(color: Color(0xFF455A64))),
                        ...o.items
                            .map((item) => Text('• ${item['restaurant'] ?? item['name'] ?? ''} x${item['quantity'] ?? 1}', style: TextStyle(color: Color(0xFF455A64))))
                            .toList(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _ServiceBookingTab extends StatefulWidget {
  @override
  State<_ServiceBookingTab> createState() => _ServiceBookingTabState();
}

class _ServiceBookingTabState extends State<_ServiceBookingTab> {
  List<ServiceOrder> _orders = [];
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    _orders = await ServiceOrderDbHelper().getAllOrders();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_orders.isEmpty) return Center(child: Text('No service orders.', style: TextStyle(color: Color(0xFF455A64))));
    return ListView.builder(
      itemCount: _orders.length,
      itemBuilder: (ctx, i) {
        final o = _orders[i];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          color: Color(0xFFD1E8F1),
          child: ListTile(
            title: Text('Order ID: ${o.id}', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF01579B))),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Items: ${o.items.map((item) => item['service']?['name'] ?? '').join(", ")}', style: TextStyle(color: Color(0xFF455A64))),
                Text('Date: ${o.date}', style: TextStyle(color: Color(0xFF455A64))),
              ],
            ),
            onTap: () {
              showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
                builder: (ctx) => Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2)],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Service Order Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF01579B))),
                        SizedBox(height: 8),
                        Text('Order ID: ${o.id}', style: TextStyle(color: Color(0xFF455A64))),
                        Text('Date: ${o.date}', style: TextStyle(color: Color(0xFF455A64))),
                        ...o.items
                            .map((item) => Text('• ${item['service']?['name'] ?? ''} x${item['quantity'] ?? 1}', style: TextStyle(color: Color(0xFF455A64))))
                            .toList(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}