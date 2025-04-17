import 'package:flutter_bloc/flutter_bloc.dart';
import 'raffle_state.dart';
import '../../domain/entities/raffle.dart';
import '../../domain/entities/ticket.dart';

class RaffleCubit extends Cubit<RaffleState> {
  RaffleCubit() : super(RaffleState());

  void loadRaffle(Raffle raffle, List<Ticket> tickets) {
    emit(state.copyWith(raffle: raffle, tickets: tickets, loading: false));
  }

  void updateRaffleStatus(String status) {
    if (state.raffle == null) return;

    final updated =
        state.raffle!.copyWith(status: status, updatedAt: DateTime.now());
    emit(state.copyWith(raffle: updated));
  }

  void updateTicket(
    int ticketId, {
    required String status,
    String? buyerName,
    String? buyerContact,
  }) {
    final updated = state.tickets.map((ticket) {
      if (ticket.id == ticketId) {
        return Ticket(
          id: ticket.id,
          number: ticket.number,
          status: status,
          buyerName: buyerName,
          buyerContact: buyerContact,
        );
      }
      return ticket;
    }).toList();

    emit(state.copyWith(tickets: updated));
  }
}
