import 'package:flutter/material.dart';
import '../../domain/entities/ticket.dart';

class TicketGrid extends StatelessWidget {
  final List<Ticket> tickets;

  const TicketGrid({super.key, required this.tickets});

  @override
  Widget build(BuildContext context) {
    const int columns = 10;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tickets.map((ticket) {
        return Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _getColor(ticket.status),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            ticket.number.toString(),
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        );
      }).toList(),
    );
  }

  Color _getColor(String status) {
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
