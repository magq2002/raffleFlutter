import '../../domain/entities/raffle.dart';
import '../../domain/entities/ticket.dart';

class RaffleState {
  final Raffle? raffle;
  final List<Ticket> tickets;
  final bool loading;
  final String? error;

  RaffleState({
    this.raffle,
    this.tickets = const [],
    this.loading = false,
    this.error,
  });

  RaffleState copyWith({
    Raffle? raffle,
    List<Ticket>? tickets,
    bool? loading,
    String? error,
  }) {
    return RaffleState(
      raffle: raffle ?? this.raffle,
      tickets: tickets ?? this.tickets,
      loading: loading ?? this.loading,
      error: error,
    );
  }
}
