// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/dtos/user_study_cards_tag.dto.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
import 'package:dart_mappable/dart_mappable.dart';

part 'user_study_card_tag.dto.mapper.dart';

@MappableClass()
class UserStudyCardTag with UserStudyCardTagMappable {
  final String userId;
  final String studyCardId;
  final String tagId;

  const UserStudyCardTag({
    required this.userId,
    required this.studyCardId,
    required this.tagId,
  });

  // Unique composite ID for Hive storage
  String get compositeId => '${userId}_${studyCardId}_$tagId';
}
