import '../../domain/entities/raffle.dart';
import '../../domain/entities/ticket.dart';
import '../datasources/raffle_dao.dart';
import '../datasources/ticket_dao.dart';

class RaffleRepository {
  final RaffleDao _raffleDao;
  final TicketDao _ticketDao;

  RaffleRepository({
    required RaffleDao raffleDao,
    required TicketDao ticketDao,
  })  : _raffleDao = raffleDao,
        _ticketDao = ticketDao;

  Future<void> createRaffleWithTickets(
      Raffle raffle, List<Ticket> tickets) async {
    await _raffleDao.insertRaffle(raffle);
    await _ticketDao.insertTickets(tickets, raffle.id);
  }

  Future<List<Raffle>> getAllRaffles() async {
    return await _raffleDao.getAllRaffles();
  }

  Future<List<Ticket>> getTicketsByRaffle(int raffleId) async {
    return await _ticketDao.getTicketsByRaffleId(raffleId);
  }

  Future<void> updateRaffleStatus(int raffleId, String newStatus) async {
    await _raffleDao.updateRaffleStatus(raffleId, newStatus);
  }

  Future<void> updateTicket(Ticket ticket) async {
    await _ticketDao.updateTicket(ticket);
  }

  Future<void> deleteRaffleAndTickets(int raffleId) async {
    await _ticketDao.deleteTicketsByRaffle(raffleId);
    await _raffleDao.deleteRaffleById(raffleId);
  }
}
