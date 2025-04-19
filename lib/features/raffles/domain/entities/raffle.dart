class Raffle {
  final int? id;
  final String name;
  final String lotteryNumber;
  final double price;
  final int totalTickets;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Raffle({
    this.id,
    required this.name,
    required this.lotteryNumber,
    required this.price,
    required this.totalTickets,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
}
