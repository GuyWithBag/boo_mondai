// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/hive_service.dart
// PURPOSE: Manages all local Hive box operations for offline caching and FSRS state
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:hive_ce/hive_ce.dart';
import 'package:boo_mondai/services/app_exception.dart';
import 'package:boo_mondai/models/models.dart';

class HiveService {
  static const _profileBox = 'profile';
  static const _decksBox = 'decks';
  static const _cardsBox = 'cards';
  static const _fsrsCardsBox = 'fsrs_cards';
  static const _reviewLogsBox = 'review_logs';
  static const _streaksBox = 'streaks';
  static const _settingsBox = 'settings';

  late Box<Map> _profile;
  late Box<Map> _decks;
  late Box<Map> _cards;
  late Box<Map> _fsrsCards;
  late Box<Map> _reviewLogs;
  late Box<Map> _streaks;
  late Box _settings;

  Future<void> init() async {
    try {
      await _openBoxes();
    } catch (e) {
      // Corrupted boxes (e.g. leftover typed adapters) — wipe and retry
      await _deleteAllBoxes();
      try {
        await _openBoxes();
      } catch (e2) {
        throw AppException('Failed to initialize Hive: $e2');
      }
    }
  }

  Future<void> _openBoxes() async {
    _profile = await Hive.openBox<Map>(_profileBox);
    _decks = await Hive.openBox<Map>(_decksBox);
    _cards = await Hive.openBox<Map>(_cardsBox);
    _fsrsCards = await Hive.openBox<Map>(_fsrsCardsBox);
    _reviewLogs = await Hive.openBox<Map>(_reviewLogsBox);
    _streaks = await Hive.openBox<Map>(_streaksBox);
    _settings = await Hive.openBox(_settingsBox);
  }

  Future<void> _deleteAllBoxes() async {
    await Hive.deleteBoxFromDisk(_profileBox);
    await Hive.deleteBoxFromDisk(_decksBox);
    await Hive.deleteBoxFromDisk(_cardsBox);
    await Hive.deleteBoxFromDisk(_fsrsCardsBox);
    await Hive.deleteBoxFromDisk(_reviewLogsBox);
    await Hive.deleteBoxFromDisk(_streaksBox);
    await Hive.deleteBoxFromDisk(_settingsBox);
  }

  // ── Profile ─────────────────────────────────────────
  Future<void> saveProfile(UserProfile profile) async {
    await _profile.put('current', Map<String, dynamic>.from(profile.toJson()));
  }

  UserProfile? getProfile() {
    final data = _profile.get('current');
    if (data == null) return null;
    return UserProfile.fromJson(Map<String, dynamic>.from(data));
  }

  // ── Decks ───────────────────────────────────────────
  Future<void> saveDecks(List<Deck> decks) async {
    await _decks.clear();
    for (final deck in decks) {
      await _decks.put(deck.id, Map<String, dynamic>.from(deck.toJson()));
    }
  }

  List<Deck> getDecks() {
    return _decks.values
        .map((data) => Deck.fromJson(Map<String, dynamic>.from(data)))
        .toList();
  }

  // ── Cards ───────────────────────────────────────────
  Future<void> saveCards(String deckId, List<DeckCard> cards) async {
    for (final card in cards) {
      await _cards.put(card.id, Map<String, dynamic>.from(card.toCacheJson()));
    }
  }

  Future<void> deleteCard(String cardId) async {
    await _cards.delete(cardId);
  }

  List<DeckCard> getCards(String deckId) {
    return _cards.values
        .map((data) => DeckCard.fromJson(Map<String, dynamic>.from(data)))
        .where((card) => card.deckId == deckId)
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  // ── FSRS Cards ──────────────────────────────────────
  Future<void> saveFsrsCard(FsrsCardState card) async {
    await _fsrsCards.put(
        card.id, Map<String, dynamic>.from(card.toJson()));
  }

  FsrsCardState? getFsrsCard(String compositeKey) {
    final data = _fsrsCards.get(compositeKey);
    if (data == null) return null;
    return FsrsCardState.fromJson(Map<String, dynamic>.from(data));
  }

  List<FsrsCardState> getDueCards(String userId, DateTime now) {
    return _fsrsCards.values
        .map((data) => FsrsCardState.fromJson(Map<String, dynamic>.from(data)))
        .where((card) =>
            card.userId == userId &&
            (card.due.isBefore(now) || card.due.isAtSameMomentAs(now)))
        .toList();
  }

  List<FsrsCardState> getAllFsrsCards(String userId) {
    return _fsrsCards.values
        .map((data) => FsrsCardState.fromJson(Map<String, dynamic>.from(data)))
        .where((card) => card.userId == userId)
        .toList();
  }

  // ── Review Logs ─────────────────────────────────────
  Future<void> saveReviewLog(ReviewLogEntry log) async {
    await _reviewLogs.put(
        log.id, Map<String, dynamic>.from(log.toJson()));
  }

  // ── Streaks ─────────────────────────────────────────
  Future<void> saveStreak(Streak streak) async {
    await _streaks.put(
        streak.userId, Map<String, dynamic>.from(streak.toJson()));
  }

  Streak? getStreak(String userId) {
    final data = _streaks.get(userId);
    if (data == null) return null;
    return Streak.fromJson(Map<String, dynamic>.from(data));
  }

  // ── Settings ────────────────────────────────────────
  int getNotificationHour() => _settings.get('notification_hour', defaultValue: 9) as int;

  Future<void> setNotificationHour(int hour) async {
    await _settings.put('notification_hour', hour);
  }

  // ── Clear ───────────────────────────────────────────
  Future<void> clearAll() async {
    await _profile.clear();
    await _decks.clear();
    await _cards.clear();
    await _fsrsCards.clear();
    await _reviewLogs.clear();
    await _streaks.clear();
    await _settings.clear();
  }
}
