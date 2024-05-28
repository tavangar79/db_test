import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'example.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE example_table (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      value INTEGER
    )
    ''');
  }

  Future<void> insertValue() async {
    final db = await database;
    await db.insert(
      'example_table',
      {'value': 1},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> getValue() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('example_table');
    return maps.first['value'];
  }
}
