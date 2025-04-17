import 'package:sqflite/sqflite.dart';
import 'package:raffle/core/database/database_helper.dart';
import '../../domain/entities/ticket.dart';

class TicketDao {
  Future<void> insertTickets(List<Ticket> tickets, int raffleId) async {
    final db = await DatabaseHelper.instance.database;
    final batch = db.batch();

    for (final ticket in tickets) {
      batch.insert('tickets', {
        'id': ticket.id,
        'number': ticket.number,
        'status': ticket.status,
        'buyer_name': ticket.buyerName,
        'buyer_contact': ticket.buyerContact,
        'raffle_id': raffleId,
      });
    }

    await batch.commit(noResult: true);
  }

  Future<List<Ticket>> getTicketsByRaffleId(int raffleId) async {
    final db = await DatabaseHelper.instance.database;

    final maps = await db.query(
      'tickets',
      where: 'raffle_id = ?',
      whereArgs: [raffleId],
    );

    return maps
        .map((map) => Ticket(
              id: map['id'] as int,
              number: map['number'] as int,
              status: map['status'] as String,
              buyerName: map['buyer_name'] as String?,
              buyerContact: map['buyer_contact'] as String?,
            ))
        .toList();
  }

  Future<int> updateTicket(Ticket ticket) async {
    final db = await DatabaseHelper.instance.database;
    return await db.update(
      'tickets',
      {
        'status': ticket.status,
        'buyer_name': ticket.buyerName,
        'buyer_contact': ticket.buyerContact,
      },
      where: 'id = ?',
      whereArgs: [ticket.id],
    );
  }

  Future<void> deleteTicketsByRaffle(int raffleId) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('tickets', where: 'raffle_id = ?', whereArgs: [raffleId]);
  }
}
