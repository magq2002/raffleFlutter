import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/raffles/presentation/bloc/raffle_cubit.dart';
import 'features/raffles/presentation/pages/raffle_details_page.dart';
import 'features/raffles/domain/entities/raffle.dart';
import 'features/raffles/domain/entities/ticket.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => RaffleCubit()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Datos de prueba: puedes reemplazar esto por una carga real
    final dummyRaffle = Raffle(
      id: 1,
      name: 'Test Raffle',
      lotteryNumber: 'ABC123',
      price: 10.0,
      totalTickets: 10,
      status: 'active',
      deleted: false,
      deletedAt: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final dummyTickets = List.generate(
        10,
        (i) => Ticket(
              id: i,
              number: i + 1,
              status: 'available',
              buyerName: null,
              buyerContact: null,
            ));

    return MaterialApp(
      title: 'Raffle App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Builder(
        builder: (context) {
          // Carga inicial del cubit con la rifa y los tickets
          context.read<RaffleCubit>().loadRaffle(dummyRaffle, dummyTickets);
          return RaffleDetailsPage(); // Ya no necesita props, lo saca del cubit
        },
      ),
    );
  }
}
