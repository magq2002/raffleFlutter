import '../../features/giveaways/data/datasources/giveaway_local_datasource.dart';
import '../../features/giveaways/data/datasources/participant_local_datasource.dart';
import '../../features/raffles/data/datasources/raffle_local_datasource.dart';

class DatabaseCleaner {
  DatabaseCleaner._(); // Constructor privado

  static Future<void> clearAllDatabases() async {
    final raffleDb = await RaffleLocalDatasource.instance.database;
    await raffleDb.delete('tickets');
    await raffleDb.delete('raffles');

    final giveawayDb = await GiveawayLocalDatasource.instance.database;
    await giveawayDb.delete('giveaways');

    final participantDb = await ParticipantLocalDatasource.instance.database;
    await participantDb.delete('participants');
  }
}
