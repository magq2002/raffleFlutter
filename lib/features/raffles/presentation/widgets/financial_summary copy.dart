/* import 'package:flutter/material.dart';
import '../../domain/entities/raffle.dart';
import '../../domain/entities/ticket.dart';

class FinancialSummary extends StatelessWidget {
  final Raffle raffle;
  final List<Ticket> tickets;

  const FinancialSummary({
    super.key,
    required this.raffle,
    required this.tickets,
  });

  @override
  Widget build(BuildContext context) {
    final sold = tickets.where((t) => t.status == 'sold').length;
    final reserved = tickets.where((t) => t.status == 'reserved').length;
    final available = tickets.where((t) => t.status == 'available').length;

    final collected = sold * raffle.price;
    final pending = reserved * raffle.price;
    final remaining = available * raffle.price;
    final total = raffle.totalTickets * raffle.price;

    final totalTickets = raffle.totalTickets.toDouble();
    final percentSold = sold / totalTickets;
    final percentReserved = reserved / totalTickets;
    final percentAvailable = available / totalTickets;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1e1e1e),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Financial Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _summaryBox(
                  'Collected', collected, percentSold, Colors.greenAccent),
              _summaryBox(
                  'Reserved', pending, percentReserved, Colors.orangeAccent),
              _summaryBox(
                  'Remaining', remaining, percentAvailable, Colors.grey),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 8,
            child: Row(
              children: [
                _progressSegment(percentSold, Colors.greenAccent),
                _progressSegment(percentReserved, Colors.orangeAccent),
                _progressSegment(percentAvailable, Colors.grey),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text('Total: \$${total.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.white70),
              textAlign: TextAlign.right),
        ],
      ),
    );
  }

  Widget _summaryBox(String label, double value, double percent, Color color) {
    return Column(
      children: [
        Text('\$${value.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: color,
            )),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white70)),
        Text('${(percent * 100).toStringAsFixed(1)}%',
            style: const TextStyle(fontSize: 12, color: Colors.white38)),
      ],
    );
  }

  Widget _progressSegment(double percent, Color color) {
    if (percent <= 0) return const SizedBox.shrink();

    return Expanded(
      flex: (percent * 1000)
          .round(), // Multiplicamos por 1000 para mejor precisión
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
 */