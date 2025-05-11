import 'package:raffle/features/raffles/domain/entities/ticket.dart';

class TicketModel extends Ticket {
  TicketModel({
    required super.id,
    required super.number,
    required super.status,
    super.buyerName,
    super.buyerContact,
    required super.raffleId,
  });

  factory TicketModel.fromMap(Map<String, dynamic> map) {
    final id = int.tryParse(map['id'].toString());
    final number = int.tryParse(map['number'].toString());
    final raffleId = int.tryParse(map['raffle_id'].toString());
    final status = map['status'];

    if (id == null || number == null || raffleId == null || status == null) {
      throw Exception('❌ Ticket mal formado: $map');
    }
    return TicketModel(
      id: id,
      number: number,
      status: status,
      raffleId: raffleId,
      buyerName: map['buyer_name'] as String?,
      buyerContact: map['buyer_contact'] as String?,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'number': number,
      'status': status,
      'buyerName': buyerName,
      'buyerContact': buyerContact,
      'raffleId': raffleId,
    };
  }

  Ticket toEntity() {
    return Ticket(
      id: id,
      number: number,
      status: status,
      buyerName: buyerName,
      buyerContact: buyerContact,
      raffleId: raffleId,
    );
  }

  factory TicketModel.fromEntity(Ticket ticket) {
    return TicketModel(
      id: ticket.id,
      number: ticket.number,
      status: ticket.status,
      buyerName: ticket.buyerName,
      buyerContact: ticket.buyerContact,
      raffleId: ticket.raffleId,
    );
  }
}
