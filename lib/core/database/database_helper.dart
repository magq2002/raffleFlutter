import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('raffles.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE raffles (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        lottery_number TEXT NOT NULL,
        price REAL NOT NULL,
        total_tickets INTEGER NOT NULL,
        status TEXT NOT NULL,
        deleted INTEGER NOT NULL,
        deleted_at TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE tickets (
        id INTEGER PRIMARY KEY,
        number INTEGER NOT NULL,
        status TEXT NOT NULL,
        buyer_name TEXT,
        buyer_contact TEXT,
        raffle_id INTEGER NOT NULL,
        FOREIGN KEY (raffle_id) REFERENCES raffles (id)
      )
    ''');
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
