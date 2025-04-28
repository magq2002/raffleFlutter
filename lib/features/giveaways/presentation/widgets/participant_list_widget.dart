import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/participant.dart';
import '../bloc/participant_bloc.dart';

class ParticipantListWidget extends StatefulWidget {
  final int giveawayId;

  const ParticipantListWidget({super.key, required this.giveawayId});

  @override
  State<ParticipantListWidget> createState() => _ParticipantListWidgetState();
}

class _ParticipantListWidgetState extends State<ParticipantListWidget> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<Participant> _participants = [];

  @override
  void initState() {
    super.initState();
    context
        .read<ParticipantBloc>()
        .add(LoadParticipants(giveawayId: widget.giveawayId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ParticipantBloc, ParticipantState>(
      listener: (context, state) {
        if (state is ParticipantLoaded) {
          setState(() {
            _participants = List.from(state.participants)
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
          });
        }
      },
      builder: (context, state) {
        if (state is ParticipantLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (_participants.isEmpty) {
          return const Center(child: Text('No hay participantes aún.'));
        }

        return AnimatedList(
          key: _listKey,
          shrinkWrap: true,
          initialItemCount: _participants.length,
          itemBuilder: (context, index, animation) {
            final participant = _participants[index];
            return _buildParticipantItem(context, participant, animation);
          },
        );
      },
    );
  }

  Widget _buildParticipantItem(BuildContext context, Participant participant,
      Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
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
      ),
    );
  }
}
