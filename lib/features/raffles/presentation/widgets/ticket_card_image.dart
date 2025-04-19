import 'package:flutter/material.dart';
import '../../domain/entities/ticket.dart';

class TicketCardImage extends StatelessWidget {
  final Ticket ticket;

  const TicketCardImage({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🎫 TICKET DE RIFA', style: TextStyle(fontSize: 20)),
          const SizedBox(height: 8),
          Text('Número: ${ticket.number}',
              style: const TextStyle(fontSize: 16)),
          Text('Estado: ${ticket.status}'),
          if (ticket.buyerName != null) Text('Comprador: ${ticket.buyerName}'),
          if (ticket.buyerContact != null)
            Text('Contacto: ${ticket.buyerContact}'),
        ],
      ),
    );
  }
}
