import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/user_db_helper.dart';
import '../models/user.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  User? _user;
  bool _isLoading = true;
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  bool _obscurePassword = true;
  bool _canEditPassword = false;

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
        });
      }
    }
    setState(() => _isLoading = false);
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
    );
    await UserDbHelper().updateUser(updatedUser);
    // Update shared_preferences if email changed
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userEmail', updatedUser.email);
    setState(() {
      _user = updatedUser;
      _isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Profile updated successfully!')),
    );
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
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundImage: AssetImage('assets/home/view1.png'),
                    ),
                    SizedBox(height: 12),
                    Text('Edit Profile', style: Theme.of(context).textTheme.titleLarge),
                  ],
                ),
              ),
              SizedBox(height: 24),
              TextFormField(
                controller: _fullNameController,
                decoration: InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person)),
                validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username', prefixIcon: Icon(Icons.account_circle)),
                validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone Number', prefixIcon: Icon(Icons.phone)),
                keyboardType: TextInputType.phone,
                validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email)),
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
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                obscureText: _obscurePassword,
                validator: (v) => v == null || v.length < 6 ? 'Min 6 characters' : null,
                onTap: () async {
                  if (!_canEditPassword) {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text('Change Password?'),
                        content: Text('Changing your password will affect how you log in next time. Are you sure you want to continue?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            child: Text('Continue'),
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
                decoration: InputDecoration(labelText: 'Date of Birth', prefixIcon: Icon(Icons.cake)),
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
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveProfile,
                  child: _isLoading ? CircularProgressIndicator() : Text('Save Changes'),
                ),
              ),
              SizedBox(height: 24),
              Divider(),
              _profileAction(Icons.logout, 'Logout', () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isLoggedIn', false);
                await prefs.remove('userEmail');
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                  (route) => false,
                );
              }, color: Colors.red),
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
        child: ListTile(
          leading: Icon(icon, color: color ?? Color(0xFF1976D2)),
          title: Text(label, style: TextStyle(color: color ?? Colors.black)),
          onTap: onTap,
        ),
      ),
    );
  }
} 