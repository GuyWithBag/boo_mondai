import 'package:boo_mondai/lib.barrel.dart'
    show LocalDB, RemoteDB, SyncDeletionPolicy;

abstract final class SyncClientService {
  static String getClientId() {
    return LocalDB.syncClient.getOrCreate().id;
  }

  static Future<void> touchSeen({required String profileId}) async {
    final client = LocalDB.syncClient.getOrCreate();
    await RemoteDB.syncClient.touchSeen(
      clientId: client.id,
      profileId: profileId,
    );
  }

  static Future<void> markSynced({required String profileId}) async {
    final client = LocalDB.syncClient.getOrCreate();
    final now = DateTime.now();
    await LocalDB.syncClient.upsert(
      client.copyWith(profileId: profileId, lastSeenAt: now, lastSyncedAt: now),
    );
    await RemoteDB.syncClient.markSynced(
      clientId: client.id,
      profileId: profileId,
    );
  }

  static Future<void> purgeRemoteTombstones() {
    final policy = SyncDeletionPolicy.current();
    return RemoteDB.syncClient.purgeSyncTombstones(
      activeClientWindow: policy.activeClientWindow,
    );
  }

  static Future<void> purgeLocalTombstones() async {
    final now = DateTime.now();

    await LocalDB.fsrsCard.deleteManyByPk([
      for (final card in LocalDB.fsrsCard.selectMany(includeDeleted: true))
        if (_shouldPurge(card.deletedAt, card.purgeAfter, now)) {'id': card.id},
    ]);
    await LocalDB.studyCard.deleteManyByPk([
      for (final card in LocalDB.studyCard.selectMany(includeDeleted: true))
        if (_shouldPurge(card.deletedAt, card.purgeAfter, now)) {'id': card.id},
    ]);
    await LocalDB.cardTemplate.deleteManyByPk([
      for (final template in LocalDB.cardTemplate.selectMany(
        includeDeleted: true,
      ))
        if (_shouldPurge(template.deletedAt, template.purgeAfter, now))
          {'id': template.id},
    ]);
    await LocalDB.deckListing.deleteManyByPk([
      for (final listing in LocalDB.deckListing.selectMany(
        includeDeleted: true,
      ))
        if (_shouldPurge(listing.deletedAt, listing.purgeAfter, now))
          {'deck_id': listing.deckId},
    ]);
    await LocalDB.deck.deleteManyByPk([
      for (final deck in LocalDB.deck.selectMany(includeDeleted: true))
        if (_shouldPurge(deck.deletedAt, deck.purgeAfter, now)) {'id': deck.id},
    ]);

    final streak = LocalDB.streak.retrieve();
    if (streak != null &&
        _shouldPurge(streak.deletedAt, streak.purgeAfter, now)) {
      await LocalDB.streak.clear();
    }
  }

  static bool _shouldPurge(
    DateTime? deletedAt,
    DateTime? purgeAfter,
    DateTime now,
  ) {
    return deletedAt != null && purgeAfter != null && !purgeAfter.isAfter(now);
  }
}
