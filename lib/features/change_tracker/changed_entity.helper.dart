import 'package:boo_mondai/lib.barrel.dart' show ChangedProperty, ChangeType;

abstract final class ChangedEntityHelper {
  static List<ChangedProperty<Object?>> getChangedProperties({
    required Map<String, Object?> before,
    required Map<String, Object?> after,
    Set<String> ignoredKeys = const {},
  }) {
    final keys = {...before.keys, ...after.keys}
      ..removeWhere(ignoredKeys.contains);
    final sortedKeys = keys.toList()..sort();

    return [
      for (final key in sortedKeys)
        if (!_areEqual(before[key], after[key]))
          ChangedProperty<Object?>(
            propertyLabel: key,
            type: ChangeType.modified,
            before: before[key],
            after: after[key],
          ),
    ];
  }

  static bool _areEqual(Object? before, Object? after) {
    if (before == after) return true;

    if (before is DateTime && after is DateTime) {
      return before.toUtc().millisecondsSinceEpoch ==
          after.toUtc().millisecondsSinceEpoch;
    }

    if (before is List && after is List) {
      if (before.length != after.length) return false;
      for (var i = 0; i < before.length; i++) {
        if (!_areEqual(before[i], after[i])) return false;
      }
      return true;
    }

    if (before is Map && after is Map) {
      final beforeKeys = before.keys.toSet();
      final afterKeys = after.keys.toSet();
      if (beforeKeys.length != afterKeys.length ||
          !beforeKeys.containsAll(afterKeys)) {
        return false;
      }
      for (final key in beforeKeys) {
        if (!_areEqual(before[key], after[key])) return false;
      }
      return true;
    }

    return false;
  }
}
