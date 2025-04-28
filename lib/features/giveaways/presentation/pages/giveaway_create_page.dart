import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/giveaway_bloc.dart';

class GiveawayCreatePage extends StatefulWidget {
  const GiveawayCreatePage({super.key});

  @override
  State<GiveawayCreatePage> createState() => _GiveawayCreatePageState();
}

class _GiveawayCreatePageState extends State<GiveawayCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _drawDate;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final bloc = context.read<GiveawayBloc>();

      bloc.add(CreateGiveawayEvent(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        drawDate: _drawDate!,
        status: 'pending',
      ));

      Navigator.pop(context); // Volver a la lista
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Giveaway'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(
                controller: _nameController,
                label: 'Giveaway Name',
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
              _buildTextField(
                controller: _descriptionController,
                label: 'Description',
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              const Text('Draw Date',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _pickDate,
                icon: const Icon(Icons.date_range),
                label: Text(_drawDate == null
                    ? 'Pick a date'
                    : '${_drawDate!.toLocal()}'.split(' ')[0]),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.add),
                label: const Text('Create Giveaway'),
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
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        validator: validator,
        maxLines: maxLines,
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
