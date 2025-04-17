class Ticket {
  final int id;
  final int number;
  final String status; // 'available', 'sold', 'reserved'
  final String? buyerName;
  final String? buyerContact;

  const Ticket({
    required this.id,
    required this.number,
    required this.status,
    this.buyerName,
    this.buyerContact,
  });
}
