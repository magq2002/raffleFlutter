import 'package:flutter/material.dart';
import '../../domain/entities/ticket.dart';

class TicketModal extends StatefulWidget {
  final Ticket? ticket;
  final bool visible;
  final void Function() onClose;
  final Future<void> Function(
    int ticketId, {
    required String status,
    String? buyerName,
    String? buyerContact,
  }) onUpdate;

  const TicketModal({
    super.key,
    required this.ticket,
    required this.visible,
    required this.onClose,
    required this.onUpdate,
  });

  @override
  State<TicketModal> createState() => _TicketModalState();
}

class _TicketModalState extends State<TicketModal> {
  String status = 'sold';
  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  bool isSubmitting = false;
  String? error;

  @override
  void initState() {
    super.initState();
    if (widget.ticket != null) {
      status =
          widget.ticket!.status == 'available' ? 'sold' : widget.ticket!.status;
      nameController.text = widget.ticket!.buyerName ?? '';
      contactController.text = widget.ticket!.buyerContact ?? '';
    }
  }

  @override
  void didUpdateWidget(covariant TicketModal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.ticket != oldWidget.ticket && widget.ticket != null) {
      status =
          widget.ticket!.status == 'available' ? 'sold' : widget.ticket!.status;
      nameController.text = widget.ticket!.buyerName ?? '';
      contactController.text = widget.ticket!.buyerContact ?? '';
    }
  }

  Future<void> _submit() async {
    if (widget.ticket == null) return;

    final buyerName = nameController.text.trim();
    final buyerContact = contactController.text.trim();

    if (status != 'available' && (buyerName.isEmpty || buyerContact.isEmpty)) {
      setState(() {
        error = 'Name and contact are required';
      });
      return;
    }

    setState(() {
      isSubmitting = true;
      error = null;
    });

    try {
      await widget.onUpdate(
        widget.ticket!.id,
        status: status,
        buyerName: status == 'available' ? null : buyerName,
        buyerContact: status == 'available' ? null : buyerContact,
      );
      widget.onClose();
    } catch (e) {
      setState(() {
        error = 'Failed to update ticket';
      });
    } finally {
      setState(() {
        isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.visible || widget.ticket == null)
      return const SizedBox.shrink();

    return Dialog(
      backgroundColor: const Color(0xFF1e1e1e),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Ticket #${widget.ticket!.number}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              IconButton(
                  onPressed: widget.onClose,
                  icon: const Icon(Icons.close, color: Colors.white)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _statusOption('sold', 'Sold'),
              const SizedBox(width: 8),
              _statusOption('reserved', 'Reserved'),
              const SizedBox(width: 8),
              _statusOption('available', 'Cancel Sale'),
            ],
          ),
          const SizedBox(height: 16),
          if (status != 'available') ...[
            _inputField('Buyer Name', nameController),
            _inputField('Buyer Contact', contactController),
          ],
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child:
                  Text(error!, style: const TextStyle(color: Colors.redAccent)),
            ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: isSubmitting ? null : _submit,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: isSubmitting
                ? const CircularProgressIndicator(color: Colors.black)
                : Text(
                    status == 'available'
                        ? 'Confirm Cancellation'
                        : status == 'sold'
                            ? 'Mark as Sold'
                            : 'Reserve Ticket',
                    style: const TextStyle(color: Colors.black),
                  ),
          )
        ]),
      ),
    );
  }

  Widget _statusOption(String value, String label) {
    final selected = status == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => status = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? Colors.greenAccent : const Color(0xFF333333),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(label,
                style: TextStyle(
                  color: selected ? Colors.black : Colors.white70,
                  fontWeight: FontWeight.bold,
                )),
          ),
        ),
      ),
    );
  }

  Widget _inputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: const Color(0xFF2a2a2a),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
