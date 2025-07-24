import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/excursion.dart';
import '../models/excursion_booking.dart';

class ExcursionDbHelper {
  static final ExcursionDbHelper _instance = ExcursionDbHelper._internal();
  factory ExcursionDbHelper() => _instance;
  ExcursionDbHelper._internal();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'excursion.db');
    return await openDatabase(
      path,
      version: 2, // Bump version for migration
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE excursions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            description TEXT NOT NULL,
            image TEXT NOT NULL,
            location TEXT NOT NULL,
            time TEXT NOT NULL,
            category TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE excursion_bookings (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            excursion_id INTEGER NOT NULL,
            user_email TEXT NOT NULL,
            user_name TEXT NOT NULL,
            booking_time TEXT NOT NULL,
            booking_date TEXT NOT NULL,
            number_of_people INTEGER NOT NULL,
            status TEXT NOT NULL,
            FOREIGN KEY(excursion_id) REFERENCES excursions(id)
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE excursion_bookings ADD COLUMN user_name TEXT NOT NULL DEFAULT ""');
        }
      },
    );
  }

  Future<int> insertExcursion(Excursion excursion) async {
    final dbClient = await db;
    return await dbClient.insert('excursions', excursion.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Excursion>> getAllExcursions() async {
    final dbClient = await db;
    final maps = await dbClient.query('excursions');
    return maps.map((map) => Excursion.fromMap(map)).toList();
  }

  Future<int> updateExcursion(Excursion excursion) async {
    final dbClient = await db;
    return await dbClient.update('excursions', excursion.toMap(), where: 'id = ?', whereArgs: [excursion.id]);
  }

  Future<int> deleteExcursion(int id) async {
    final dbClient = await db;
    return await dbClient.delete('excursions', where: 'id = ?', whereArgs: [id]);
  }

  // Booking logic
  Future<int> bookExcursion({
    required int excursionId,
    required String userEmail,
    required String userName,
    required String bookingTime,
    required String bookingDate,
    required int numberOfPeople,
    String status = 'booked',
  }) async {
    final dbClient = await db;
    return await dbClient.insert('excursion_bookings', {
      'excursion_id': excursionId,
      'user_email': userEmail,
      'user_name': userName,
      'booking_time': bookingTime,
      'booking_date': bookingDate,
      'number_of_people': numberOfPeople,
      'status': status,
    });
  }

  Future<List<Map<String, dynamic>>> getBookingsByUser(String userEmail) async {
    final dbClient = await db;
    return await dbClient.query('excursion_bookings', where: 'user_email = ?', whereArgs: [userEmail]);
  }

  Future<int> cancelBooking(int bookingId) async {
    final dbClient = await db;
    return await dbClient.update('excursion_bookings', {'status': 'cancelled'}, where: 'id = ?', whereArgs: [bookingId]);
  }
} 