import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raffle/features/raffles/presentation/bloc/raffle_bloc.dart';
import 'package:raffle/features/raffles/presentation/bloc/raffle_event.dart';
import 'package:raffle/features/raffles/presentation/bloc/raffle_state.dart';
import 'package:raffle/features/raffles/presentation/pages/raffle_create_page.dart';
import 'package:raffle/features/raffles/presentation/pages/raffle_details_page.dart';

import '../../../../core/theme/app_colors.dart';

class RaffleListPage extends StatefulWidget {
  const RaffleListPage({super.key});

  @override
  State<RaffleListPage> createState() => _RaffleListPageState();
}

class _RaffleListPageState extends State<RaffleListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<RaffleBloc>().add(LoadRaffles());
    });
  }

  Future<void> _navigateToDetails(int raffleId) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RaffleDetailsPage(raffleId: raffleId),
      ),
    );
    if (mounted) {
      context.read<RaffleBloc>().add(LoadRaffles());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<RaffleBloc, RaffleState>(
        builder: (context, state) {
          if (state is RaffleLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RaffleLoaded) {
            if (state.raffles.isEmpty) {
              return const Center(child: Text('No hay rifas creadas.'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.raffles.length,
              itemBuilder: (context, index) {
                final raffle = state.raffles[index];
                final tickets = raffle.tickets ?? [];
                final soldCount = tickets
                    .where((t) => t.status == 'sold' || t.status == 'reserved')
                    .length;
                final percent = raffle.totalTickets == 0
                    ? 0.0
                    : soldCount / raffle.totalTickets;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    leading:
                        raffle.imagePath != null && raffle.imagePath!.isNotEmpty
                            ? ClipOval(
                                child: Image.file(
                                  File(raffle.imagePath!),
                                  width: 44,
                                  height: 44,
                                  fit: BoxFit.cover,
                                  cacheWidth: 100,
                                  cacheHeight: 100,
                                ),
                              )
                            : CircleAvatar(
                                radius: 22,
                                backgroundColor: Colors.deepPurple,
                                child: Text(
                                  raffle.name.substring(0, 1).toUpperCase(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                    title: Text(
                      raffle.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text('Lotería #${raffle.lotteryNumber}'),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: percent,
                            minHeight: 6,
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation(
                                Theme.of(context).colorScheme.primary),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text('${(percent * 100).toStringAsFixed(1)}% vendido',
                            style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                    trailing: Text(
                      raffle.status.toUpperCase(),
                      style: TextStyle(
                        color: _getStatusColor(raffle.status),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () => _navigateToDetails(raffle.id!),
                  ),
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
        foregroundColor: Colors.black,
        backgroundColor: AppColors.primary,
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

          if (mounted) {
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
