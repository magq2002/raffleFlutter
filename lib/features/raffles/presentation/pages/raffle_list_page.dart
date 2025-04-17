import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/raffle_repository.dart';
import '../../domain/entities/raffle.dart';
import '../../presentation/bloc/raffle_cubit.dart';
import '../../presentation/pages/raffle_details_page.dart';
import 'create_raffle_page.dart';

class RaffleListPage extends StatefulWidget {
  final RaffleRepository repository;
  const RaffleListPage({super.key, required this.repository});

  @override
  State<RaffleListPage> createState() => _RaffleListPageState();
}

class _RaffleListPageState extends State<RaffleListPage> {
  List<Raffle> raffles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRaffles();
  }

  Future<void> _loadRaffles() async {
    final loaded = await widget.repository.getAllRaffles();
    setState(() {
      raffles = loaded;
      isLoading = false;
    });
  }

  void _openRaffle(Raffle raffle) async {
    final cubit = context.read<RaffleCubit>();
    await cubit.loadFromDatabase(raffle.id);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RaffleDetailsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('My Raffles'),
        backgroundColor: Colors.black,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : raffles.isEmpty
              ? const Center(
                  child: Text(
                    'No raffles yet',
                    style: TextStyle(color: Colors.white70),
                  ),
                )
              : ListView.builder(
                  itemCount: raffles.length,
                  itemBuilder: (_, i) {
                    final r = raffles[i];
                    return ListTile(
                      title: Text(r.name,
                          style: const TextStyle(color: Colors.white)),
                      subtitle: Text('Tickets: ${r.totalTickets}',
                          style: const TextStyle(color: Colors.white54)),
                      trailing: Text(r.status,
                          style: TextStyle(color: _getStatusColor(r.status))),
                      onTap: () => _openRaffle(r),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateRafflePage()),
          );
          await _loadRaffles(); // Refrescar la lista después de crear
        },
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return Colors.greenAccent;
      case 'inactive':
        return Colors.orangeAccent;
      case 'expired':
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }
}
