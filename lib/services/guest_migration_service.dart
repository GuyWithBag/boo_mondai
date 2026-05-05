// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/guest_migration_service.dart
// PURPOSE: One-time migration or discard of guest Hive data when signing in/up
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/database/database.barrel.dart';

/// Handles transferring (or discarding) local guest-owned Hive data when
/// the user creates or signs into a Supabase account.
///
/// All operations are purely local — pushing to Supabase is the caller's
/// responsibility after migration.
class GuestMigrationService {
  // ── Inspection ──────────────────────────────────────────

  /// Returns true if [guestId] owns any local data worth asking the user about.
  static bool hasLocalData(String guestId) {
    final hasDecks = LocalDB.deck.getByAuthorId(guestId).isNotEmpty;
    final hasFsrs = LocalDB.fsrsCard.getByUserId(guestId).isNotEmpty;
    final hasSessions = LocalDB.drillSession.getAll().any(
      (s) => s.userId == guestId,
    );
    final hasStreak = LocalDB.streak.getByUserId(guestId) != null;
    return hasDecks || hasFsrs || hasSessions || hasStreak;
  }

  // ── Migration ───────────────────────────────────────────

  /// Re-keys all Hive records owned by [guestId] to [newUserId].
  ///
  /// Covered: decks, FSRS cards, drill sessions, streak.
  /// Review logs are linked via cardId (not userId) and need no migration.
  /// Card templates and review cards belong to decks, not users — no change.
  static Future<void> migrateLocalData(String guestId, String newUserId) async {
    // ── Decks ──────────────────────────────────────────────
    final guestDecks = LocalDB.deck.getByAuthorId(guestId);
    for (final deck in guestDecks) {
      await LocalDB.deck.put(deck.copyWith(authorId: newUserId));
    }

    // ── FSRS cards ─────────────────────────────────────────
    final guestFsrs = LocalDB.fsrsCard.getByUserId(guestId);
    for (final card in guestFsrs) {
      await LocalDB.fsrsCard.put(card.copyWith(userId: newUserId));
    }

    // ── Drill sessions ─────────────────────────────────────
    // userId lives on the StudySession base class; dart_mappable includes it
    // in the generated copyWith for all subclasses.
    final guestSessions = LocalDB.drillSession
        .getAll()
        .where((s) => s.userId == guestId)
        .toList();
    for (final session in guestSessions) {
      await LocalDB.drillSession.put(session.copyWith(userId: newUserId));
    }

    // ── Streak ─────────────────────────────────────────────
    // StreakLocalDB keys by userId, so delete the old entry first.
    final guestStreak = LocalDB.streak.getByUserId(guestId);
    if (guestStreak != null) {
      await LocalDB.streak.delete(guestId);
      await LocalDB.streak.put(guestStreak.copyWith(userId: newUserId));
    }
  }

  // ── Discard ─────────────────────────────────────────────

  /// Deletes all Hive records owned by [guestId] without migrating them.
  ///
  /// Used when the user signs in and chooses NOT to keep their guest data.
  static Future<void> discardGuestData(String guestId) async {
    final guestDecks = LocalDB.deck.getByAuthorId(guestId);
    await LocalDB.deck.deleteAll(guestDecks.map((d) => d.id).toList());

    final guestFsrs = LocalDB.fsrsCard.getByUserId(guestId);
    await LocalDB.fsrsCard.deleteAll(guestFsrs.map((c) => c.id).toList());

    final guestSessions = LocalDB.drillSession
        .getAll()
        .where((s) => s.userId == guestId)
        .toList();
    await LocalDB.drillSession.deleteAll(
      guestSessions.map((s) => s.id).toList(),
    );

    final guestStreak = LocalDB.streak.getByUserId(guestId);
    if (guestStreak != null) {
      await LocalDB.streak.delete(guestId);
    }
  }
}
