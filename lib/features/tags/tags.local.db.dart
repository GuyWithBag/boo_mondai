// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/database/local/tag_local_db.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show HiveLocalDB, Tag, SearchSortDirection, TagSortField;

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

  List<Tag> filterTags({
    String query = '',
    String? userId,
    bool includeGlobalTags = true,
    TagSortField sortField = TagSortField.letters,
    SearchSortDirection sortDirection = SearchSortDirection.ascending,
  }) => guardSync(() {
    final normalizedQuery = query.trim().toLowerCase();
    final filtered = box.values.where((tag) {
      if (normalizedQuery.isNotEmpty &&
          !tag.name.toLowerCase().contains(normalizedQuery)) {
        return false;
      }

      if (userId == null) return true;
      return tag.userId == userId || (includeGlobalTags && tag.userId == null);
    });

    return _sortTags(filtered, field: sortField, direction: sortDirection);
  }, action: 'filterTags($query, $userId, $sortField, $sortDirection)');

  List<Tag> _sortTags(
    Iterable<Tag> tags, {
    required TagSortField field,
    required SearchSortDirection direction,
  }) {
    final sorted = tags.toList();
    sorted.sort((a, b) {
      final comparison = switch (field) {
        TagSortField.letters => a.name.toLowerCase().compareTo(
          b.name.toLowerCase(),
        ),
        TagSortField.createdAt => a.createdAt.compareTo(b.createdAt),
        TagSortField.updatedAt => a.createdAt.compareTo(b.createdAt),
      };

      return direction == SearchSortDirection.ascending
          ? comparison
          : -comparison;
    });
    return sorted;
  }
}
