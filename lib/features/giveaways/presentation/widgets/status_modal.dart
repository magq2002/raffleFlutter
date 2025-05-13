import 'package:flutter/material.dart';

class StatusModal extends StatelessWidget {
  final String currentStatus;
  final void Function(String) onSelect;
  final VoidCallback onClose;

  const StatusModal({
    super.key,
    required this.currentStatus,
    required this.onSelect,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Change Status',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            _statusButton('pending', context),
            const SizedBox(height: 8),
            _statusButton('completed', context),
            const SizedBox(height: 8),
            _statusButton('cancelled', context),
            const SizedBox(height: 16),
            TextButton(
              onPressed: onClose,
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusButton(String value, BuildContext context) {
    final isSelected = currentStatus == value;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.grey[700],
          foregroundColor: Colors.white,
        ),
        onPressed: () => onSelect(value),
        child: Text(
          value.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
