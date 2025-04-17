import 'package:flutter/material.dart';
import 'features/raffles/domain/entities/raffle.dart';
import 'features/raffles/domain/entities/ticket.dart';
import 'features/raffles/presentation/pages/raffle_details_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final mockRaffle = Raffle(
      id: 1,
      name: "Sample Raffle",
      lotteryNumber: "X123",
      price: 100.0,
      totalTickets: 30,
      status: 'active',
      deleted: false,
      deletedAt: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final mockTickets = List.generate(30, (i) {
      final status = i < 10
          ? 'sold'
          : i < 15
              ? 'reserved'
              : 'available';
      return Ticket(id: i, number: i + 1, status: status);
    });

    return MaterialApp(
      theme: ThemeData.dark(),
      home: RaffleDetailsPage(raffle: mockRaffle, tickets: mockTickets),
    );
  }
}
