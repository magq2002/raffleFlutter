import 'package:flutter/material.dart';
import '../../domain/entities/ticket.dart';
import '../../domain/entities/raffle.dart';

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

    double percent(double amount) => total == 0 ? 0 : (amount / total * 100);

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
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _summaryBox('Collected', collected, percent(collected),
                  Colors.greenAccent),
              _summaryBox(
                  'Reserved', pending, percent(pending), Colors.orangeAccent),
              _summaryBox(
                  'Remaining', remaining, percent(remaining), Colors.grey),
            ],
          ),
          const SizedBox(height: 16),
          Stack(
            children: [
              Container(
                height: 8,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Row(
                children: [
                  _progressSegment(percent(collected), Colors.greenAccent),
                  _progressSegment(percent(pending), Colors.orangeAccent),
                ],
              ),
            ],
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
                fontWeight: FontWeight.bold, fontSize: 16, color: color)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white70)),
        Text('${percent.toStringAsFixed(1)}%',
            style: const TextStyle(fontSize: 12, color: Colors.white38)),
      ],
    );
  }

  Widget _progressSegment(double percent, Color color) {
    return Expanded(
      flex: (percent * 100).round(),
      child: Container(
        height: 8,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
