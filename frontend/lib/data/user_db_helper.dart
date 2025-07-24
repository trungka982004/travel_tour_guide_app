import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';

class UserDbHelper {
  static final UserDbHelper _instance = UserDbHelper._internal();
  factory UserDbHelper() => _instance;
  UserDbHelper._internal();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'user.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            fullName TEXT NOT NULL,
            username TEXT NOT NULL,
            phone TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE,
            password TEXT NOT NULL,
            dateOfBirth TEXT NOT NULL,
            avatarPath TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE users ADD COLUMN avatarPath TEXT');
        }
      },
    );
  }

  Future<int> insertUser(User user) async {
    final dbClient = await db;
    return await dbClient.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<User?> getUserByEmail(String email) async {
    final dbClient = await db;
    final maps = await dbClient.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<User?> getUserByUsername(String username) async {
    final dbClient = await db;
    final maps = await dbClient.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateUser(User user) async {
    final dbClient = await db;
    return await dbClient.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<User?> authenticate(String email, String password) async {
    final dbClient = await db;
    final maps = await dbClient.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<void> insertDefaultTestUser() async {
    final dbClient = await db;
    // Check if test user exists
    final maps = await dbClient.query(
      'users',
      where: 'email = ?',
      whereArgs: ['test@example.com'],
    );
    if (maps.isEmpty) {
      final testUser = User(
        fullName: 'Test User',
        username: 'testuser',
        phone: '0123456789',
        email: 'test@example.com',
        password: 'test1234',
        dateOfBirth: '2000-01-01',
      );
      await dbClient.insert('users', testUser.toMap());
    }
  }
}
