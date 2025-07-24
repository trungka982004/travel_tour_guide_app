import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/restaurant_order.dart';

class RestaurantOrderDbHelper {
  static final RestaurantOrderDbHelper _instance = RestaurantOrderDbHelper._internal();
  factory RestaurantOrderDbHelper() => _instance;
  RestaurantOrderDbHelper._internal();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'restaurant_order.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE restaurant_orders (
            id TEXT PRIMARY KEY,
            items TEXT NOT NULL,
            isPaid INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertOrder(RestaurantOrder order) async {
    final dbClient = await db;
    return await dbClient.insert('restaurant_orders', order.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<RestaurantOrder>> getAllOrders() async {
    final dbClient = await db;
    final maps = await dbClient.query('restaurant_orders');
    return maps.map((map) => RestaurantOrder.fromMap(map)).toList();
  }

  Future<int> updateOrderStatus(String id, bool isPaid) async {
    final dbClient = await db;
    return await dbClient.update('restaurant_orders', {'isPaid': isPaid ? 1 : 0}, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteOrder(String id) async {
    final dbClient = await db;
    return await dbClient.delete('restaurant_orders', where: 'id = ?', whereArgs: [id]);
  }
} 