import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raffle/features/raffles/domain/entities/ticket.dart';
import 'package:raffle/features/raffles/domain/entities/raffle.dart';
import 'package:raffle/features/raffles/presentation/bloc/details/raffle_details_bloc.dart';
import 'package:raffle/features/raffles/presentation/bloc/details/raffle_details_event.dart';
import 'package:raffle/features/raffles/presentation/bloc/details/raffle_details_state.dart';
import 'package:raffle/features/raffles/presentation/bloc/raffle_bloc.dart';
import 'package:raffle/features/raffles/presentation/bloc/raffle_event.dart' as raffle_events;
import 'package:raffle/features/raffles/presentation/widgets/status_modal.dart';
import 'package:raffle/features/raffles/presentation/widgets/ticket_info_modal.dart';
import 'package:raffle/features/raffles/presentation/widgets/ticket_modal.dart';
import 'package:raffle/features/raffles/presentation/widgets/ticket_grid.dart';
import 'package:raffle/features/raffles/presentation/widgets/financial_summary.dart';
import 'package:raffle/features/raffles/presentation/pages/raffle_edit_page.dart';
import 'package:raffle/features/raffles/presentation/pages/raffle_share_page.dart';
import 'package:raffle/features/raffles/presentation/widgets/buyers_summary.dart';
import 'package:raffle/features/raffles/presentation/pages/buyers_list_page.dart';
import 'dart:io';

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
  int currentPage = 0;

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
          print('🔄 Ticket actualizado en el modal:');
          print('ID: ${updatedTicket.id}');
          print('Estado: ${updatedTicket.status}');
          print('Comprador: ${updatedTicket.buyerName}');
          print('Contacto: ${updatedTicket.buyerContact}');
          
          Navigator.of(context).pop(); // Cerrar el modal
          _handleTicketUpdate(updatedTicket);
        },
        onClose: () => Navigator.of(context).pop(),
      ),
    );
  }

  void _openShareModal() {
    if (raffle == null) return;
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RaffleSharePage(
          raffle: raffle!,
          tickets: (context.read<RaffleDetailsBloc>().state as RaffleDetailsLoaded).tickets,
          currentPage: currentPage,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(raffle?.name ?? ''),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (raffle?.status != 'expired') ...[
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: _openShareModal,
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: context.read<RaffleBloc>(),
                      child: RaffleEditPage(raffle: raffle!),
                    ),
                  ),
                );
                // Recargar los detalles después de editar
                if (mounted) {
                  context.read<RaffleDetailsBloc>().add(
                        LoadRaffleDetails(widget.raffleId),
                      );
                }
              },
            ),
          ],
          IconButton(
            icon: const Icon(Icons.sync_alt),
            onPressed: () => setState(() => showStatusModal = true),
          ),
          const SizedBox(width: 8),
        ],
      ),
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
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: 280,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          image: raffle!.imagePath != null
                              ? DecorationImage(
                                  image: FileImage(File(raffle!.imagePath!)),
                                  fit: BoxFit.cover,
                                  alignment: Alignment.center,
                                )
                              : null,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.4),
                                Colors.black.withOpacity(0.1),
                              ],
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Text(
                                raffle!.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(0, 2),
                                      blurRadius: 4,
                                      color: Colors.black38,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            FinancialSummary(
                              raffle: raffle!,
                              tickets: tickets,
                            ),
                            BuyersSummary(
                              tickets: tickets,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BuyersListPage(
                                      raffle: raffle!,
                                      tickets: tickets,
                                    ),
                                  ),
                                );
                              },
                            ),
                            TicketGrid(
                              tickets: tickets,
                              raffle: raffle!,
                              onTap: _openTicketInfoModal,
                              showRandomButton: raffle!.status == 'active',
                              onPageChanged: (page) => setState(() => currentPage = page),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
