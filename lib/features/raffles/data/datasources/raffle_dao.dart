import 'package:sqflite/sqflite.dart';
import 'package:raffle/core/database/database_helper.dart';
import '../../domain/entities/raffle.dart';

class RaffleDao {
  Future<int> insertRaffle(Raffle raffle) async {
    final db = await DatabaseHelper.instance.database;
    return await db.insert('raffles', {
      'id': raffle.id,
      'name': raffle.name,
      'lottery_number': raffle.lotteryNumber,
      'price': raffle.price,
      'total_tickets': raffle.totalTickets,
      'status': raffle.status,
      'deleted': raffle.deleted ? 1 : 0,
      'deleted_at': raffle.deletedAt?.toIso8601String(),
      'created_at': raffle.createdAt.toIso8601String(),
      'updated_at': raffle.updatedAt.toIso8601String(),
    });
  }

  Future<List<Raffle>> getAllRaffles() async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query('raffles', orderBy: 'created_at DESC');

    return maps
        .map((map) => Raffle(
              id: map['id'] as int,
              name: map['name'] as String,
              lotteryNumber: map['lottery_number'] as String,
              price: map['price'] as double,
              totalTickets: map['total_tickets'] as int,
              status: map['status'] as String,
              deleted: (map['deleted'] as int) == 1,
              deletedAt: map['deleted_at'] != null
                  ? DateTime.parse(map['deleted_at'] as String)
                  : null,
              createdAt: DateTime.parse(map['created_at'] as String),
              updatedAt: DateTime.parse(map['updated_at'] as String),
            ))
        .toList();
  }

  Future<int> updateRaffleStatus(int id, String status) async {
    final db = await DatabaseHelper.instance.database;
    return await db.update(
      'raffles',
      {
        'status': status,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAllRaffles() async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('raffles');
  }

  Future<void> deleteRaffleById(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('raffles', where: 'id = ?', whereArgs: [id]);
  }
}
