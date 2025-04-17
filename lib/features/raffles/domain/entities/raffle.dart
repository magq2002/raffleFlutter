class Raffle {
  final int id;
  final String name;
  final String lotteryNumber;
  final double price;
  final int totalTickets;
  final String status;
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

  Raffle copyWith({
    int? id,
    String? name,
    String? lotteryNumber,
    double? price,
    int? totalTickets,
    String? status,
    bool? deleted,
    DateTime? deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Raffle(
      id: id ?? this.id,
      name: name ?? this.name,
      lotteryNumber: lotteryNumber ?? this.lotteryNumber,
      price: price ?? this.price,
      totalTickets: totalTickets ?? this.totalTickets,
      status: status ?? this.status,
      deleted: deleted ?? this.deleted,
      deletedAt: deletedAt ?? this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
