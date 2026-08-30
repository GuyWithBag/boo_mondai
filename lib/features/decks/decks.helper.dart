import 'package:boo_mondai/core/services/uuid.dart';

abstract final class DecksHelper {
  static Map<String, dynamic> readRequiredMap(
    Map<String, dynamic> parent,
    String key,
  ) {
    final value = parent[key];
    if (value is! Map) {
      throw FormatException('Expected "$key" to be a map.');
    }
    return Map<String, dynamic>.from(value);
  }

  static List<Map<String, dynamic>> readMapList(
    Map<String, dynamic> parent,
    String key,
  ) {
    final value = parent[key];
    if (value == null) return const [];
    if (value is! List) {
      throw FormatException('Expected "$key" to be a list.');
    }

    return [
      for (final item in value)
        if (item is Map)
          Map<String, dynamic>.from(item)
        else
          throw FormatException('Expected "$key" item to be a map.'),
    ];
  }

  static Map<String, dynamic> hydrateMapForImport(
    Map<String, dynamic> map, {
    required String profileId,
    String? deckId,
    DateTime? now,
  }) {
    final resolvedNow = now ?? DateTime.now();

    return {
      ...map,
      'id': deckId ?? uuid.v7(),
      'profile_id': profileId,
      'created_at': map['created_at'] ?? resolvedNow,
      'updated_at': map['updated_at'] ?? resolvedNow,
      'visibility_state': map['visibility_state'] ?? 'private',
      'is_published': map['is_published'] ?? false,
      'card_count': map['card_count'] ?? 0,
    };
  }

  static Map<String, dynamic> hydrateCardTemplateMapForImport(
    Map<String, dynamic> map, {
    required String deckId,
    String? templateId,
    DateTime? now,
  }) {
    final resolvedNow = now ?? DateTime.now();
    final resolvedTemplateId = templateId ?? uuid.v7();
    final hydrated = {
      ...map,
      'id': resolvedTemplateId,
      'deck_id': deckId,
      'created_at': map['created_at'] ?? resolvedNow,
      'updated_at': map['updated_at'] ?? resolvedNow,
      'sort_order': map['sort_order'] ?? 0,
    };

    hydrateTemplateChildrenForImport(hydrated, templateId: resolvedTemplateId);

    return hydrated;
  }

  static void hydrateTemplateChildrenForImport(
    Map<String, dynamic> template, {
    required String templateId,
  }) {
    _hydrateChildListForImport(
      template,
      key: 'options',
      parentKey: 'template_id',
      parentId: templateId,
      includeDisplayOrder: true,
    );
    _hydrateChildListForImport(
      template,
      key: 'accepted_answers',
      parentKey: 'template_id',
      parentId: templateId,
      includeDisplayOrder: true,
    );
    _hydrateChildListForImport(
      template,
      key: 'segments',
      parentKey: 'card_id',
      parentId: templateId,
      includeDisplayOrder: false,
    );
    _hydrateChildListForImport(
      template,
      key: 'pairs',
      parentKey: 'template_id',
      parentId: templateId,
      includeDisplayOrder: true,
    );
  }

  static void _hydrateChildListForImport(
    Map<String, dynamic> parent, {
    required String key,
    required String parentKey,
    required String parentId,
    required bool includeDisplayOrder,
  }) {
    final rawItems = parent[key];
    if (rawItems == null) return;
    if (rawItems is! List) {
      throw FormatException('Expected "$key" to be a list.');
    }

    parent[key] = [
      for (final entry in rawItems.asMap().entries)
        _hydrateChildMapForImport(
          entry.value,
          parentKey: parentKey,
          parentId: parentId,
          displayOrder: entry.key,
          includeDisplayOrder: includeDisplayOrder,
        ),
    ];
  }

  static Map<String, dynamic> _hydrateChildMapForImport(
    Object? value, {
    required String parentKey,
    required String parentId,
    required int displayOrder,
    required bool includeDisplayOrder,
  }) {
    if (value is! Map) {
      throw const FormatException('Expected child item to be a map.');
    }

    final map = Map<String, dynamic>.from(value);

    return {
      ...map,
      'id': map['id'] ?? uuid.v7(),
      parentKey: parentId,
      if (includeDisplayOrder)
        'display_order': map['display_order'] ?? displayOrder,
    };
  }
}
