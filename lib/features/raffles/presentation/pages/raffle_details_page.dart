import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raffle/features/raffles/domain/entities/ticket.dart';
import 'package:raffle/features/raffles/domain/entities/raffle.dart';
import 'package:raffle/features/raffles/presentation/bloc/details/raffle_details_bloc.dart';
import 'package:raffle/features/raffles/presentation/bloc/details/raffle_details_event.dart';
import 'package:raffle/features/raffles/presentation/bloc/details/raffle_details_state.dart';
import 'package:raffle/features/raffles/presentation/widgets/status_modal.dart';
import 'package:raffle/features/raffles/presentation/widgets/ticket_info_modal.dart';
import 'package:raffle/features/raffles/presentation/widgets/ticket_modal.dart';
import 'package:raffle/features/raffles/presentation/widgets/ticket_grid.dart';
import 'package:raffle/features/raffles/presentation/widgets/financial_summary.dart';

class RaffleDetailsPage extends StatefulWidget {
  final int raffleId;

  const RaffleDetailsPage({super.key, required this.raffleId});

  @override
  State<RaffleDetailsPage> createState() => _RaffleDetailsPageState();
}

class _RaffleDetailsPageState extends State<RaffleDetailsPage> {
  bool showStatusModal = false;
  bool showDeleteConfirm = false;
  Raffle? raffle;

  @override
  void initState() {
    super.initState();
    context.read<RaffleDetailsBloc>().add(LoadRaffleDetails(widget.raffleId));
  }

  void _handleStatusChange(String newStatus) {
    context.read<RaffleDetailsBloc>().add(
          ChangeRaffleStatus(
            raffleId: widget.raffleId,
            newStatus: newStatus,
          ),
        );
    setState(() => showStatusModal = false);
  }

  void _handleTicketUpdate(Ticket ticket) {
    context.read<RaffleDetailsBloc>().add(EditTicket(ticket));
  }

  void _handleDeleteRaffle() {
    context.read<RaffleDetailsBloc>().add(DeleteRaffle(widget.raffleId));
    Navigator.of(context).pop(); // vuelve a la lista
  }

  void _openTicketInfoModal(Ticket ticket) {
    if (raffle == null) return;
    
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => TicketInfoModal(
        ticket: ticket,
        raffle: raffle!,
        onClose: () => Navigator.of(context).pop(),
        onEdit: () {
          Navigator.of(context).pop(); // cerrar InfoModal
          _openEditModal(ticket); // abrir BottomSheet
        },
      ),
    );
  }

  void _openEditModal(Ticket ticket) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TicketModal(
        ticket: ticket,
        onSubmit: (updatedTicket) {
          Navigator.of(context).pop();
          _handleTicketUpdate(updatedTicket);
        },
        onClose: () => Navigator.of(context).pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<RaffleDetailsBloc, RaffleDetailsState>(
        builder: (context, state) {
          if (state is RaffleDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is RaffleDetailsLoaded) {
            raffle = state.raffle;
            final tickets = state.tickets;

            return Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      pinned: true,
                      expandedHeight: 160,
                      flexibleSpace: FlexibleSpaceBar(
                        title: Text(raffle!.name),
                        background: Container(color: Colors.deepPurple),
                      ),
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.sync_alt),
                          onPressed: () =>
                              setState(() => showStatusModal = true),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                    SliverToBoxAdapter(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              FinancialSummary(
                                raffle: raffle!,
                                tickets: tickets,
                              ),
                              const SizedBox(height: 16),
                              TicketGrid(
                                tickets: tickets,
                                onTap: _openTicketInfoModal,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (raffle!.status == 'expired')
                  Positioned(
                    bottom: 24,
                    left: 16,
                    right: 16,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () => setState(() => showDeleteConfirm = true),
                      icon: const Icon(Icons.delete, color: Colors.white),
                      label: const Text('Delete Raffle',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                if (showStatusModal)
                  StatusModal(
                    currentStatus: raffle!.status,
                    onSelect: _handleStatusChange,
                    onClose: () => setState(() => showStatusModal = false),
                  ),
                if (showDeleteConfirm)
                  AlertDialog(
                    title: const Text('Confirm Deletion'),
                    content: const Text(
                        'Are you sure you want to delete this raffle?'),
                    actions: [
                      TextButton(
                        onPressed: () =>
                            setState(() => showDeleteConfirm = false),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: _handleDeleteRaffle,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
              ],
            );
          }

          if (state is RaffleDetailsError) {
            return Center(child: Text('Error: ${state.message}'));
          }

          return const Center(child: Text('Something went wrong'));
        },
      ),
    );
  }
}
