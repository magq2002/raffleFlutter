import 'package:flutter/material.dart';
import '../../domain/entities/giveaway.dart';
import '../bloc/giveaway_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GiveawayStatusWidget extends StatelessWidget {
  final Giveaway giveaway;

  const GiveawayStatusWidget({super.key, required this.giveaway});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GiveawayBloc, GiveawayState>(
      builder: (context, state) {
        final updatedGiveaway = (state is GiveawayLoaded)
            ? state.giveaways.firstWhere(
                (g) => g.id == giveaway.id,
                orElse: () => giveaway,
              )
            : giveaway;

        return Card(
          color: Theme.of(context).cardColor,
          margin: const EdgeInsets.symmetric(vertical: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Estado',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _translateStatus(updatedGiveaway.status),
                        style: TextStyle(
                          color: _getStatusColor(updatedGiveaway.status),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        context.read<GiveawayBloc>().add(
                              UpdateGiveawayStatusEvent(
                                giveawayId: giveaway.id!,
                                newStatus: value,
                              ),
                            );
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'pending',
                          child: Text('Pendiente'),
                        ),
                        const PopupMenuItem(
                          value: 'completed',
                          child: Text('Completado'),
                        ),
                        const PopupMenuItem(
                          value: 'cancelled',
                          child: Text('Cancelado'),
                        ),
                      ],
                      child: const Icon(Icons.more_vert),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'pending':
      default:
        return Colors.orange;
    }
  }

  String _translateStatus(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return 'Completado';
      case 'cancelled':
        return 'Cancelado';
      case 'pending':
      default:
        return 'Pendiente';
    }
  }
}
