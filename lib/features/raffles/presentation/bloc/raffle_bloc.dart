import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raffle/features/raffles/domain/entities/raffle.dart';
import 'package:raffle/features/raffles/domain/entities/ticket.dart';
import 'package:raffle/features/raffles/domain/repositories/raffle_repository.dart';
import 'raffle_event.dart';
import 'raffle_state.dart';

class RaffleBloc extends Bloc<RaffleEvent, RaffleState> {
  final RaffleRepository repository;

  RaffleBloc(this.repository) : super(RaffleLoading()) {
    on<LoadRaffles>((event, emit) async {
      emit(RaffleLoading());
      try {
        final raffles = await repository.getAllRaffles();
        emit(RaffleLoaded(raffles: raffles));
      } catch (e) {
        emit(RaffleError(message: e.toString()));
      }
    });

    on<CreateRaffle>((event, emit) async {
      try {
        final newRaffle = Raffle(
          id: null,
          name: event.name,
          lotteryNumber: event.lotteryNumber,
          price: event.price,
          totalTickets: event.totalTickets,
          status: 'active',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final tickets = List.generate(event.totalTickets, (i) {
          return Ticket(
            id: null,
            raffleId:
                -1, // Lo asignaremos luego en el repository con el ID real
            number: i + 1,
            status: 'available',
          );
        });

        await repository.createRaffleWithTickets(newRaffle, tickets);
        add(LoadRaffles());
      } catch (e) {
        emit(RaffleError(message: e.toString()));
      }
    });

    on<DeleteRaffle>((event, emit) async {
      try {
        await repository.deleteRaffleAndTickets(event.raffleId);
        add(LoadRaffles());
      } catch (e) {
        emit(RaffleError(message: e.toString()));
      }
    });

    on<UpdateRaffleStatusEvent>((event, emit) async {
      try {
        await repository.updateRaffleStatus(event.raffleId, event.newStatus);
        add(LoadRaffles());
      } catch (e) {
        emit(RaffleError(message: e.toString()));
      }
    });

    on<UpdateTicketEvent>((event, emit) async {
      try {
        await repository.updateTicket(event.ticket);
        add(LoadRaffles());
      } catch (e) {
        emit(RaffleError(message: e.toString()));
      }
    });
  }
}
