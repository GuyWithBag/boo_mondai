// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/database/remote/tag_remote_db.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show Tag, SupabaseRemoteDB, SearchSortDirection, TagMapper, TagSortField;

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
    String? profileId,
    bool includeGlobalTags = true,
    TagSortField sortField = TagSortField.letters,
    SearchSortDirection sortDirection = SearchSortDirection.ascending,
    int? limit,
  }) => guard(() async {
    dynamic request = client.from(tableName).select();

    final normalizedQuery = query.trim();
    if (normalizedQuery.isNotEmpty) {
      request = request.ilike('name', '%$normalizedQuery%');
    }

    if (profileId != null) {
      request = includeGlobalTags
          ? request.or('profile_id.eq.$profileId,profile_id.is.null')
          : request.eq('profile_id', profileId);
    }

    request = request.order(
      _columnForSortField(sortField),
      ascending: sortDirection == SearchSortDirection.ascending,
    );

    if (limit != null) {
      request = request.limit(limit);
    }

    final response = await request;
    return List<Map<String, dynamic>>.from(response).map(fromMap).toList();
  }, action: 'selectManyFiltered($query, $profileId)');

  String _columnForSortField(TagSortField field) {
    return switch (field) {
      TagSortField.letters => 'name',
      TagSortField.createdAt => 'created_at',
      TagSortField.updatedAt => 'created_at',
    };
  }
}
