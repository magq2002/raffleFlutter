import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raffle/features/giveaways/data/datasources/giveaway_local_datasource.dart';

import '../../../../core/data/database_cleaner.dart';
import '../../data/datasources/raffle_local_datasource.dart';
import '../bloc/raffle_bloc.dart';
import '../bloc/raffle_event.dart';

class TrashPage extends StatelessWidget {
  const TrashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IconButton(
        icon: const Icon(Icons.delete_forever),
        tooltip: 'Limpiar Base de Datos',
        onPressed: () async {
          await DatabaseCleaner.clearAllDatabases();
          if (context.mounted) {
            context.read<RaffleBloc>().add(LoadRaffles());
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Todas las bases de datos fueron limpiadas ✅')),
            );
          }
        },
      ),
    );
  }
}
