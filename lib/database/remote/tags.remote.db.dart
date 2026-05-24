// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/database/remote/tag_remote_db.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/database/database.barrel.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';

class TagsRemoteDB extends SupabaseRemoteDB<Tag> {
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

  Future<List<Tag>> selectManyFiltered({
    String query = '',
    String? userId,
    bool includeGlobalTags = true,
    BrowseSortField sortField = BrowseSortField.letters,
    BrowseSortDirection sortDirection = BrowseSortDirection.ascending,
    int? limit,
  }) => guard(() async {
    dynamic request = client.from(tableName).select();

    final normalizedQuery = query.trim();
    if (normalizedQuery.isNotEmpty) {
      request = request.ilike('name', '%$normalizedQuery%');
    }

    if (userId != null) {
      request = includeGlobalTags
          ? request.or('user_id.eq.$userId,user_id.is.null')
          : request.eq('user_id', userId);
    }

    request = request.order(
      _columnForSortField(sortField),
      ascending: sortDirection == BrowseSortDirection.ascending,
    );

    if (limit != null) {
      request = request.limit(limit);
    }

    final response = await request;
    return List<Map<String, dynamic>>.from(response).map(fromMap).toList();
  }, action: 'selectManyFiltered($query, $userId)');

  String _columnForSortField(BrowseSortField field) {
    return switch (field) {
      BrowseSortField.letters => 'name',
      BrowseSortField.createdAt => 'created_at',
      BrowseSortField.updatedAt => 'created_at',
    };
  }
}
