// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/fsrs_review_log.dart
// PURPOSE: Wraps the FSRS ReviewLog with our database IDs for tracking history
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart';
import 'package:fsrs/fsrs.dart';

class FsrsReviewLog {
  final String id;

  // Our database's String UUID linking it to the specific FsrsCard
  final String cardId;

  final ReviewLog log;

  const FsrsReviewLog({
    required this.id,
    required this.cardId,
    required this.log,
  });

  factory FsrsReviewLog.create({
    required String cardId,
    required ReviewLog log,
  }) {
    return FsrsReviewLog(id: UuidService.uuid.v4(), cardId: cardId, log: log);
  }

  // ── Convenience Getters ──────────────────────────────
  Rating get rating => log.rating;

  // Updated to match your package's exact property name!
  DateTime get reviewedAt => log.reviewDateTime;
}
