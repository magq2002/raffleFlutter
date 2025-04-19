import 'package:equatable/equatable.dart';
import 'package:raffle/features/raffles/domain/entities/raffle.dart';

abstract class RaffleState extends Equatable {
  const RaffleState();

  @override
  List<Object?> get props => [];
}

class RaffleInitial extends RaffleState {}

class RaffleLoading extends RaffleState {}

class RaffleLoaded extends RaffleState {
  final List<Raffle> raffles;

  const RaffleLoaded({required this.raffles});

  @override
  List<Object> get props => [raffles];
}

class RaffleError extends RaffleState {
  final String message;

  const RaffleError({required this.message});

  @override
  List<Object> get props => [message];
}
