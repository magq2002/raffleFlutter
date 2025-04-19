import 'package:equatable/equatable.dart';
import '../../../domain/entities/raffle.dart';
import '../../../domain/entities/ticket.dart';

abstract class RaffleDetailsState extends Equatable {
  const RaffleDetailsState();

  @override
  List<Object?> get props => [];
}

class RaffleDetailsInitial extends RaffleDetailsState {}

class RaffleDetailsLoading extends RaffleDetailsState {}

class RaffleDetailsLoaded extends RaffleDetailsState {
  final Raffle raffle;
  final List<Ticket> tickets;

  const RaffleDetailsLoaded({required this.raffle, required this.tickets});

  @override
  List<Object?> get props => [raffle, tickets];
}

class RaffleDetailsError extends RaffleDetailsState {
  final String message;

  const RaffleDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
