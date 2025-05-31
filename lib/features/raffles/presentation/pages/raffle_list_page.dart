import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raffle/features/raffles/presentation/bloc/raffle_bloc.dart';
import 'package:raffle/features/raffles/presentation/bloc/raffle_event.dart';
import 'package:raffle/features/raffles/presentation/bloc/raffle_state.dart';
import 'package:raffle/features/raffles/presentation/bloc/details/raffle_details_bloc.dart';
import 'package:raffle/features/raffles/presentation/pages/raffle_create_page.dart';
import 'package:raffle/features/raffles/presentation/pages/raffle_details_page.dart';
import 'package:raffle/features/raffles/presentation/pages/raffle_edit_page.dart';

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
    final bloc = context.read<RaffleBloc>();
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: bloc),
            BlocProvider(
              create: (_) => RaffleDetailsBloc(bloc.repository),
            ),
          ],
          child: RaffleDetailsPage(raffleId: raffleId),
        ),
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
                  child: InkWell(
                    onTap: () => _navigateToDetails(raffle.id!),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Contenedor de imagen y estado
                              SizedBox(
                                width: 60,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    raffle.imagePath != null &&
                                            raffle.imagePath!.isNotEmpty
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
                                              raffle.name
                                                  .substring(0, 1)
                                                  .toUpperCase(),
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                    const SizedBox(height: 12),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(raffle.status)
                                            .withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                          color: _getStatusColor(raffle.status),
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
                                        _getStatusDisplayName(raffle.status),
                                        style: TextStyle(
                                          color: _getStatusColor(raffle.status),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Contenido de información
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      raffle.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    const SizedBox(height: 4),
                                    Text('Lotería #${raffle.lotteryNumber}'),
                                    const SizedBox(height: 6),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: LinearProgressIndicator(
                                        value: percent,
                                        minHeight: 6,
                                        backgroundColor: Colors.grey[300],
                                        valueColor: const AlwaysStoppedAnimation(
                                            Color(0xFF00C853)),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                        '${(percent * 100).toStringAsFixed(1)}% vendido',
                                        style: const TextStyle(fontSize: 12)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert),
                            onSelected: (value) async {
                              switch (value) {
                                case 'edit':
                                  if (raffle.status != 'expired') {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => BlocProvider.value(
                                          value: context.read<RaffleBloc>(),
                                          child: RaffleEditPage(raffle: raffle),
                                        ),
                                      ),
                                    );
                                    if (mounted) {
                                      context.read<RaffleBloc>().add(LoadRaffles());
                                    }
                                  }
                                  break;
                                case 'active':
                                  context.read<RaffleBloc>().add(
                                    UpdateRaffleStatusEvent(
                                      raffleId: raffle.id!,
                                      newStatus: 'active',
                                    ),
                                  );
                                  break;
                                case 'inactive':
                                  context.read<RaffleBloc>().add(
                                    UpdateRaffleStatusEvent(
                                      raffleId: raffle.id!,
                                      newStatus: 'inactive',
                                    ),
                                  );
                                  break;
                                case 'expired':
                                  context.read<RaffleBloc>().add(
                                    UpdateRaffleStatusEvent(
                                      raffleId: raffle.id!,
                                      newStatus: 'expired',
                                    ),
                                  );
                                  break;
                              }
                            },
                            itemBuilder: (BuildContext context) => [
                              if (raffle.status != 'expired')
                                const PopupMenuItem<String>(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit),
                                      SizedBox(width: 8),
                                      Text('Editar'),
                                    ],
                                  ),
                                ),
                              const PopupMenuDivider(),
                              const PopupMenuItem<String>(
                                value: 'active',
                                child: Row(
                                  children: [
                                    Icon(Icons.check_circle_outline, color: Colors.green),
                                    SizedBox(width: 8),
                                    Text('Activar'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem<String>(
                                value: 'inactive',
                                child: Row(
                                  children: [
                                    Icon(Icons.pause_circle_outline, color: Colors.orange),
                                    SizedBox(width: 8),
                                    Text('Pausar'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem<String>(
                                value: 'expired',
                                child: Row(
                                  children: [
                                    Icon(Icons.cancel_outlined, color: Colors.red),
                                    SizedBox(width: 8),
                                    Text('Expirar'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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

  String _getStatusDisplayName(String status) {
    switch (status) {
      case 'active':
        return 'Activa';
      case 'inactive':
        return 'Inactiva';
      case 'expired':
        return 'Expirada';
      default:
        return status;
    }
  }
}
