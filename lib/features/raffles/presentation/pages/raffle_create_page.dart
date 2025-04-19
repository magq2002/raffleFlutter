import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:raffle/features/raffles/presentation/bloc/raffle_bloc.dart';
import 'package:raffle/features/raffles/presentation/bloc/raffle_event.dart';

class RaffleCreatePage extends StatefulWidget {
  const RaffleCreatePage({super.key});

  @override
  State<RaffleCreatePage> createState() => _RaffleCreatePageState();
}

class _RaffleCreatePageState extends State<RaffleCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _lotteryNumberController = TextEditingController();
  final _priceController = TextEditingController();
  final _totalTicketsController = TextEditingController();

  File? _selectedImage;

  @override
  void dispose() {
    _nameController.dispose();
    _lotteryNumberController.dispose();
    _priceController.dispose();
    _totalTicketsController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final bloc = context.read<RaffleBloc>();

      bloc.add(
        CreateRaffle(
          name: _nameController.text.trim(),
          lotteryNumber: _lotteryNumberController.text.trim(),
          price: double.parse(_priceController.text.trim()),
          totalTickets: int.parse(_totalTicketsController.text.trim()),
          imagePath: _selectedImage?.path,
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Raffle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(
                controller: _nameController,
                label: 'Raffle Name',
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
              _buildTextField(
                controller: _lotteryNumberController,
                label: 'Lottery Number',
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
              _buildTextField(
                controller: _priceController,
                label: 'Ticket Price',
                keyboardType: TextInputType.number,
                validator: (value) {
                  final parsed = double.tryParse(value ?? '');
                  if (parsed == null || parsed <= 0) return 'Invalid price';
                  return null;
                },
              ),
              _buildTextField(
                controller: _totalTicketsController,
                label: 'Total Tickets',
                keyboardType: TextInputType.number,
                validator: (value) {
                  final parsed = int.tryParse(value ?? '');
                  if (parsed == null || parsed <= 0) return 'Invalid quantity';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: const Text('Select Image (optional)'),
              ),
              if (_selectedImage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Image.file(_selectedImage!, height: 150),
                ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.add),
                label: const Text('Create Raffle'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        keyboardType: keyboardType,
        validator: validator,
      ),
    );
  }
}
