import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/raffle.dart';
import '../../domain/entities/ticket.dart';
import '../../data/repositories/raffle_repository.dart';
import 'raffle_state.dart';

class RaffleCubit extends Cubit<RaffleState> {
  final RaffleRepository repository;

  RaffleCubit(this.repository) : super(RaffleState());

  Future<void> loadRaffle(Raffle raffle, List<Ticket> tickets) async {
    emit(state.copyWith(loading: true));
    try {
      await repository.createRaffleWithTickets(raffle, tickets);
      emit(state.copyWith(raffle: raffle, tickets: tickets, loading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), loading: false));
    }
  }

  Future<void> loadFromDatabase(int raffleId) async {
    emit(state.copyWith(loading: true));
    try {
      final raffles = await repository.getAllRaffles();
      final raffle = raffles.firstWhere((r) => r.id == raffleId);
      final tickets = await repository.getTicketsByRaffle(raffleId);

      emit(state.copyWith(raffle: raffle, tickets: tickets, loading: false));
    } catch (e) {
      emit(state.copyWith(error: 'Raffle not found', loading: false));
    }
  }

  Future<void> updateRaffleStatus(String status) async {
    final raffle = state.raffle;
    if (raffle == null) return;

    final updated = raffle.copyWith(status: status, updatedAt: DateTime.now());

    await repository.updateRaffleStatus(raffle.id, status);
    emit(state.copyWith(raffle: updated));
  }

  Future<void> updateTicket(
    int ticketId, {
    required String status,
    String? buyerName,
    String? buyerContact,
  }) async {
    final ticketList = state.tickets;
    final updatedList = ticketList.map((t) {
      if (t.id == ticketId) {
        return Ticket(
          id: t.id,
          number: t.number,
          status: status,
          buyerName: buyerName,
          buyerContact: buyerContact,
        );
      }
      return t;
    }).toList();

    final updatedTicket = updatedList.firstWhere((t) => t.id == ticketId);
    await repository.updateTicket(updatedTicket);
    emit(state.copyWith(tickets: updatedList));
  }

  Future<void> deleteCurrentRaffle() async {
    final raffle = state.raffle;
    if (raffle == null) return;

    await repository.deleteRaffleAndTickets(raffle.id);
    emit(RaffleState()); // limpiar todo
  }
}
