// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/repositories/drill_answer_repository.dart
// PURPOSE: Dedicated Hive CRUD for permanent DrillAnswer storage
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/database/database.barrel.dart';

class DrillAnswersLocalDB extends HiveLocalDB<DrillAnswer> {
  @override
  String get boxName => 'drill_answers';

  @override
  Map<String, Object?> primaryKeyFromItem(DrillAnswer item) => {'id': item.id};

  // ── Domain Specific Queries ────────────────────────────────

  /// Fetches all answers submitted during a specific session
  List<DrillAnswer> getBySessionId(String sessionId) => guardSync(
    () => box.values.where((a) => a.sessionId == sessionId).toList(),
    action: 'getBySessionId($sessionId)',
  );

  /// Fetches the history of a specific card (useful for future stats screens!)
  List<DrillAnswer> getByReviewCardId(String reviewCardId) => guardSync(
    () => box.values.where((a) => a.cardId == reviewCardId).toList(),
    action: 'getByReviewCardId($reviewCardId)',
  );
}
