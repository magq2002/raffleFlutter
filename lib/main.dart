import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raffle/features/raffles/data/datasources/raffle_local_datasource.dart';
import 'package:raffle/features/raffles/data/datasources/ticket_dao.dart';
import 'package:raffle/features/raffles/data/repositories/raffle_repository_impl.dart';
import 'package:raffle/features/raffles/domain/repositories/raffle_repository.dart';
import 'package:raffle/features/raffles/presentation/bloc/raffle_bloc.dart';
import 'package:raffle/features/raffles/presentation/bloc/details/raffle_details_bloc.dart';
import 'package:raffle/features/raffles/presentation/pages/raffle_list_page.dart';

void main() {
  // Creamos el repositorio y las dependencias necesarias
  final RaffleRepository repository = RaffleRepositoryImpl(
    raffleLocalDatasource: RaffleLocalDatasource.instance,
    ticketDao: TicketDao.instance,
  );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => RaffleBloc(repository)),
        BlocProvider(create: (_) => RaffleDetailsBloc(repository)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Raffle App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const RaffleListPage(), // Tu pantalla inicial
    );
  }
}
