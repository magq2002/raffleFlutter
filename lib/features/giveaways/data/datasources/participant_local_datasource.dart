import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../../domain/entities/participant.dart';
import '../models/participant_model.dart';

class ParticipantLocalDatasource {
  static final ParticipantLocalDatasource instance =
      ParticipantLocalDatasource._internal();
  static Database? _database;

  ParticipantLocalDatasource._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'gateway.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE participants (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            giveawayId INTEGER NOT NULL,
            name TEXT NOT NULL,
            contact TEXT NOT NULL,
            isPreselected INTEGER NOT NULL,
            isWinner INTEGER NOT NULL,
            award TEXT, -- NUEVO
            createdAt TEXT NOT NULL,
            updatedAt TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertParticipant(ParticipantModel participant) async {
    final db = await database;
    return await db.insert('participants', participant.toMap());
  }

  Future<List<ParticipantModel>> getParticipantsByGiveawayId(
      int giveawayId) async {
    final db = await database;
    final maps = await db.query(
      'participants',
      where: 'giveawayId = ?',
      whereArgs: [giveawayId],
    );
    return maps.map((map) => ParticipantModel.fromMap(map)).toList();
  }

  Future<void> updateParticipant(ParticipantModel participant) async {
    final db = await database;
    await db.update(
      'participants',
      participant.toMap(),
      where: 'id = ?',
      whereArgs: [participant.id],
    );
  }

  Future<void> deleteParticipant(int id) async {
    final db = await database;
    await db.delete('participants', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteParticipantsByGiveaway(int giveawayId) async {
    final db = await database;
    await db.delete('participants',
        where: 'giveawayId = ?', whereArgs: [giveawayId]);
  }

  Future<void> preselectParticipants(
      {required int giveawayId, required int count}) async {
    final db = await database;

    await db.transaction((txn) async {
      // Reset all
      await txn.update(
        'participants',
        {'isPreselected': 0},
        where: 'giveawayId = ?',
        whereArgs: [giveawayId],
      );

      // Select random
      final List<Map<String, dynamic>> participants = await txn.query(
        'participants',
        columns: ['id'],
        where: 'giveawayId = ?',
        whereArgs: [giveawayId],
      );

      if (participants.isEmpty) return;

      final participantIds = participants.map((p) => p['id'] as int).toList();
      participantIds.shuffle();
      final selectedIds = participantIds.take(count);

      for (final id in selectedIds) {
        await txn.update(
          'participants',
          {'isPreselected': 1},
          where: 'id = ?',
          whereArgs: [id],
        );
      }
    });
  }

  Future<Participant?> drawWinner(int giveawayId) async {
    final db = await database;

    // Intentar con preseleccionados que no han ganado
    List<Map<String, dynamic>> participantsList = await db.query(
      'participants',
      where: 'giveawayId = ? AND isPreselected = 1 AND isWinner = 0',
      whereArgs: [giveawayId],
    );

    // Si no hay preseleccionados, usar todos los que no han ganado
    if (participantsList.isEmpty) {
      participantsList = await db.query(
        'participants',
        where: 'giveawayId = ? AND isWinner = 0',
        whereArgs: [giveawayId],
      );
    }

    if (participantsList.isEmpty) return null;

    final participants =
        participantsList.map((p) => ParticipantModel.fromMap(p)).toList();
    participants.shuffle();

    final winner = participants.first;

    // Ver cuántos ganadores ya hay
    final existingWinners = await db.query(
      'participants',
      where: 'giveawayId = ? AND isWinner = 1',
      whereArgs: [giveawayId],
    );

    String award;
    if (existingWinners.isEmpty) {
      award = 'Oro';
    } else if (existingWinners.length == 1) {
      award = 'Plata';
    } else if (existingWinners.length == 2) {
      award = 'Bronce';
    } else {
      award = 'Reconocimiento';
    }

    await db.update(
      'participants',
      {
        'isWinner': 1,
        'award': award,
        'updatedAt': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [winner.id],
    );

    return winner.toEntity();
  }
}
