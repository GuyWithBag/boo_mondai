import 'package:boo_mondai/lib.barrel.dart' show UserStudyCardTag, HiveLocalDB;

class UserStudyCardTagsLocalDB extends HiveLocalDB<UserStudyCardTag> {
  @override
  String get boxName => 'user_study_cards_tags';

  @override
  Map<String, Object?> primaryKeyFromItem(UserStudyCardTag item) => {
    'user_id': item.userId,
    'study_cards_id': item.studyCardId,
    'tag_id': item.tagId,
  };

  // Custom Method: Get all tags applied to a specific review card
  List<UserStudyCardTag> getTagsForCard(String studyCardId) => guardSync(
    () => box.values.where((item) => item.studyCardId == studyCardId).toList(),
    action: 'getTagsForCard($studyCardId)',
  );
}
