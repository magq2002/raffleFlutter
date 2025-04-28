import '../entities/giveaway.dart';

abstract class GiveawayRepository {
  Future<int> createGiveaway({
    required String name,
    required String description,
    required String drawDate,
    required String status,
  });

  Future<void> updateGiveawayStatus({
    required int giveawayId,
    required String newStatus,
  });

  Future<List<Giveaway>> getGiveaways();

  Future<Giveaway?> getGiveaway(int id);

  Future<void> deleteGiveaway(int id);
}
