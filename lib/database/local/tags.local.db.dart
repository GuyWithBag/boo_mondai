// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/database/local/tag_local_db.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/models/dtos/tag.dto.dart';
import 'package:boo_mondai/database/local/hive.local.db.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';

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
    BrowseSortField sortField = BrowseSortField.letters,
    BrowseSortDirection sortDirection = BrowseSortDirection.ascending,
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
    required BrowseSortField field,
    required BrowseSortDirection direction,
  }) {
    final sorted = tags.toList();
    sorted.sort((a, b) {
      final comparison = switch (field) {
        BrowseSortField.letters => a.name.toLowerCase().compareTo(
          b.name.toLowerCase(),
        ),
        BrowseSortField.createdAt => a.createdAt.compareTo(b.createdAt),
        BrowseSortField.updatedAt => a.createdAt.compareTo(b.createdAt),
      };

      return direction == BrowseSortDirection.ascending
          ? comparison
          : -comparison;
    });
    return sorted;
  }
}
