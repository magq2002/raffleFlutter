import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/participant.dart';

class GiveawayStats extends StatelessWidget {
  final List<Participant> participants;

  const GiveawayStats({super.key, required this.participants});

  @override
  Widget build(BuildContext context) {
    final preselected = participants.where((p) => p.isPreselected).length;
    final winners = participants.where((p) => p.isWinner).length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStat('Participants', participants.length.toString()),
        _buildStat('Pre-selected', preselected.toString()),
        _buildStat('Winners', winners.toString()),
      ],
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
