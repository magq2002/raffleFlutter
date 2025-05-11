import 'package:flutter/material.dart';

class GiveawayDescriptionWidget extends StatelessWidget {
  final String description;

  const GiveawayDescriptionWidget({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[850],
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          description,
          style: const TextStyle(color: Colors.white70),
        ),
      ),
    );
  }
}
