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

  /// Returns true if [guestUserId] owns any local data worth asking the user about.
  static bool hasLocalData(String guestUserId) {
    final hasDecks = LocalDB.deck.getByUserId(guestUserId).isNotEmpty;
    final hasFsrs = LocalDB.fsrsCard.getByUserId(guestUserId).isNotEmpty;
    final hasSessions = LocalDB.drillSession.selectMany().any(
      (s) => s.userId == guestUserId,
    );
    final streak = LocalDB.streak.retrieve();
    final hasStreak = streak?.userId == guestUserId;
    return hasDecks || hasFsrs || hasSessions || hasStreak;
  }

  // ── Migration ───────────────────────────────────────────

  /// Re-keys all Hive records owned by [guestUserId] to [newUserId].
  ///
  /// Covered: decks, FSRS cards, drill sessions, streak.
  /// Review logs are linked via cardId (not userId) and need no migration.
  /// Card templates and review cards belong to decks, not users — no change.
  static Future<void> migrateLocalData(
    String guestUserId,
    String newUserId,
  ) async {
    // ── Decks ──────────────────────────────────────────────
    final guestDecks = LocalDB.deck.getByUserId(guestUserId);
    for (final deck in guestDecks) {
      await LocalDB.deck.upsert(deck.copyWith(userId: newUserId));
    }

    // ── FSRS cards ─────────────────────────────────────────
    final guestFsrs = LocalDB.fsrsCard.getByUserId(guestUserId);
    for (final card in guestFsrs) {
      await LocalDB.fsrsCard.upsert(card.copyWith(userId: newUserId));
    }

    // ── Drill sessions ─────────────────────────────────────
    // userId lives on the StudySession base class; dart_mappable includes it
    // in the generated copyWith for all subclasses.
    final guestSessions = LocalDB.drillSession
        .selectMany()
        .where((s) => s.userId == guestUserId)
        .toList();
    for (final session in guestSessions) {
      await LocalDB.drillSession.upsert(session.copyWith(userId: newUserId));
    }

    // ── Streak ─────────────────────────────────────────────
    // StreakLocalDB keys by userId, so delete the old entry first.
    final guestStreak = LocalDB.streak.retrieve();
    if (guestStreak != null && guestStreak.userId == guestUserId) {
      await LocalDB.streak.upsert(guestStreak.copyWith(userId: newUserId));
    }
  }

  // ── Discard ─────────────────────────────────────────────

  /// Deletes all Hive records owned by [guestUserId] without migrating them.
  ///
  /// Used when the user signs in and chooses NOT to keep their guest data.
  static Future<void> discardGuestData(String guestUserId) async {
    final guestDecks = LocalDB.deck.getByUserId(guestUserId);
    await LocalDB.deck.deleteManyByPk(
      guestDecks.map((d) => {'id': d.id}).toList(),
    );

    final guestFsrs = LocalDB.fsrsCard.getByUserId(guestUserId);
    await LocalDB.fsrsCard.deleteManyByPk(
      guestFsrs.map((c) => {'id': c.id}).toList(),
    );

    final guestSessions = LocalDB.drillSession
        .selectMany()
        .where((s) => s.userId == guestUserId)
        .toList();
    await LocalDB.drillSession.deleteManyByPk(
      guestSessions.map((s) => {'id': s.id}).toList(),
    );

    final guestStreak = LocalDB.streak.retrieve();
    if (guestStreak?.userId == guestUserId) {
      await LocalDB.streak.clear();
    }
  }
}
