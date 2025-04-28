import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/giveaway.dart';
import '../bloc/participant_bloc.dart';
import '../widgets/giveaway_description_widget.dart';
import '../widgets/giveaway_stats_widget.dart';
import '../widgets/giveaway_status_widget.dart';
import '../widgets/participant_list_widget.dart';
import '../widgets/preselect_participants_button.dart';
import '../widgets/update_giveaway_status_button.dart';

class GiveawayDetailsPage extends StatelessWidget {
  final Giveaway giveaway;

  const GiveawayDetailsPage({super.key, required this.giveaway});

  @override
  Widget build(BuildContext context) {
    context
        .read<ParticipantBloc>()
        .add(LoadParticipants(giveawayId: giveaway.id!));

    return Scaffold(
      appBar: AppBar(
        title: Text(giveaway.name),
        actions: [
          IconButton(
            onPressed: () => _showAddParticipantDialog(context),
            icon: const Icon(
              Icons.person_add,
              color: Colors.greenAccent,
            ),
            tooltip: 'Nuevo Participante',
          )
        ],
      ),
      body: BlocListener<ParticipantBloc, ParticipantState>(
        listener: (context, state) {
          if (state is WinnerSelected) {
            _showWinnerDialog(context, state.winner.name, state.winner.contact,
                state.winner.award);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('🏆 ¡Ganador seleccionado exitosamente!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              GiveawayDescriptionWidget(description: giveaway.description),
              GiveawayStatsWidget(giveawayId: giveaway.id!),
              GiveawayStatusWidget(giveaway: giveaway),
              ParticipantListWidget(giveawayId: giveaway.id!),
              const SizedBox(height: 20),
              PreselectParticipantsButton(
                onPreselect: (count) {
                  context.read<ParticipantBloc>().add(
                        PreselectParticipantsEvent(
                          giveawayId: giveaway.id!,
                          count: count,
                        ),
                      );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('🎯 Se preseleccionaron $count participantes'),
                      backgroundColor: Colors.blueAccent,
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  context.read<ParticipantBloc>().add(
                        DrawWinnerEvent(giveawayId: giveaway.id!),
                      );
                },
                icon: const Icon(Icons.casino),
                label: const Text('Sortear Ganador'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showWinnerDialog(BuildContext context, String winnerName,
      String winnerContact, String? award) {
    String awardTitle;
    Icon awardIcon;

    switch (award?.toLowerCase()) {
      case 'oro':
        awardTitle = '🏆 Ganador de Oro';
        awardIcon =
            const Icon(Icons.emoji_events, color: Colors.amber, size: 48);
        break;
      case 'plata':
        awardTitle = '🥈 Ganador de Plata';
        awardIcon =
            const Icon(Icons.emoji_events, color: Colors.grey, size: 48);
        break;
      case 'bronce':
        awardTitle = '🥉 Ganador de Bronce';
        awardIcon =
            const Icon(Icons.emoji_events, color: Colors.brown, size: 48);
        break;
      case 'reconocimiento':
        awardTitle = '🎖️ Reconocimiento Especial';
        awardIcon = const Icon(Icons.star, color: Colors.blueAccent, size: 48);
        break;
      default:
        awardTitle = '🎉 ¡Ganador!';
        awardIcon =
            const Icon(Icons.emoji_events, color: Colors.greenAccent, size: 48);
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Row(
          children: [
            awardIcon,
            const SizedBox(width: 10),
            Flexible(child: Text(awardTitle)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              winnerName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              winnerContact,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Cerrar'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _showAddParticipantDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController contactController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Agregar Participante'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: contactController,
              decoration: const InputDecoration(labelText: 'Contacto'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              final contact = contactController.text.trim();

              if (name.isEmpty || contact.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('⚠️ Por favor completa todos los campos'),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              } else {
                context.read<ParticipantBloc>().add(
                      AddParticipantEvent(
                        giveawayId: giveaway.id!,
                        name: name,
                        contact: contact,
                      ),
                    );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('✅ Participante agregado exitosamente'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }
}
