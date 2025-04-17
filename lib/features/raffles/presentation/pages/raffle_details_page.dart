import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/ticket.dart';
import '../../domain/entities/raffle.dart';
import '../bloc/raffle_cubit.dart';
import '../bloc/raffle_state.dart';
import '../widgets/ticket_grid.dart';
import '../widgets/status_modal.dart';
import '../widgets/ticket_info_modal.dart';
import '../widgets/ticket_modal.dart';
import '../widgets/financial_summary.dart';

class RaffleDetailsPage extends StatefulWidget {
  const RaffleDetailsPage({super.key});

  @override
  State<RaffleDetailsPage> createState() => _RaffleDetailsPageState();
}

class _RaffleDetailsPageState extends State<RaffleDetailsPage> {
  bool showStatusModal = false;
  Ticket? selectedTicket;
  bool showInfoModal = false;
  bool showEditModal = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RaffleCubit, RaffleState>(
      builder: (context, state) {
        final raffle = state.raffle;
        final tickets = state.tickets;

        if (state.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (raffle == null) {
          return const Scaffold(
            body: Center(child: Text('Raffle not found')),
          );
        }

        return Scaffold(
          backgroundColor: const Color(0xFF121212),
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(raffle.name),
                Text('#${raffle.lotteryNumber}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey))
              ],
            ),
            actions: [
              TextButton.icon(
                style: TextButton.styleFrom(
                  backgroundColor: _getStatusColor(raffle.status),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () => setState(() => showStatusModal = true),
                icon: const Icon(Icons.arrow_drop_down),
                label: Text(raffle.status.capitalize()),
              ),
              const SizedBox(width: 12),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FinancialSummary(raffle: raffle, tickets: tickets),
                const SizedBox(height: 16),
                _buildStats(raffle, tickets),
                const SizedBox(height: 16),
                _buildLegend(tickets),
                const SizedBox(height: 8),
                TicketGrid(
                  tickets: tickets,
                  onTap: (ticket) {
                    setState(() {
                      selectedTicket = ticket;
                      showInfoModal = true;
                    });
                  },
                ),
                if (raffle.status == 'expired')
                  Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.delete),
                      label: const Text(
                        'Move to Trash',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () => _confirmDelete(context),
                    ),
                  ),
              ],
            ),
          ),
          // Modals
          bottomSheet: showStatusModal
              ? StatusModal(
                  currentStatus: raffle.status,
                  onSelect: (newStatus) {
                    context.read<RaffleCubit>().updateRaffleStatus(newStatus);
                    setState(() => showStatusModal = false);
                  },
                  onClose: () => setState(() => showStatusModal = false),
                )
              : null,
        );
      },
    );
  }

  Widget _buildStats(Raffle raffle, List<Ticket> tickets) {
    final sold = tickets.where((t) => t.status == 'sold').length;
    final reserved = tickets.where((t) => t.status == 'reserved').length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _statCard('\$${raffle.price}', 'Price'),
        _statCard('${raffle.totalTickets}', 'Total Tickets'),
        _statCard('$sold', 'Sold'),
      ],
    );
  }

  Widget _buildLegend(List<Ticket> tickets) {
    final available = tickets.where((t) => t.status == 'available').length;
    final reserved = tickets.where((t) => t.status == 'reserved').length;
    final sold = tickets.where((t) => t.status == 'sold').length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _legendItem(Colors.green, 'Available ($available)'),
        _legendItem(Colors.orange, 'Reserved ($reserved)'),
        _legendItem(Colors.red, 'Sold ($sold)'),
      ],
    );
  }

  Widget _statCard(String value, String label) => Column(
        children: [
          Text(value,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.greenAccent)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.white54)),
        ],
      );

  Widget _legendItem(Color color, String label) => Row(
        children: [
          Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: Colors.white)),
        ],
      );

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return Colors.green;
      case 'inactive':
        return Colors.orange;
      case 'expired':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1e1e1e),
        title:
            const Text('Are you sure?', style: TextStyle(color: Colors.white)),
        content: const Text('This raffle will be moved to trash.',
            style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              Navigator.pop(context);
              await context.read<RaffleCubit>().deleteCurrentRaffle();
              Navigator.pop(context); // back to list
            },
            icon: const Icon(Icons.delete),
            label: const Text('Move to Trash'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ],
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() => isEmpty ? this : this[0].toUpperCase() + substring(1);
}
