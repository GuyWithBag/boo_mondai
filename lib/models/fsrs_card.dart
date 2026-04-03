// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/fsrs_card.dart
// PURPOSE: Tracks a specific user's spaced-repetition progress for a ReviewCard
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
import 'package:boo_mondai/services/services.barrel.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:fsrs/fsrs.dart';

part 'fsrs_card.mapper.dart';

@MappableClass()
class FsrsCard with FsrsCardMappable {
  final String id;
  final String userId;

  /// <-- CHANGED: Now points to the ReviewCard (the testable instance)
  /// instead of the Template (the raw data blueprint).
  final String reviewCardId;

  final Card state;

  FsrsCard({
    required this.id,
    required this.userId,
    required this.reviewCardId,
    required this.state,
  });

  static Future<FsrsCard> create({
    required String reviewCardId, // <-- CHANGED
    required String userId,
  }) async {
    return FsrsCard(
      id: UuidService.uuid.v4(),
      userId: userId,
      reviewCardId: reviewCardId, // <-- CHANGED
      state: await Card.create(),
    );
  }
}
