// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/guest_migration_service.dart
// PURPOSE: One-time migration or discard of guest Hive data when signing in/up
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/repositories/repositories.barrel.dart';

/// Handles transferring (or discarding) local guest-owned Hive data when
/// the user creates or signs into a Supabase account.
///
/// All operations are purely local — pushing to Supabase is the caller's
/// responsibility after migration.
class GuestMigrationService {
  // ── Inspection ──────────────────────────────────────────

  /// Returns true if [guestId] owns any local data worth asking the user about.
  static bool hasLocalData(String guestId) {
    final hasDecks = Repositories.deck.getByAuthorId(guestId).isNotEmpty;
    final hasFsrs = Repositories.fsrsCard.getByUserId(guestId).isNotEmpty;
    final hasSessions =
        Repositories.drillSession.getAll().any((s) => s.userId == guestId);
    final hasStreak = Repositories.streak.getByUserId(guestId) != null;
    return hasDecks || hasFsrs || hasSessions || hasStreak;
  }

  // ── Migration ───────────────────────────────────────────

  /// Re-keys all Hive records owned by [guestId] to [newUserId].
  ///
  /// Covered: decks, FSRS cards, drill sessions, streak.
  /// Review logs are linked via cardId (not userId) and need no migration.
  /// Card templates and review cards belong to decks, not users — no change.
  static Future<void> migrateLocalData(
    String guestId,
    String newUserId,
  ) async {
    // ── Decks ──────────────────────────────────────────────
    final guestDecks = Repositories.deck.getByAuthorId(guestId);
    for (final deck in guestDecks) {
      await Repositories.deck.save(deck.copyWith(authorId: newUserId));
    }

    // ── FSRS cards ─────────────────────────────────────────
    final guestFsrs = Repositories.fsrsCard.getByUserId(guestId);
    for (final card in guestFsrs) {
      await Repositories.fsrsCard.save(card.copyWith(userId: newUserId));
    }

    // ── Drill sessions ─────────────────────────────────────
    // userId lives on the StudySession base class; dart_mappable includes it
    // in the generated copyWith for all subclasses.
    final guestSessions = Repositories.drillSession
        .getAll()
        .where((s) => s.userId == guestId)
        .toList();
    for (final session in guestSessions) {
      await Repositories.drillSession.save(session.copyWith(userId: newUserId));
    }

    // ── Streak ─────────────────────────────────────────────
    // StreakRepository keys by userId, so delete the old entry first.
    final guestStreak = Repositories.streak.getByUserId(guestId);
    if (guestStreak != null) {
      await Repositories.streak.delete(guestId);
      await Repositories.streak.save(guestStreak.copyWith(userId: newUserId));
    }
  }

  // ── Discard ─────────────────────────────────────────────

  /// Deletes all Hive records owned by [guestId] without migrating them.
  ///
  /// Used when the user signs in and chooses NOT to keep their guest data.
  static Future<void> discardGuestData(String guestId) async {
    final guestDecks = Repositories.deck.getByAuthorId(guestId);
    await Repositories.deck.deleteAll(guestDecks.map((d) => d.id).toList());

    final guestFsrs = Repositories.fsrsCard.getByUserId(guestId);
    await Repositories.fsrsCard
        .deleteAll(guestFsrs.map((c) => c.id).toList());

    final guestSessions = Repositories.drillSession
        .getAll()
        .where((s) => s.userId == guestId)
        .toList();
    await Repositories.drillSession
        .deleteAll(guestSessions.map((s) => s.id).toList());

    final guestStreak = Repositories.streak.getByUserId(guestId);
    if (guestStreak != null) {
      await Repositories.streak.delete(guestId);
    }
  }
}
