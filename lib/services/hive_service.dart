import 'package:hive_ce_flutter/hive_ce_flutter.dart';

class HiveService {
  // ── Clear ───────────────────────────────────────────
  static Future<void> clearAll() async {
    await Hive.openBox('profile').then((value) => value.clear());
    // await _decks.clear();
    // await _cards.clear();
    // await _fsrsCards.clear();
    // await _reviewLogs.clear();
    // await _streaks.clear();
    // await _settings.clear();
  }
}
