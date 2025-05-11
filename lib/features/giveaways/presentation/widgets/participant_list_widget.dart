import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/participant.dart';
import '../bloc/participant_bloc.dart';

class ParticipantListWidget extends StatelessWidget {
  final int giveawayId;

  const ParticipantListWidget({super.key, required this.giveawayId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ParticipantBloc, ParticipantState>(
      builder: (context, state) {
        if (state is ParticipantLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ParticipantLoaded) {
          final participants = List.from(state.participants)
            ..sort((a, b) {
              int getRank(Participant p) {
                if (p.award?.toLowerCase() == 'oro') return 0;
                if (p.award?.toLowerCase() == 'plata') return 1;
                if (p.award?.toLowerCase() == 'bronce') return 2;
                if (p.award?.toLowerCase() == 'reconocimiento') return 3;
                return 4;
              }

              return getRank(a).compareTo(getRank(b));
            });

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: participants.length,
            itemBuilder: (context, index) =>
                _buildParticipantItem(context, participants[index]),
          );
        } else if (state is ParticipantError) {
          return Center(child: Text('❌ ${state.message}'));
        } else {
          return const Center(child: Text('No hay participantes aún.'));
        }
      },
    );
  }

  Widget _buildParticipantItem(BuildContext context, Participant participant) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(participant.name),
        subtitle: Text(participant.contact),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (participant.award?.toLowerCase() == 'oro')
              const Icon(Icons.emoji_events, color: Colors.amber),
            if (participant.award?.toLowerCase() == 'plata')
              const Icon(Icons.emoji_events, color: Colors.grey),
            if (participant.award?.toLowerCase() == 'bronce')
              const Icon(Icons.emoji_events, color: Colors.brown),
            if (participant.award?.toLowerCase() == 'reconocimiento')
              const Icon(Icons.star, color: Colors.blueAccent),
            if (participant.isPreselected && participant.award == null)
              const Padding(
                padding: EdgeInsets.only(left: 4),
                child: Icon(Icons.check_circle, color: Colors.blueAccent),
              ),
          ],
        ),
      ),
    );
  }
}
