import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raffle/features/raffles/domain/entities/raffle.dart';
import 'package:raffle/features/raffles/presentation/bloc/raffle_bloc.dart';
import 'package:raffle/features/raffles/presentation/bloc/raffle_event.dart';
import 'package:raffle/features/raffles/presentation/bloc/raffle_state.dart';
import 'package:raffle/features/raffles/presentation/pages/raffle_create_page.dart';
import 'package:raffle/features/raffles/presentation/pages/raffle_details_page.dart';

import '../../data/datasources/raffle_local_datasource.dart';

class RaffleListPage extends StatelessWidget {
  const RaffleListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔁 Llamar al cargar por primera vez
    Future.microtask(() {
      context.read<RaffleBloc>().add(LoadRaffles());
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Raffles'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<RaffleBloc>().add(LoadRaffles());
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: 'Limpiar Base de Datos',
            onPressed: () async {
              await RaffleLocalDatasource.instance.clearDatabase();
              if (context.mounted) {
                context.read<RaffleBloc>().add(LoadRaffles());
              }
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Base de datos limpiada ✅')),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<RaffleBloc, RaffleState>(
        builder: (context, state) {
          if (state is RaffleLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RaffleLoaded) {
            if (state.raffles.isEmpty) {
              return const Center(child: Text('No raffles yet.'));
            }

            return ListView.builder(
              itemCount: state.raffles.length,
              itemBuilder: (context, index) {
                final raffle = state.raffles[index];
                return ListTile(
                  title: Text(raffle.name),
                  subtitle: Text('#${raffle.lotteryNumber}'),
                  trailing: Text(
                    raffle.status.toUpperCase(),
                    style: TextStyle(
                      color: _getStatusColor(raffle.status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () async {
                    // 🔁 Espera al regresar para refrescar lista
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RaffleDetailsPage(raffleId: raffle.id!),
                      ),
                    );
                    if (context.mounted) {
                      context.read<RaffleBloc>().add(LoadRaffles());
                    }
                  },
                );
              },
            );
          } else if (state is RaffleError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final bloc = context.read<RaffleBloc>();

          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: bloc,
                child: const RaffleCreatePage(),
              ),
            ),
          );

          if (context.mounted) {
            context.read<RaffleBloc>().add(LoadRaffles());
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return Colors.green;
      case 'inactive':
        return Colors.orange;
      case 'expired':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
