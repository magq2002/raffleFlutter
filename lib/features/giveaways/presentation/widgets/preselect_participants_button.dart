import 'package:flutter/material.dart';

class PreselectParticipantsButton extends StatelessWidget {
  final void Function(int count) onPreselect;

  const PreselectParticipantsButton({super.key, required this.onPreselect});

  void _showPreselectDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Preselect Participants'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Number to preselect',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final count = int.tryParse(controller.text.trim());
              if (count != null && count > 0) {
                Navigator.pop(context);
                onPreselect(count);
              }
            },
            child: const Text('Preselect'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _showPreselectDialog(context),
      icon: const Icon(Icons.how_to_reg),
      label: const Text('Preselect Participants'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.greenAccent,
        foregroundColor: Colors.black,
      ),
    );
  }
}
