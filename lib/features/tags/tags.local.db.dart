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
  List<Tag> getByCurrentProfile(String currentUserId) => guardSync(
    () => box.values.where((tag) => tag.profileId == currentUserId).toList(),
    action: 'getByCurrentProfile($currentUserId)',
  );

  List<Tag> selectManyByIds(Set<String> ids) => guardSync(
    () => box.values.where((tag) => ids.contains(tag.id)).toList(),
    action: 'selectManyByIds(${ids.length} ids)',
  );

  List<Tag> filterTags({
    String query = '',
    String? profileId,
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

      if (profileId == null) return true;
      return tag.profileId == profileId ||
          (includeGlobalTags && tag.profileId == null);
    });

    return _sortTags(filtered, field: sortField, direction: sortDirection);
  }, action: 'filterTags($query, $profileId, $sortField, $sortDirection)');

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
