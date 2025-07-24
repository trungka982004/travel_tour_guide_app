import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/room_booking.dart';

class RoomBookingDbHelper {
  static final RoomBookingDbHelper _instance = RoomBookingDbHelper._internal();
  factory RoomBookingDbHelper() => _instance;
  RoomBookingDbHelper._internal();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'room_booking.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE room_bookings (
            id TEXT PRIMARY KEY,
            roomName TEXT NOT NULL,
            roomImageAsset TEXT NOT NULL,
            checkIn TEXT NOT NULL,
            checkOut TEXT NOT NULL,
            adults INTEGER NOT NULL,
            children INTEGER NOT NULL,
            guestName TEXT NOT NULL,
            status TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertBooking(BookingOrder order) async {
    final dbClient = await db;
    return await dbClient.insert('room_bookings', order.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<BookingOrder>> getAllBookings() async {
    final dbClient = await db;
    final maps = await dbClient.query('room_bookings');
    return maps.map((map) => BookingOrder.fromMap(map)).toList();
  }

  Future<int> updateBookingStatus(String id, String status) async {
    final dbClient = await db;
    return await dbClient.update('room_bookings', {'status': status}, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteBooking(String id) async {
    final dbClient = await db;
    return await dbClient.delete('room_bookings', where: 'id = ?', whereArgs: [id]);
  }
} 