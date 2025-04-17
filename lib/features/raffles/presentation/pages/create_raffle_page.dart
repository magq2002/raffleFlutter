import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/raffle.dart';
import '../../domain/entities/ticket.dart';
import '../bloc/raffle_cubit.dart';
import 'raffle_details_page.dart';

class CreateRafflePage extends StatefulWidget {
  const CreateRafflePage({super.key});

  @override
  State<CreateRafflePage> createState() => _CreateRafflePageState();
}

class _CreateRafflePageState extends State<CreateRafflePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  final _priceController = TextEditingController();
  final _totalController = TextEditingController();

  bool _isSubmitting = false;

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    final raffle = Raffle(
      id: const Uuid().v4().hashCode, // id temporal basado en UUID
      name: _nameController.text.trim(),
      lotteryNumber: _numberController.text.trim(),
      price: double.parse(_priceController.text.trim()),
      totalTickets: int.parse(_totalController.text.trim()),
      status: 'active',
      deleted: false,
      deletedAt: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final tickets = List.generate(
      raffle.totalTickets,
      (i) => Ticket(
        id: i,
        number: i + 1,
        status: 'available',
        buyerName: null,
        buyerContact: null,
      ),
    );

    setState(() => _isSubmitting = true);

    context.read<RaffleCubit>().loadRaffle(raffle, tickets);

    // Navegar al detalle
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const RaffleDetailsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Create New Raffle'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(children: [
            _buildInput('Raffle Name', _nameController, validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Required';
              return null;
            }),
            _buildInput('Lottery Number', _numberController, validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Required';
              return null;
            }),
            _buildInput('Ticket Price (\$)', _priceController,
                keyboardType: TextInputType.number, validator: (v) {
              if (v == null ||
                  double.tryParse(v) == null ||
                  double.parse(v) <= 0) {
                return 'Enter a valid price';
              }
              return null;
            }),
            _buildInput('Total Tickets', _totalController,
                keyboardType: TextInputType.number, validator: (v) {
              if (v == null || int.tryParse(v) == null || int.parse(v) <= 0) {
                return 'Enter a valid number';
              }
              return null;
            }),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: _isSubmitting
                  ? const CircularProgressIndicator(color: Colors.black)
                  : const Text('Create Raffle',
                      style: TextStyle(color: Colors.black)),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller,
      {String? Function(String?)? validator, TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: const Color(0xFF1e1e1e),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        validator: validator,
      ),
    );
  }
}
