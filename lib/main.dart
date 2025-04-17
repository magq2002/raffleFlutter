import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/raffles/data/datasources/raffle_dao.dart';
import 'features/raffles/data/datasources/ticket_dao.dart';
import 'features/raffles/data/repositories/raffle_repository.dart';
import 'features/raffles/presentation/bloc/raffle_cubit.dart';
import 'features/raffles/presentation/pages/raffle_list_page.dart';

void main() {
  // Inicializar DAOs y repositorio
  final raffleDao = RaffleDao();
  final ticketDao = TicketDao();
  final raffleRepository = RaffleRepository(
    raffleDao: raffleDao,
    ticketDao: ticketDao,
  );

  runApp(MyApp(repository: raffleRepository));
}

class MyApp extends StatelessWidget {
  final RaffleRepository repository;

  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RaffleCubit(repository),
      child: MaterialApp(
        title: 'Raffle App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: RaffleListPage(repository: repository),
      ),
    );
  }
}
