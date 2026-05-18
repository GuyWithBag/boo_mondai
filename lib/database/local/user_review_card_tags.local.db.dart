import 'package:boo_mondai/database/database.barrel.dart';
import 'package:boo_mondai/models/dtos/user_review_card_tag.dto.dart';

class UserReviewCardTagsLocalDB extends HiveLocalDB<UserReviewCardTag> {
  @override
  String get boxName => 'user_review_card_tags';

  @override
  Map<String, Object?> primaryKeyFromItem(UserReviewCardTag item) => {
    'user_id': item.userId,
    'review_card_id': item.reviewCardId,
    'tag_id': item.tagId,
  };

  // Custom Method: Get all tags applied to a specific review card
  List<UserReviewCardTag> getTagsForCard(String reviewCardId) => guardSync(
    () =>
        box.values.where((item) => item.reviewCardId == reviewCardId).toList(),
    action: 'getTagsForCard($reviewCardId)',
  );
}
