import 'package:flutter/material.dart';
import '../../domain/entities/ticket.dart';

class TicketInfoModal extends StatelessWidget {
  final Ticket? ticket;
  final bool visible;
  final VoidCallback onClose;
  final VoidCallback onEdit;

  const TicketInfoModal({
    super.key,
    required this.ticket,
    required this.visible,
    required this.onClose,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    if (!visible || ticket == null) return const SizedBox.shrink();

    final bgColor = _statusColor(ticket!.status);

    return Dialog(
      backgroundColor: const Color(0xFF1e1e1e),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ticket #${ticket!.number}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: onClose,
                icon: const Icon(Icons.close, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              ticket!.status.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (ticket!.status != 'available') ...[
            _infoRow('Buyer', ticket!.buyerName ?? '—'),
            _infoRow('Contact', ticket!.buyerContact ?? '—'),
            const SizedBox(height: 16),
          ],
          ElevatedButton.icon(
            onPressed: onEdit,
            icon: const Icon(Icons.edit),
            label: Text(ticket!.status == 'available' ? 'Sell Ticket' : 'Edit'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          ),
        ]),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text('$label: ',
              style: const TextStyle(
                  color: Colors.grey, fontWeight: FontWeight.w500)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'sold':
        return Colors.red;
      case 'reserved':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }
}
