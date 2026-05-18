// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/database/remote/user_review_card_tag_remote_db.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/database/database.barrel.dart';
import 'package:boo_mondai/models/dtos/user_review_card_tag.dto.dart';

class UserReviewCardTagsRemoteDB extends SupabaseRemoteDB<UserReviewCardTag> {
  @override
  String get tableName => 'user_review_card_tags';

  @override
  UserReviewCardTag Function(Map<String, dynamic>) get fromMap =>
      UserReviewCardTagMapper.fromMap;

  @override
  Map<String, dynamic> toMap(UserReviewCardTag item) => item.toMap();

  @override
  Map<String, Object?> primaryKeyFromItem(UserReviewCardTag item) => {
    'user_id': item.userId,
    'review_card_id': item.reviewCardId,
    'tag_id': item.tagId,
  };

  @override
  String get upsertConflictTarget => 'user_id,review_card_id,tag_id';

  // Override delete because this table uses a composite primary key
  Future<void> deleteComposite({
    required String userId,
    required String reviewCardId,
    required String tagId,
  }) => deleteWhere({
    'user_id': userId,
    'review_card_id': reviewCardId,
    'tag_id': tagId,
  });
}
