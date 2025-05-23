import 'package:raffle/features/raffles/domain/entities/raffle.dart';
import 'package:raffle/features/raffles/domain/entities/ticket.dart';

class RaffleModel extends Raffle {
  RaffleModel({
    required int? id,
    required String name,
    required String lotteryNumber,
    required double price,
    required int totalTickets,
    required String status,
    required DateTime createdAt,
    required DateTime updatedAt,
    required DateTime date,
    String? imagePath,
    List<Ticket>? tickets,
  }) : super(
          id: id,
          name: name,
          lotteryNumber: lotteryNumber,
          price: price,
          totalTickets: totalTickets,
          status: status,
          createdAt: createdAt,
          updatedAt: updatedAt,
          date: date,
          imagePath: imagePath,
          tickets: tickets,
        );

  factory RaffleModel.fromMap(Map<String, dynamic> map) {
    return RaffleModel(
      id: map['id'],
      name: map['name'],
      lotteryNumber: map['lottery_number'],
      price: map['price'],
      totalTickets: map['total_tickets'],
      status: map['status'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      date: DateTime.parse(map['date']),
      imagePath: map['image_path'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'lottery_number': lotteryNumber,
      'price': price,
      'total_tickets': totalTickets,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'date': date.toIso8601String(),
      'image_path': imagePath,
    };
  }

  factory RaffleModel.fromEntity(Raffle raffle) {
    return RaffleModel(
      id: raffle.id,
      name: raffle.name,
      lotteryNumber: raffle.lotteryNumber,
      price: raffle.price,
      totalTickets: raffle.totalTickets,
      status: raffle.status,
      createdAt: raffle.createdAt,
      updatedAt: raffle.updatedAt,
      date: raffle.date,
      imagePath: raffle.imagePath,
      tickets: raffle.tickets,
    );
  }

  Raffle toEntity() {
    return Raffle(
      id: id,
      name: name,
      lotteryNumber: lotteryNumber,
      price: price,
      totalTickets: totalTickets,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
      date: date,
      imagePath: imagePath,
      tickets: tickets,
    );
  }
}
