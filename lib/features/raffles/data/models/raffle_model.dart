import 'package:raffle/features/raffles/domain/entities/raffle.dart';

class RaffleModel extends Raffle {
  RaffleModel({
    required super.id,
    required super.name,
    required super.lotteryNumber,
    required super.price,
    required super.totalTickets,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    super.imagePath,
    super.tickets,
  });

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
      imagePath: imagePath,
      tickets: tickets,
    );
  }
}
