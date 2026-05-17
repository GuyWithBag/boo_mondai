// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/database/remote/tag_remote_db.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/database/database.barrel.dart';
import 'package:boo_mondai/models/models.barrel.dart';

class TagRemoteDB extends SupabaseRemoteDB<Tag> {
  @override
  String get tableName => 'tags';

  @override
  Tag Function(Map<String, dynamic>) get fromMap => TagMapper.fromMap;

  @override
  Map<String, dynamic> toMap(Tag item) => item.toMap();

  @override
  Map<String, Object?> primaryKeyFromItem(Tag item) => {'id': item.id};

  @override
  String get upsertConflictTarget => 'id';

  // Custom Method: Search tags by name for autocomplete UI
  Future<List<Tag>> searchTags(String query) => guard(() async {
    final response = await client
        .from(tableName)
        .select()
        .ilike('name', '%$query%')
        .limit(10);
    return List<Map<String, dynamic>>.from(response).map(fromMap).toList();
  }, action: 'searchTags($query)');
}
