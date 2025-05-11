import 'package:flutter/material.dart';
import '../../domain/entities/participant.dart';

class ParticipantList extends StatelessWidget {
  final List<Participant> participants;

  const ParticipantList({super.key, required this.participants});

  @override
  Widget build(BuildContext context) {
    if (participants.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'No participants yet.',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    final sorted = [...participants]..sort((a, b) {
        if (a.isWinner && !b.isWinner) return -1;
        if (!a.isWinner && b.isWinner) return 1;
        if (a.isPreselected && !b.isPreselected) return -1;
        if (!a.isPreselected && b.isPreselected) return 1;
        return 0;
      });

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sorted.length,
      itemBuilder: (context, index) {
        final participant = sorted[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            title: Text(participant.name),
            subtitle: Text(participant.contact),
            trailing: _buildBadge(participant),
          ),
        );
      },
    );
  }

  Widget _buildBadge(Participant participant) {
    if (participant.isWinner) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'WINNER',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      );
    }
    if (participant.isPreselected) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.deepOrange,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'PRE-SELECTED',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      );
    }
    return const SizedBox();
  }
}
