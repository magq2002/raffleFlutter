import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/raffle_model.dart';

class RaffleLocalDatasource {
  static final RaffleLocalDatasource instance = RaffleLocalDatasource._internal();
  static Database? _database;

  RaffleLocalDatasource._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'raffle.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE raffles (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        lottery_number TEXT NOT NULL,
        price REAL NOT NULL,
        total_tickets INTEGER NOT NULL,
        status TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        date TEXT NOT NULL,
        image_path TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE tickets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        raffle_id INTEGER NOT NULL,
        number INTEGER NOT NULL,
        status TEXT NOT NULL,
        buyer_name TEXT,
        buyer_contact TEXT,
        FOREIGN KEY (raffle_id) REFERENCES raffles (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<int> insertRaffle({
    required String name,
    required String lotteryNumber,
    required double price,
    required int totalTickets,
    required DateTime date,
    String? imagePath,
  }) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();

    return await db.insert('raffles', {
      'name': name,
      'lottery_number': lotteryNumber,
      'price': price,
      'total_tickets': totalTickets,
      'status': 'active',
      'created_at': now,
      'updated_at': now,
      'date': date.toIso8601String(),
      'image_path': imagePath,
    });
  }

  Future<List<Map<String, dynamic>>> getAllRaffles() async {
    final db = await database;
    return await db.query('raffles', orderBy: 'created_at DESC');
  }

  Future<Map<String, dynamic>?> getRaffleWithTickets(int id) async {
    final db = await database;
    final raffleList =
        await db.query('raffles', where: 'id = ?', whereArgs: [id]);
    if (raffleList.isEmpty) return null;

    final tickets = await db.query('tickets',
        where: 'raffle_id = ?', whereArgs: [id], orderBy: 'number ASC');
    return {
      'raffle': raffleList.first,
      'tickets': tickets,
    };
  }

  Future<void> updateTicket({
    required int ticketId,
    required String status,
    String? buyerName,
    String? buyerContact,
  }) async {
    final db = await database;
    await db.update(
      'tickets',
      {
        'status': status,
        'buyer_name': buyerName,
        'buyer_contact': buyerContact,
      },
      where: 'id = ?',
      whereArgs: [ticketId],
    );
  }

  Future<void> updateRaffleStatus(int raffleId, String newStatus) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();
    await db.update(
      'raffles',
      {
        'status': newStatus,
        'updated_at': now,
      },
      where: 'id = ?',
      whereArgs: [raffleId],
    );
  }

  Future<void> deleteRaffle(int raffleId) async {
    final db = await database;
    await db.delete('raffles', where: 'id = ?', whereArgs: [raffleId]);
  }

  Future<void> deleteRaffleById(int raffleId) async {
    final db = await database;
    await db.delete('raffles', where: 'id = ?', whereArgs: [raffleId]);
  }

  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete('tickets');
    await db.delete('raffles');
  }

  Future<void> insertTicket({
    required int raffleId,
    required int number,
    required String status,
    String? buyerName,
    String? buyerContact,
  }) async {
    final db = await database;
    await db.insert('tickets', {
      'raffle_id': raffleId,
      'number': number,
      'status': status,
      'buyer_name': buyerName,
      'buyer_contact': buyerContact,
    });
  }

  Future<int> insertRaffleModel(RaffleModel model) async {
    return await insertRaffle(
      name: model.name,
      lotteryNumber: model.lotteryNumber,
      price: model.price,
      totalTickets: model.totalTickets,
      date: model.date,
      imagePath: model.imagePath,
    );
  }
}
