import 'package:raffle/features/raffles/data/models/ticket_model.dart';
import 'package:raffle/features/raffles/data/datasources/raffle_local_datasource.dart';

class TicketDao {
  final RaffleLocalDatasource localDatasource;

  TicketDao({required this.localDatasource});

  static final TicketDao instance =
      TicketDao(localDatasource: RaffleLocalDatasource.instance);

  Future<List<TicketModel>> getTicketsByRaffleId(int raffleId) async {
    final data = await localDatasource.getRaffleWithTickets(raffleId);
    if (data == null) return [];
    final ticketMaps = data['tickets'] as List<Map<String, dynamic>>;
    return ticketMaps.map((map) => TicketModel.fromMap(map)).toList();
  }

  Future<void> updateTicket(TicketModel ticket) async {
    if (ticket.id != null) {
      await localDatasource.updateTicket(
        ticketId: ticket.id!,
        status: ticket.status,
        buyerName: ticket.status == 'available' ? null : ticket.buyerName,
        buyerContact: ticket.status == 'available' ? null : ticket.buyerContact,
      );
    }
  }

  Future<void> deleteTicketsByRaffle(int raffleId) async {
    final tickets = await getTicketsByRaffleId(raffleId);
    for (final ticket in tickets) {
      if (ticket.id != null) {
        await localDatasource.updateTicket(
          ticketId: ticket.id!,
          status: 'available',
          buyerName: null,
          buyerContact: null,
        );
      }
    }
  }

  Future<void> insertTickets(List<TicketModel> tickets, int raffleId) async {
    for (final ticket in tickets) {
      await localDatasource.insertTicket(
        raffleId: raffleId,
        number: ticket.number,
        status: ticket.status,
        buyerName: ticket.buyerName,
        buyerContact: ticket.buyerContact,
      );
    }
  }
}
