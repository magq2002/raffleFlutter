import '../../domain/entities/giveaway.dart';

class GiveawayModel extends Giveaway {
  GiveawayModel({
    required super.id,
    required super.name,
    required super.description,
    required super.drawDate,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
  });

  factory GiveawayModel.fromMap(Map<String, dynamic> map) {
    return GiveawayModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      drawDate: DateTime.parse(map['drawDate']),
      status: map['status'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'drawDate': drawDate.toIso8601String(),
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory GiveawayModel.fromEntity(Giveaway giveaway) {
    return GiveawayModel(
      id: giveaway.id,
      name: giveaway.name,
      description: giveaway.description,
      drawDate: giveaway.drawDate,
      status: giveaway.status,
      createdAt: giveaway.createdAt,
      updatedAt: giveaway.updatedAt,
    );
  }

  Giveaway toEntity() {
    return Giveaway(
      id: id,
      name: name,
      description: description,
      drawDate: drawDate,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
