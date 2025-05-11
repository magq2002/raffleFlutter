import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/giveaway_model.dart';

class GiveawayLocalDatasource {
  static final GiveawayLocalDatasource instance =
      GiveawayLocalDatasource._internal();
  static Database? _database;

  GiveawayLocalDatasource._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'giveaway.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE giveaways (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        drawDate TEXT NOT NULL,
        status TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertGiveaway(GiveawayModel model) async {
    final db = await database;
    return await db.insert('giveaways', model.toMap());
  }

  Future<List<GiveawayModel>> getAllGiveaways() async {
    final db = await database;
    final res = await db.query('giveaways', orderBy: 'createdAt DESC');
    return res.map((e) => GiveawayModel.fromMap(e)).toList();
  }

  Future<GiveawayModel?> getGiveawayById(int id) async {
    final db = await database;
    final res = await db.query('giveaways', where: 'id = ?', whereArgs: [id]);
    if (res.isNotEmpty) {
      return GiveawayModel.fromMap(res.first);
    }
    return null;
  }

  Future<void> updateGiveawayStatus(int id, String newStatus) async {
    final db = await database;
    await db.update(
      'giveaways',
      {
        'status': newStatus,
        'updatedAt': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteGiveaway(int id) async {
    final db = await database;
    await db.delete('giveaways', where: 'id = ?', whereArgs: [id]);
  }
}
