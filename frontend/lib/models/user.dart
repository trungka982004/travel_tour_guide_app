class User {
  int? id;
  String fullName;
  String username;
  String phone;
  String email;
  String password;
  String dateOfBirth;
  String? avatarPath;

  User({
    this.id,
    required this.fullName,
    required this.username,
    required this.phone,
    required this.email,
    required this.password,
    required this.dateOfBirth,
    this.avatarPath,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'fullName': fullName,
      'username': username,
      'phone': phone,
      'email': email,
      'password': password,
      'dateOfBirth': dateOfBirth,
      'avatarPath': avatarPath,
    };
    if (id != null) map['id'] = id;
    return map;
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      fullName: map['fullName'],
      username: map['username'],
      phone: map['phone'],
      email: map['email'],
      password: map['password'],
      dateOfBirth: map['dateOfBirth'],
      avatarPath: map['avatarPath'],
    );
  }
}
