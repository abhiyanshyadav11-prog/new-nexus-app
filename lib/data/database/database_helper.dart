
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'nexus_pendant.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      '''
      CREATE TABLE reminders(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        dateTime TEXT
      )
      '''
    );
    await db.execute(
      '''
      CREATE TABLE timetable_entries(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        dayOfWeek INTEGER,
        startTime TEXT,
        endTime TEXT
      )
      '''
    );
    await db.execute(
      '''
      CREATE TABLE memory_items(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        content TEXT,
        timestamp TEXT
      )
      '''
    );
    await db.execute(
      '''
      CREATE TABLE command_logs(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        command TEXT,
        timestamp TEXT,
        status TEXT
      )
      '''
    );
  }
}
