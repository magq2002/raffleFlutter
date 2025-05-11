import '../../domain/entities/participant.dart';

class ParticipantModel extends Participant {
  const ParticipantModel({
    super.id,
    required super.giveawayId,
    required super.name,
    required super.contact,
    required super.isPreselected,
    required super.isWinner,
    super.award, // NUEVO
    required super.createdAt,
    required super.updatedAt,
  });

  factory ParticipantModel.fromMap(Map<String, dynamic> map) {
    return ParticipantModel(
      id: map['id'],
      giveawayId: map['giveawayId'],
      name: map['name'],
      contact: map['contact'],
      isPreselected: map['isPreselected'] == 1,
      isWinner: map['isWinner'] == 1,
      award: map['award'], // NUEVO
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'giveawayId': giveawayId,
      'name': name,
      'contact': contact,
      'isPreselected': isPreselected ? 1 : 0,
      'isWinner': isWinner ? 1 : 0,
      'award': award,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory ParticipantModel.fromEntity(Participant participant) {
    return ParticipantModel(
      id: participant.id,
      giveawayId: participant.giveawayId,
      name: participant.name,
      contact: participant.contact,
      isPreselected: participant.isPreselected,
      isWinner: participant.isWinner,
      award: participant.award, // NUEVO
      createdAt: participant.createdAt,
      updatedAt: participant.updatedAt,
    );
  }

  Participant toEntity() {
    return Participant(
      id: id,
      giveawayId: giveawayId,
      name: name,
      contact: contact,
      isPreselected: isPreselected,
      isWinner: isWinner,
      award: award,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
