class Ticket {
  final int? id;
  final int raffleId;
  final int number;
  final String status;
  final String? buyerName;
  final String? buyerContact;

  Ticket({
    this.id, // era required
    required this.raffleId,
    required this.number,
    required this.status,
    this.buyerName,
    this.buyerContact,
  });

  factory Ticket.fromMap(Map<String, dynamic> map) {
    return Ticket(
      id: map['id'],
      raffleId: map['raffle_id'],
      number: map['number'],
      status: map['status'],
      buyerName: map['buyer_name'],
      buyerContact: map['buyer_contact'],
    );
  }

  Ticket copyWith({
    int? id,
    int? raffleId,
    int? number,
    String? status,
    String? buyerName,
    String? buyerContact,
  }) {
    return Ticket(
      id: id ?? this.id,
      raffleId: raffleId ?? this.raffleId,
      number: number ?? this.number,
      status: status ?? this.status,
      buyerName: buyerName ?? this.buyerName,
      buyerContact: buyerContact ?? this.buyerContact,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'raffle_id': raffleId,
      'number': number,
      'status': status,
      'buyer_name': buyerName,
      'buyer_contact': buyerContact,
    };
  }
}
