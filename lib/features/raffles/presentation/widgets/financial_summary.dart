import 'package:flutter/material.dart';

class FinancialSummary extends StatelessWidget {
  final Map<String, dynamic> financials;

  const FinancialSummary({super.key, required this.financials});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1e1e1e),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text(
            'Financial Summary',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildItem(
                  'Collected', financials['collectedAmount'], Colors.green),
              _buildItem(
                  'Reserved', financials['pendingAmount'], Colors.orange),
              _buildItem(
                  'Remaining', financials['remainingAmount'], Colors.grey),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItem(String label, double amount, Color color) {
    return Column(
      children: [
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
              color: color, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }
}
