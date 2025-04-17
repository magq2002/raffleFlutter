class Raffle {
  final int id;
  final String name;
  final String lotteryNumber;
  final double price;
  final int totalTickets;
  final String status; // 'active', 'inactive', 'expired'
  final bool deleted;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Raffle({
    required this.id,
    required this.name,
    required this.lotteryNumber,
    required this.price,
    required this.totalTickets,
    required this.status,
    required this.deleted,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });
}
