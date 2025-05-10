import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/data/database_cleaner.dart';
import '../bloc/raffle_bloc.dart';
import '../bloc/raffle_event.dart';

class TrashPage extends StatelessWidget {
  const TrashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.greenAccent.withOpacity(0.9),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.delete_forever, size: 64, color: Colors.white),
              const SizedBox(height: 16),
              const Text(
                '¿Limpiar todo?',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Esta acción eliminará permanentemente todos los datos almacenados.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.cleaning_services),
                label: const Text('Limpiar Base de Datos'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.greenAccent.shade700,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 12.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: () async {
                  await DatabaseCleaner.clearAllDatabases();
                  if (context.mounted) {
                    context.read<RaffleBloc>().add(LoadRaffles());
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Todas las bases de datos fueron limpiadas ✅')),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
