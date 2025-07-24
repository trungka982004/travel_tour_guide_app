import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/service_order.dart';

class ServiceOrderDbHelper {
  static final ServiceOrderDbHelper _instance = ServiceOrderDbHelper._internal();
  factory ServiceOrderDbHelper() => _instance;
  ServiceOrderDbHelper._internal();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'service_order.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE service_orders (
            id TEXT PRIMARY KEY,
            items TEXT NOT NULL,
            date TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertOrder(ServiceOrder order) async {
    final dbClient = await db;
    return await dbClient.insert('service_orders', order.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<ServiceOrder>> getAllOrders() async {
    final dbClient = await db;
    final maps = await dbClient.query('service_orders');
    return maps.map((map) => ServiceOrder.fromMap(map)).toList();
  }

  Future<int> deleteOrder(String id) async {
    final dbClient = await db;
    return await dbClient.delete('service_orders', where: 'id = ?', whereArgs: [id]);
  }
} 