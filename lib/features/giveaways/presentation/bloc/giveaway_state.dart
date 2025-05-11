part of 'giveaway_bloc.dart';

abstract class GiveawayState {}

class GiveawayInitial extends GiveawayState {}

class GiveawayLoading extends GiveawayState {}

class GiveawayLoaded extends GiveawayState {
  final List<Giveaway> giveaways;

  GiveawayLoaded(this.giveaways);
}

class GiveawayError extends GiveawayState {
  final String message;

  GiveawayError(this.message);
}
