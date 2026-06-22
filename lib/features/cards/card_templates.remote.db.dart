// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/database/remote/card_template_tag_remote_db.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show CardTemplate, SupabaseRemoteDB, CardTemplateMapper;

class CardTemplatesRemoteDB extends SupabaseRemoteDB<CardTemplate> {
  @override
  String get tableName => 'card_templates';

  @override
  CardTemplate Function(Map<String, dynamic>) get fromMap =>
      CardTemplateMapper.fromMap;

  @override
  Map<String, dynamic> toMap(CardTemplate item) => item.toMap();

  @override
  Map<String, Object?> primaryKeyFromItem(CardTemplate item) => {'id': item.id};

  @override
  String get upsertConflictTarget => 'id';

  @override
  String get defaultSelect => _cardTemplateWithRelationsSelect;

  @override
  Set<String> get joinedFields => const {
    'tags',
    'options',
    'segments',
    'pairs',
    'attachments',
  };

  /// Fetches a single page of templates for [deckId], ordered by sort_order.
  /// [offset] is the number of already-fetched templates to skip.
  Future<List<CardTemplate>> selectManyPaged({
    required String deckId,
    required int offset,
    required int pageSize,
  }) async {
    final rows = await client
        .from(tableName)
        .select(defaultSelect)
        .eq('deck_id', deckId)
        .order('sort_order', ascending: true)
        .range(offset, offset + pageSize - 1);

    return rows.map<CardTemplate>(fromMap).toList();
  }
}

const _cardTemplateWithRelationsSelect =
    '*, tags(*), options:multiple_choice_options(*), segments:fill_in_the_blank_segments(*), pairs:match_madness_pairs!match_madness_pairs_template_id_fkey(*), attachments:card_template_attachments(*)';
