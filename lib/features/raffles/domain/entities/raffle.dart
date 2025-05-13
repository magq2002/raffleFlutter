import 'package:raffle/features/raffles/domain/entities/ticket.dart';

class Raffle {
  final int? id;
  final String name;
  final String lotteryNumber;
  final double price;
  final int totalTickets;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime date;
  final String? imagePath;
  final List<Ticket>? tickets;

  Raffle({
    this.id,
    required this.name,
    required this.lotteryNumber,
    required this.price,
    required this.totalTickets,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.date,
    this.imagePath,
    this.tickets,
  });

  Raffle copyWith({
    int? id,
    String? name,
    String? lotteryNumber,
    double? price,
    int? totalTickets,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? date,
    String? imagePath,
    List<Ticket>? tickets,
  }) {
    return Raffle(
      id: id ?? this.id,
      name: name ?? this.name,
      lotteryNumber: lotteryNumber ?? this.lotteryNumber,
      price: price ?? this.price,
      totalTickets: totalTickets ?? this.totalTickets,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      date: date ?? this.date,
      imagePath: imagePath ?? this.imagePath,
      tickets: tickets ?? this.tickets,
    );
  }
}
