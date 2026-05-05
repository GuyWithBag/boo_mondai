// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/supabase/supabase_card_service.dart
// PURPOSE: Supabase CRUD for deck cards and their content nodes
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/services/app_exception.dart';
import 'package:boo_mondai/database/database.barrel.dart';

class CardTemplateRemoteDB extends SupabaseRemoteDB<CardTemplate> {
  @override
  String get tableName => 'card_templates';

  @override
  CardTemplate Function(Map<String, dynamic>) get fromMap =>
      CardTemplateMapper.fromMap;

  @override
  Map<String, dynamic> toMap(CardTemplate item) => item.toMap();

  /// Fetches all cards for [deckId] with joined content nodes.
  Future<List<CardTemplate>> fetchCards(String deckId) => guard(() async {
    final response = await client
        .from('card_templates')
        .select(
          '*, notes(*), mc_options(*), fitb_segments(*), mm_pairs!card_id(*)',
        )
        .eq('deck_id', deckId)
        .order('sort_order');
    return List<Map<String, dynamic>>.from(response).map(fromMap).toList();
  });

  Future<void> deleteCard(String id) => guard(() async {
    final deleted = await client
        .from('card_templates')
        .delete()
        .eq('id', id)
        .select();
    if (deleted.isEmpty) {
      throw AppException('Card not found or permission denied');
    }
  });

  /// Deletes remote card_templates for [deckId] whose IDs are NOT in [keepIds].
  Future<void> deleteOrphanCards(String deckId, List<String> keepIds) =>
      guard(() async {
        final remote = await client
            .from('card_templates')
            .select('id')
            .eq('deck_id', deckId);
        final toDelete = List<Map<String, dynamic>>.from(remote)
            .map((r) => r['id'] as String)
            .where((id) => !keepIds.contains(id))
            .toList();
        if (toDelete.isEmpty) return;
        await client.from('card_templates').delete().inFilter('id', toDelete);
      });

  /// Deletes all content-node rows for [cardId] in parallel.
  Future<void> deleteChildrenByCardId(String cardId) => guard(() async {
    await Future.wait([
      client.from('notes').delete().eq('card_id', cardId),
      client.from('mc_options').delete().eq('card_id', cardId),
      client.from('fitb_segments').delete().eq('card_id', cardId),
      client.from('mm_pairs').delete().eq('card_id', cardId),
    ]);
  });

  // ── Batch content-node inserts ────────────────────────
  // Kept here to encapsulate the toMap conversion for each type.

  Future<void> batchInsertNotes(List<Map<String, dynamic>> data) =>
      guard(() => client.from('notes').insert(data));

  Future<void> batchInsertMCOptions(List<MultipleChoiceOption> options) =>
      guard(
        () => client
            .from('mc_options')
            .insert(options.map((o) => o.toMap()).toList()),
      );

  Future<void> batchInsertFITBSegments(List<FillInTheBlankSegment> segments) =>
      guard(
        () => client
            .from('fitb_segments')
            .insert(segments.map((s) => s.toMap()).toList()),
      );

  Future<void> batchInsertMMPairs(List<MatchMadnessPair> pairs) => guard(
    () => client.from('mm_pairs').insert(pairs.map((p) => p.toMap()).toList()),
  );
}
