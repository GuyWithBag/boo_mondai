// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/database/remote/user_study_cards_tag_remote_db.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show UserStudyCardTag, SupabaseRemoteDB, UserStudyCardTagMapper;

class UserStudyCardTagsRemoteDB extends SupabaseRemoteDB<UserStudyCardTag> {
  @override
  String get tableName => 'user_study_cards_tags';

  @override
  UserStudyCardTag Function(Map<String, dynamic>) get fromMap =>
      UserStudyCardTagMapper.fromMap;

  @override
  Map<String, dynamic> toMap(UserStudyCardTag item) => item.toMap();

  @override
  Map<String, Object?> primaryKeyFromItem(UserStudyCardTag item) => {
    'profile_id': item.profileId,
    'study_cards_id': item.studyCardId,
    'tag_id': item.tagId,
  };

  @override
  String get upsertConflictTarget => 'user_id,study_cards_id,tag_id';

  // Override delete because this table uses a composite primary key
  Future<void> deleteComposite({
    required String profileId,
    required String studyCardId,
    required String tagId,
  }) => deleteWhere({
    'profile_id': profileId,
    'study_cards_id': studyCardId,
    'tag_id': tagId,
  });
}
