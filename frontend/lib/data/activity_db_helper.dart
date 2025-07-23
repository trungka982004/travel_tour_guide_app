import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/activity.dart';

class ActivityDbHelper {
  static final ActivityDbHelper _instance = ActivityDbHelper._internal();
  factory ActivityDbHelper() => _instance;
  ActivityDbHelper._internal();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'activity.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE activities (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            description TEXT NOT NULL,
            image TEXT NOT NULL,
            category TEXT NOT NULL,
            time TEXT NOT NULL,
            audience TEXT NOT NULL,
            location TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE activity_bookings (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            activity_id INTEGER NOT NULL,
            user_email TEXT NOT NULL,
            booking_time TEXT NOT NULL,
            status TEXT NOT NULL,
            booking_date TEXT NOT NULL,
            number_of_people INTEGER NOT NULL,
            FOREIGN KEY(activity_id) REFERENCES activities(id)
          )
        ''');
      },
    );
  }

  Future<int> insertActivity(Activity activity) async {
    final dbClient = await db;
    return await dbClient.insert('activities', activity.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Activity>> getAllActivities() async {
    final dbClient = await db;
    final maps = await dbClient.query('activities');
    return maps.map((map) => Activity.fromMap(map)).toList();
  }

  Future<int> updateActivity(Activity activity) async {
    final dbClient = await db;
    return await dbClient.update('activities', activity.toMap(), where: 'id = ?', whereArgs: [activity.id]);
  }

  Future<int> deleteActivity(int id) async {
    final dbClient = await db;
    return await dbClient.delete('activities', where: 'id = ?', whereArgs: [id]);
  }

  // Booking logic
  Future<int> bookActivity({
    required int activityId,
    required String userEmail,
    required String bookingTime,
    required String bookingDate,
    required int numberOfPeople,
    String status = 'booked',
  }) async {
    final dbClient = await db;
    return await dbClient.insert('activity_bookings', {
      'activity_id': activityId,
      'user_email': userEmail,
      'booking_time': bookingTime,
      'status': status,
      'booking_date': bookingDate,
      'number_of_people': numberOfPeople,
    });
  }

  Future<List<Map<String, dynamic>>> getBookingsByUser(String userEmail) async {
    final dbClient = await db;
    return await dbClient.query('activity_bookings', where: 'user_email = ?', whereArgs: [userEmail]);
  }

  Future<int> cancelBooking(int bookingId) async {
    final dbClient = await db;
    return await dbClient.update('activity_bookings', {'status': 'cancelled'}, where: 'id = ?', whereArgs: [bookingId]);
  }
} 