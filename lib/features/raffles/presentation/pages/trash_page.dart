import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/data/database_cleaner.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/raffle_bloc.dart';
import '../bloc/raffle_event.dart';

class TrashPage extends StatelessWidget {
  const TrashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.red.shade800,
                Colors.red.shade600,
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Card(
            elevation: 0,
            color: Colors.transparent,
            margin: EdgeInsets.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.delete_forever,
                        size: 80,
                        color: Colors.white.withOpacity(0.15),
                      ),
                      const Icon(
                        Icons.delete_forever,
                        size: 70,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '¿Limpiar todo?',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Esta acción eliminará permanentemente todos los datos almacenados.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.cleaning_services),
                    label: const Text(
                      'Limpiar Base de Datos',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.red.shade700,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 14.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 8,
                      shadowColor: Colors.black.withOpacity(0.5),
                    ),
                    onPressed: () async {
                      // Mostrar un diálogo de confirmación
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Confirmar eliminación'),
                          content: const Text(
                              '¿Estás seguro de que quieres eliminar todos los datos? Esta acción no se puede deshacer.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancelar'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Eliminar'),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        await DatabaseCleaner.clearAllDatabases();
                        if (context.mounted) {
                          context.read<RaffleBloc>().add(LoadRaffles());
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  const Icon(Icons.check_circle,
                                      color: Colors.white),
                                  const SizedBox(width: 10),
                                  const Text(
                                      'Todas las bases de datos fueron limpiadas'),
                                ],
                              ),
                              backgroundColor: Colors.green.shade700,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
