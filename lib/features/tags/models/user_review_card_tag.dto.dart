// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/dtos/user_review_card_tag.dto.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
import 'package:dart_mappable/dart_mappable.dart';

part 'user_review_card_tag.dto.mapper.dart';

@MappableClass()
class UserReviewCardTag with UserReviewCardTagMappable {
  final String userId;
  final String reviewCardId;
  final String tagId;

  const UserReviewCardTag({
    required this.userId,
    required this.reviewCardId,
    required this.tagId,
  });

  // Unique composite ID for Hive storage
  String get compositeId => '${userId}_${reviewCardId}_$tagId';
}
