// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/database/local/tag_local_db.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/models/dtos/tag.dto.dart';
import 'package:boo_mondai/database/local/hive.local.db.dart';

class TagLocalDB extends HiveLocalDB<Tag> {
  @override
  String get boxName => 'tags';

  @override
  Map<String, Object?> primaryKeyFromItem(Tag item) => {'id': item.id};

  // Custom Method: Get only tags owned by the current user
  List<Tag> getByCurrentUser(String currentUserId) => guardSync(
    () => box.values.where((tag) => tag.userId == currentUserId).toList(),
    action: 'getByCurrentUser($currentUserId)',
  );
}
