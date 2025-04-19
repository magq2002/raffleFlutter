import 'package:flutter/material.dart';
import 'package:raffle/features/raffles/domain/entities/ticket.dart';

class TicketModal extends StatefulWidget {
  final Ticket ticket;
  final void Function(Ticket ticket) onSubmit;
  final VoidCallback onClose;

  const TicketModal({
    super.key,
    required this.ticket,
    required this.onSubmit,
    required this.onClose,
  });

  @override
  State<TicketModal> createState() => _TicketModalState();
}

class _TicketModalState extends State<TicketModal> {
  late String _status;
  final _nameCtrl = TextEditingController();
  final _contactCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _status = widget.ticket.status;
    _nameCtrl.text = widget.ticket.buyerName ?? '';
    _contactCtrl.text = widget.ticket.buyerContact ?? '';
  }

  void _save() {
    widget.onSubmit(
      widget.ticket.copyWith(
        status: _status,
        buyerName: _status == 'available' ? null : _nameCtrl.text.trim(),
        buyerContact: _status == 'available' ? null : _contactCtrl.text.trim(),
      ),
    );
  }

  Widget _statusButton(String value, Color color) {
    final isSelected = _status == value;
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? color : Colors.grey[800],
          foregroundColor: Colors.white,
        ),
        onPressed: () => setState(() => _status = value),
        child: Text(
          value.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Wrap(
        children: [
          Center(
            child: Text(
              'Edit Ticket #${widget.ticket.number}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _statusButton('available', Colors.green),
              const SizedBox(width: 8),
              _statusButton('reserved', Colors.orange),
              const SizedBox(width: 8),
              _statusButton('sold', Colors.red),
            ],
          ),
          const SizedBox(height: 16),
          if (_status != 'available') ...[
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Buyer Name'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _contactCtrl,
              decoration: const InputDecoration(labelText: 'Buyer Contact'),
            ),
          ],
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: const Text('Save Changes'),
            ),
          ),
        ],
      ),
    );
  }
}
