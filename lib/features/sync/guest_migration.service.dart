// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/guest_migration_service.dart
// PURPOSE: One-time migration or discard of guest Hive data when signing in/up
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart' show DrillSession, LocalDB;

/// Handles transferring (or discarding) local guest-owned Hive data when
/// the guest profile is linked to a Supabase account.
///
/// All operations are purely local — pushing to Supabase is the caller's
/// responsibility after migration.
class GuestMigrationService {
  // ── Inspection ──────────────────────────────────────────

  /// Returns true if [guestProfileId] owns any local data worth asking about.
  static bool hasLocalData(String guestProfileId) {
    final hasDecks = LocalDB.deck.getByProfileId(guestProfileId).isNotEmpty;
    final hasFsrs = LocalDB.fsrsCard.getByProfileId(guestProfileId).isNotEmpty;
    final hasSessions = LocalDB.drillSession.selectMany().any(
      (s) => s.profileId == guestProfileId,
    );
    final streak = LocalDB.streak.retrieve();
    final hasStreak = streak?.profileId == guestProfileId;
    return hasDecks || hasFsrs || hasSessions || hasStreak;
  }

  // ── Migration ───────────────────────────────────────────

  /// Re-keys all Hive records owned by [guestProfileId] to [newProfileId].
  ///
  /// Covered: decks, FSRS cards, drill sessions, streak.
  /// Review logs are linked via cardId and need no migration.
  /// Card templates and review cards belong to decks, not users — no change.
  static Future<void> migrateLocalData(
    String guestProfileId,
    String newProfileId,
  ) async {
    // ── Decks ──────────────────────────────────────────────
    final guestDecks = LocalDB.deck.getByProfileId(guestProfileId);
    for (final deck in guestDecks) {
      await LocalDB.deck.upsert(deck.copyWith(profileId: newProfileId));
    }

    // ── FSRS cards ─────────────────────────────────────────
    final guestFsrs = LocalDB.fsrsCard.getByProfileId(guestProfileId);
    for (final card in guestFsrs) {
      await LocalDB.fsrsCard.upsert(card.copyWith(profileId: newProfileId));
    }

    // ── Drill sessions ─────────────────────────────────────
    // profileId lives on the StudySession base class; dart_mappable includes it
    // in the generated copyWith for all subclasses.
    final guestSessions = LocalDB.drillSession
        .selectMany()
        .where((s) => s.profileId == guestProfileId)
        .toList();
    for (final session in guestSessions) {
      await LocalDB.drillSession.upsert(
        DrillSession(
          id: session.id,
          profileId: newProfileId,
          deckId: session.deckId,
          startedAt: session.startedAt,
          completedAt: session.completedAt,
          userProfile: session.userProfile,
          deck: session.deck,
          previewed: session.previewed,
          totalQuestions: session.totalQuestions,
          correctCount: session.correctCount,
        ),
      );
    }

    // ── Streak ─────────────────────────────────────────────
    // StreakLocalDB keys by profileId, so delete the old entry first.
    final guestStreak = LocalDB.streak.retrieve();
    if (guestStreak != null && guestStreak.profileId == guestProfileId) {
      await LocalDB.streak.upsert(
        guestStreak.copyWith(profileId: newProfileId),
      );
    }
  }

  // ── Discard ─────────────────────────────────────────────

  /// Deletes all Hive records owned by [guestProfileId] without migrating them.
  ///
  /// Used when the profile signs in and chooses NOT to keep guest data.
  static Future<void> discardGuestData(String guestProfileId) async {
    final guestDecks = LocalDB.deck.getByProfileId(guestProfileId);
    await LocalDB.deck.deleteManyByPk(
      guestDecks.map((d) => {'id': d.id}).toList(),
    );

    final guestFsrs = LocalDB.fsrsCard.getByProfileId(guestProfileId);
    await LocalDB.fsrsCard.deleteManyByPk(
      guestFsrs.map((c) => {'id': c.id}).toList(),
    );

    final guestSessions = LocalDB.drillSession
        .selectMany()
        .where((s) => s.profileId == guestProfileId)
        .toList();
    await LocalDB.drillSession.deleteManyByPk(
      guestSessions.map((s) => {'id': s.id}).toList(),
    );

    final guestStreak = LocalDB.streak.retrieve();
    if (guestStreak?.profileId == guestProfileId) {
      await LocalDB.streak.clear();
    }
  }
}
