import 'package:flutter/material.dart';
import 'package:raffle/features/raffles/domain/entities/ticket.dart';
import 'package:raffle/features/raffles/domain/entities/raffle.dart';

class TicketModal extends StatefulWidget {
  final Ticket ticket;
  final void Function(Ticket ticket) onSubmit;
  final VoidCallback onClose;
  final bool isSubmitting;
  final Raffle? raffle;

  const TicketModal({
    super.key,
    required this.ticket,
    required this.onSubmit,
    required this.onClose,
    this.isSubmitting = false,
    this.raffle,
  });

  @override
  State<TicketModal> createState() => _TicketModalState();
}

class _TicketModalState extends State<TicketModal> {
  late String _status;
  final _nameCtrl = TextEditingController();
  final _contactCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Map<String, String> _errors = {};

  @override
  void initState() {
    super.initState();
    _status = widget.ticket.status;
    _nameCtrl.text = widget.ticket.buyerName ?? '';
    _contactCtrl.text = widget.ticket.buyerContact ?? '';
  }

  void _save() {
    if (_validate()) {
      widget.onSubmit(
        widget.ticket.copyWith(
          status: _status,
          buyerName: _status == 'available' ? null : _nameCtrl.text.trim(),
          buyerContact: _status == 'available' ? null : _contactCtrl.text.trim(),
        ),
      );
    }
  }

  bool _validate() {
    if (_status != 'available') {
      _errors = {};
      if (_nameCtrl.text.trim().isEmpty) {
        setState(() {
          _errors['name'] = 'El nombre del comprador es obligatorio';
        });
      }
      if (_contactCtrl.text.trim().isEmpty) {
        setState(() {
          _errors['contact'] = 'La información de contacto es obligatoria';
        });
      }
      return _errors.isEmpty;
    }
    return true;
  }

  // Obtiene el color para el estado del ticket
  Color _getStatusColor(String status) {
    switch (status) {
      case 'sold':
        return Colors.red.shade500;
      case 'reserved':
        return Colors.orange.shade400;
      case 'available':
        return Colors.green.shade500;
      default:
        return Colors.grey;
    }
  }

  // Obtiene el texto para el botón según el estado
  String _getButtonText() {
    switch (_status) {
      case 'sold':
        return 'Marcar como Vendido';
      case 'reserved':
        return 'Reservar Ticket';
      case 'available':
        return 'Confirmar Cancelación';
      default:
        return 'Guardar Cambios';
    }
  }

  // Widget para botón de estado
  Widget _statusButton(String value, Color color) {
    final isSelected = _status == value;
    String label;
    IconData icon;
    
    switch (value) {
      case 'sold':
        label = 'VENDIDO';
        icon = Icons.shopping_cart;
        break;
      case 'reserved':
        label = 'RESERVADO';
        icon = Icons.bookmark;
        break;
      case 'available':
        label = 'DISPONIBLE';
        icon = Icons.check_circle;
        break;
      default:
        label = value.toUpperCase();
        icon = Icons.circle;
    }
    
    return Expanded(
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? color : Colors.grey[800],
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          elevation: isSelected ? 6 : 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () => setState(() => _status = value),
        icon: Icon(icon, size: 18),
        label: Text(
          label,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isCurrentlySoldOrReserved = 
        widget.ticket.status == 'sold' || widget.ticket.status == 'reserved';
    
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 8,
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Ticket #${widget.ticket.number}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  IconButton(
                    onPressed: widget.onClose,
                    icon: const Icon(Icons.close),
                    splashRadius: 20,
                  ),
                ],
              ),
              const Divider(height: 24),
              
              // Si está vendido o reservado, mostrar información actual
              if (isCurrentlySoldOrReserved && _status != 'available') ...[
                Row(
                  children: [
                    Text(
                      'Estado Actual:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(widget.ticket.status),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        widget.ticket.status == 'sold' ? 'Vendido' : 'Reservado',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Comprador Actual:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.ticket.buyerName ?? '',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.ticket.buyerContact ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                // Botones de acción específicos para tickets ya vendidos/reservados
                if (widget.ticket.status == 'reserved')
                  ElevatedButton.icon(
                    onPressed: () => setState(() => _status = 'sold'),
                    icon: const Icon(Icons.shopping_cart),
                    label: const Text('Convertir a Vendido'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () => setState(() => _status = 'available'),
                  icon: const Icon(Icons.cancel),
                  label: const Text('Cancelar Venta/Reserva'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ] else ...[
                // Selección de estado para tickets nuevos o cuando se cambia a disponible
                const Text(
                  'Selecciona un estado:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _statusButton('sold', Colors.red.shade500),
                    const SizedBox(width: 8),
                    _statusButton('reserved', Colors.orange.shade400),
                    const SizedBox(width: 8),
                    _statusButton('available', Colors.green.shade500),
                  ],
                ),
              ],
              
              const SizedBox(height: 20),
              
              // Formulario para tickets vendidos o reservados
              if (_status != 'available') ...[
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Información del comprador',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _nameCtrl,
                        decoration: InputDecoration(
                          labelText: 'Nombre del comprador',
                          prefixIcon: const Icon(Icons.person),
                          errorText: _errors['name'],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.grey.withOpacity(0.1),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _contactCtrl,
                        decoration: InputDecoration(
                          labelText: 'Información de contacto',
                          prefixIcon: const Icon(Icons.phone),
                          errorText: _errors['contact'],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.grey.withOpacity(0.1),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              
              const SizedBox(height: 24),
              
              // Botón de guardar
              ElevatedButton.icon(
                onPressed: widget.isSubmitting ? null : _save,
                icon: widget.isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Icon(
                        _status == 'available'
                            ? Icons.check_circle
                            : _status == 'sold'
                                ? Icons.shopping_cart
                                : Icons.bookmark,
                      ),
                label: Text(_getButtonText()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getStatusColor(_status),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

