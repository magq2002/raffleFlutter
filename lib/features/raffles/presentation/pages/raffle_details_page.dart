import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:raffle/features/raffles/domain/entities/raffle.dart';

import '../../domain/entities/ticket.dart';
import '../bloc/raffle_cubit.dart';
import '../bloc/raffle_state.dart';
import '../widgets/financial_summary.dart';
import '../widgets/status_modal.dart';
import '../widgets/ticket_grid.dart';
import '../widgets/ticket_info_modal.dart';
import '../widgets/ticket_modal.dart';

class RaffleDetailsPage extends StatefulWidget {
  const RaffleDetailsPage({super.key});

  @override
  State<RaffleDetailsPage> createState() => _RaffleDetailsPageState();
}

class _RaffleDetailsPageState extends State<RaffleDetailsPage> {
  Ticket? selectedTicket;
  bool showInfoModal = false;
  bool showEditModal = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RaffleCubit, RaffleState>(
      builder: (context, state) {
        if (state.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.raffle == null) {
          return const Scaffold(
            body: Center(child: Text('No raffle data found')),
          );
        }

        final raffle = state.raffle!;
        final tickets = state.tickets;
        final financials = _calculateFinancials(raffle, tickets);

        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(raffle.name, style: const TextStyle(fontSize: 18)),
                Text('#${raffle.lotteryNumber}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
            actions: [
              TextButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => StatusModal(
                      currentStatus: raffle.status,
                      onSelect: (newStatus) {
                        context
                            .read<RaffleCubit>()
                            .updateRaffleStatus(newStatus);
                        Navigator.pop(context);
                      },
                      onClose: () => Navigator.pop(context),
                    ),
                  );
                },
                icon: const Icon(Icons.edit, color: Colors.white),
                label: Text(
                  raffle.status.toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
            backgroundColor: Colors.black,
          ),
          backgroundColor: const Color(0xFF121212),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                FinancialSummary(financials: financials),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _statCard('Price', '\$${raffle.price}', Colors.greenAccent),
                    _statCard('Total', raffle.totalTickets.toString(),
                        Colors.blueAccent),
                    _statCard('Sold', financials['soldTickets'].toString(),
                        Colors.redAccent),
                  ],
                ),
                const SizedBox(height: 16),
                _buildLegend(financials),
                const SizedBox(height: 16),
                TicketGrid(
                  tickets: tickets,
                  onTap: (ticket) {
                    setState(() {
                      selectedTicket = ticket;
                      showInfoModal = true;
                    });
                  },
                ),
              ],
            ),
          ),
          floatingActionButton: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TicketInfoModal(
                ticket: selectedTicket,
                visible: showInfoModal,
                onClose: () {
                  setState(() {
                    showInfoModal = false;
                    selectedTicket = null;
                  });
                },
                onEdit: () {
                  setState(() {
                    showInfoModal = false;
                    showEditModal = true;
                  });
                },
              ),
              TicketModal(
                ticket: selectedTicket,
                visible: showEditModal,
                onClose: () {
                  setState(() {
                    showEditModal = false;
                    selectedTicket = null;
                  });
                },
                onUpdate: (ticketId,
                    {required status, buyerName, buyerContact}) async {
                  context.read<RaffleCubit>().updateTicket(
                        ticketId,
                        status: status,
                        buyerName: buyerName,
                        buyerContact: buyerContact,
                      );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _statCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1e1e1e),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 4),
            Text(label,
                style: const TextStyle(color: Colors.white60, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(Map<String, dynamic> financials) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _legendItem('Available', Colors.green, financials['availableTickets']),
        _legendItem('Reserved', Colors.orange, financials['reservedTickets']),
        _legendItem('Sold', Colors.red, financials['soldTickets']),
      ],
    );
  }

  Widget _legendItem(String label, Color color, int count) {
    return Row(
      children: [
        Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(6))),
        const SizedBox(width: 6),
        Text('$label ($count)',
            style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  Map<String, dynamic> _calculateFinancials(
      Raffle raffle, List<Ticket> tickets) {
    final sold = tickets.where((t) => t.status == 'sold').length;
    final reserved = tickets.where((t) => t.status == 'reserved').length;
    final available = tickets.where((t) => t.status == 'available').length;

    return {
      'collectedAmount': sold * raffle.price,
      'pendingAmount': reserved * raffle.price,
      'remainingAmount': available * raffle.price,
      'totalAmount': raffle.totalTickets * raffle.price,
      'soldTickets': sold,
      'reservedTickets': reserved,
      'availableTickets': available,
    };
  }
}
