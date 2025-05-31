import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:raffle/features/raffles/presentation/bloc/raffle_bloc.dart';
import 'package:raffle/features/raffles/presentation/bloc/raffle_event.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/keyboard_dismissible.dart';

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

  DateTime? _drawDate;
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
      context.read<RaffleBloc>().add(
            CreateRaffle(
              name: _nameController.text.trim(),
              lotteryNumber: _lotteryNumberController.text.trim(),
              price: double.parse(_priceController.text.trim()),
              totalTickets: int.parse(_totalTicketsController.text.trim()),
              drawDate: _drawDate!,
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
        title: const Text('🎟️ Crear Rifa'),
        centerTitle: true,
        elevation: 2,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(16),
          elevation: 12,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: KeyboardDismissible(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    const Text(
                      'Nueva Rifa',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    _buildTextField(
                      controller: _nameController,
                      label: 'Nombre de la Rifa',
                      icon: Icons.title,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Campo obligatorio'
                          : null,
                    ),
                    _buildTextField(
                      controller: _lotteryNumberController,
                      label: 'Nombre de Lotería',
                      icon: Icons.confirmation_number,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Campo obligatorio'
                          : null,
                    ),
                    _buildTextField(
                      controller: _priceController,
                      label: 'Precio del Boleto',
                      icon: Icons.attach_money,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        final parsed = double.tryParse(value ?? '');
                        if (parsed == null || parsed <= 0)
                          return 'Precio inválido';
                        return null;
                      },
                    ),
                    _buildTextField(
                      controller: _totalTicketsController,
                      label: 'Cantidad Total de Boletos',
                      icon: Icons.format_list_numbered,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        final parsed = int.tryParse(value ?? '');
                        if (parsed == null || parsed <= 0)
                          return 'Cantidad inválida';
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text('Fecha del sorteo',
                        style:
                            TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: _pickDate,
                      icon: const Icon(Icons.date_range),
                      label: Text(_drawDate == null
                          ? 'Seleccionar fecha'
                          : '${_drawDate!.toLocal()}'.split(' ')[0]),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.image),
                      label: const Text('Seleccionar imagen (opcional)'),
                    ),
                    if (_selectedImage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(_selectedImage!, height: 150),
                        ),
                      ),
                    const SizedBox(height: 30),
                    ElevatedButton.icon(
                      onPressed: _submit,
                      icon: const Icon(Icons.check),
                      label: const Text('Crear Rifa'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: Colors.greenAccent.shade100.withOpacity(0.3),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() {
        _drawDate = picked;
      });
    }
  }
}
