// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/database/remote/card_template_tag_remote_db.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
import 'package:boo_mondai/database/database.barrel.dart';
import 'package:boo_mondai/models/models.barrel.dart';

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
  };
}

const _cardTemplateWithRelationsSelect =
    '*, tags(*), options:multiple_choice_options(*), segments:fill_in_the_blank_segments(*), pairs:match_madness_pairs!match_madness_pairs_template_id_fkey(*)';
