import 'package:equatable/equatable.dart';

class Participant extends Equatable {
  final int? id;
  final int giveawayId;
  final String name;
  final String contact;
  final bool isPreselected;
  final bool isWinner;
  final String? award;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Participant({
    this.id,
    required this.giveawayId,
    required this.name,
    required this.contact,
    this.isPreselected = false,
    this.isWinner = false,
    this.award,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        giveawayId,
        name,
        contact,
        isPreselected,
        isWinner,
        award,
        createdAt,
        updatedAt,
      ];
}
