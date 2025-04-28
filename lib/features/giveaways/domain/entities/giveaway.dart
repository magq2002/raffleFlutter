class Giveaway {
  final int? id;
  final String name;
  final String description;
  final DateTime drawDate;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Giveaway({
    this.id,
    required this.name,
    required this.description,
    required this.drawDate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
}
