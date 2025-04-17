import 'package:flutter/material.dart';
import '../../domain/entities/raffle.dart';
import '../../domain/entities/ticket.dart';
import '../widgets/financial_summary.dart';
import '../widgets/ticket_grid.dart';
import '../widgets/status_modal.dart';

class RaffleDetailsPage extends StatefulWidget {
  final Raffle raffle;
  final List<Ticket> tickets;

  const RaffleDetailsPage({
    super.key,
    required this.raffle,
    required this.tickets,
  });

  @override
  State<RaffleDetailsPage> createState() => _RaffleDetailsPageState();
}

class _RaffleDetailsPageState extends State<RaffleDetailsPage> {
  late Raffle raffle;
  late List<Ticket> tickets;

  @override
  void initState() {
    super.initState();
    raffle = widget.raffle;
    tickets = widget.tickets;
  }

  void _showStatusModal() {
    showDialog(
      context: context,
      builder: (_) => StatusModal(
        currentStatus: raffle.status,
        onSelect: (newStatus) {
          setState(() {
            raffle = Raffle(
              id: raffle.id,
              name: raffle.name,
              lotteryNumber: raffle.lotteryNumber,
              price: raffle.price,
              totalTickets: raffle.totalTickets,
              status: newStatus,
              deleted: raffle.deleted,
              deletedAt: raffle.deletedAt,
              createdAt: raffle.createdAt,
              updatedAt: DateTime.now(),
            );
          });
          Navigator.pop(context);
        },
        onClose: () => Navigator.pop(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final financials = _calculateFinancials();

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
            onPressed: _showStatusModal,
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
                _statCard(
                    'Total', raffle.totalTickets.toString(), Colors.blueAccent),
                _statCard('Sold', financials['soldTickets'].toString(),
                    Colors.redAccent),
              ],
            ),
            const SizedBox(height: 16),
            _buildLegend(financials),
            const SizedBox(height: 16),
            TicketGrid(tickets: tickets),
          ],
        ),
      ),
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

  Map<String, dynamic> _calculateFinancials() {
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
