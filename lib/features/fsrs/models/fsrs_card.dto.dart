// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/fsrs_card.dart
// PURPOSE: Tracks a specific user's spaced-repetition progress for a StudyCard
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
import 'package:boo_mondai/features/study_session/models/study_card.dto.dart';
import 'package:boo_mondai/lib.barrel.dart' show DTO, uuid;
import 'package:dart_mappable/dart_mappable.dart';
import 'package:fsrs/fsrs.dart';

part 'fsrs_card.dto.mapper.dart';

@MappableClass()
class FsrsCard with FsrsCardMappable implements DTO {
  @override
  final String id;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  final String userId;

  /// <-- CHANGED: Now points to the StudyCard (the testable instance)
  /// instead of the Template (the raw data blueprint).
  final String studyCardId;

  final Card state;
  final StudyCard? studyCard;

  FsrsCard({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.studyCardId,
    required this.state,
    this.studyCard,
  });

  static Future<FsrsCard> create({
    required String studyCardId,
    required String userId,
  }) async {
    final now = DateTime.now();
    return FsrsCard(
      id: uuid.v7(),
      createdAt: now,
      updatedAt: now,
      userId: userId,
      studyCardId: studyCardId,
      state: await Card.create(),
    );
  }
}
