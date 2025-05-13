import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/raffle_repository.dart';
import '../../../data/models/raffle_model.dart';
import '../../../data/models/ticket_model.dart';
import 'raffle_details_event.dart';
import 'raffle_details_state.dart';

class RaffleDetailsBloc extends Bloc<RaffleDetailsEvent, RaffleDetailsState> {
  final RaffleRepository repository;

  RaffleDetailsBloc(this.repository) : super(RaffleDetailsInitial()) {
    on<LoadRaffleDetails>((event, emit) async {
      emit(RaffleDetailsLoading());
      try {
        print('🟢 Paso 1: obteniendo resultado...');
        final result = await repository.getRaffleWithTickets(event.raffleId);
        if (result == null) {
          emit(const RaffleDetailsError('Raffle not found.'));
          return;
        }

        print('🟢 Paso 2: convirtiendo raffle...');
        final raffleMap = Map<String, dynamic>.from(result['raffle']);
        print('raffleMap: $raffleMap');

        print('🟢 Paso 3: convirtiendo tickets...');
        final ticketsList = List<Map<String, dynamic>>.from(result['tickets']);
        print('ticketsList: $ticketsList');

        print('🟢 Paso 4: creando entidad raffle...');
        final raffle = RaffleModel.fromMap(raffleMap).toEntity();
        print('🟢 raffle creado: ${raffle.id} - ${raffle.name}');

        print('🟢 Paso 5: creando entidades tickets...');
        final tickets = ticketsList.map((t) {
          print('➡️ Ticket map: $t');
          final model = TicketModel.fromMap(t);
          print('✅ TicketModel creado: ${model.id} (${model.number})');
          return model.toEntity();
        }).toList();

        print('🟢 Paso 6: emitiendo estado loaded...');
        emit(RaffleDetailsLoaded(raffle: raffle, tickets: tickets));
      } catch (e, stack) {
        print("❌ ERROR: $e");
        print("📍 STACK TRACE:\n$stack");
        emit(RaffleDetailsError(e.toString()));
      }
    });

    on<ChangeRaffleStatus>((event, emit) async {
      try {
        await repository.updateRaffleStatus(event.raffleId, event.newStatus);
        add(LoadRaffleDetails(event.raffleId));
      } catch (e) {
        print("hola 1");

        emit(RaffleDetailsError(e.toString()));
      }
    });

    on<EditTicket>((event, emit) async {
      try {
        final currentState = state;
        if (currentState is RaffleDetailsLoaded) {
          final raffleId = currentState.raffle.id;
          if (raffleId == null) {
            emit(const RaffleDetailsError('Invalid raffle ID.'));
            return;
          }

          print('🔄 Iniciando actualización del ticket:');
          print('ID del ticket: ${event.ticket.id}');
          print('Número del ticket: ${event.ticket.number}');
          print('Estado: ${event.ticket.status}');
          print('Comprador: ${event.ticket.buyerName}');
          print('Contacto: ${event.ticket.buyerContact}');

          // Actualizar el ticket
          await repository.updateTicket(event.ticket);
          print('✅ Ticket actualizado en la base de datos');

          // Recargar los datos
          print('🔄 Recargando datos del raffle...');
          final result = await repository.getRaffleWithTickets(raffleId);
          if (result == null) {
            print('❌ No se encontró el raffle después de la actualización');
            emit(const RaffleDetailsError('Raffle not found after update.'));
            return;
          }

          final raffleMap = Map<String, dynamic>.from(result['raffle']);
          final ticketsList = List<Map<String, dynamic>>.from(result['tickets']);
          
          final raffle = RaffleModel.fromMap(raffleMap).toEntity();
          final tickets = ticketsList.map((t) {
            final ticket = TicketModel.fromMap(t).toEntity();
            print('📋 Ticket recargado: ${ticket.id} - Estado: ${ticket.status} - Comprador: ${ticket.buyerName}');
            return ticket;
          }).toList();
          
          print('✅ Datos recargados correctamente');
          emit(RaffleDetailsLoaded(raffle: raffle, tickets: tickets));
        }
      } catch (e, stack) {
        print("❌ Error al actualizar ticket: $e");
        print("📍 Stack trace:\n$stack");
        emit(RaffleDetailsError(e.toString()));
      }
    });

    on<DeleteRaffle>((event, emit) async {
      try {
        await repository.deleteRaffleAndTickets(event.raffleId);
        emit(RaffleDetailsInitial());
      } catch (e) {
        print("hola 3");

        emit(RaffleDetailsError(e.toString()));
      }
    });
  }
}
