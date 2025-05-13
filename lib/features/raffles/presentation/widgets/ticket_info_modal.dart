import 'package:flutter/material.dart';
import 'package:raffle/features/raffles/domain/entities/ticket.dart';
import 'package:raffle/features/raffles/domain/entities/raffle.dart';
import 'ticket_export_widget.dart';

class TicketInfoModal extends StatefulWidget {
  const TicketInfoModal({
    Key? key,
    required this.ticket,
    required this.raffle,
    required this.onClose,
    required this.onEdit,
  }) : super(key: key);
  final Ticket? ticket;
  final Raffle raffle;
  final VoidCallback onClose;
  final VoidCallback onEdit;

  @override
  State<TicketInfoModal> createState() => _TicketInfoModalState();
}

class _TicketInfoModalState extends State<TicketInfoModal> {
  @override
  Widget build(BuildContext context) {
    if (widget.ticket == null) return const SizedBox.shrink();

    return Dialog(
      backgroundColor: const Color(0xFF1e1e1e),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Título y botón cerrar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Detalles del Ticket',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: widget.onClose,
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Widget de exportación (vista previa con QR, número, estado...)
              TicketExportWidget(
                ticket: widget.ticket!,
                raffle: widget.raffle,
              ),
              const SizedBox(height: 12),
              // Acciones adicionales: Editar
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                    onPressed: widget.onEdit,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.orange,
                        side: const BorderSide(color: Colors.orange),
                      ),
                      icon: const Icon(Icons.edit),
                      label: const Text('Editar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
