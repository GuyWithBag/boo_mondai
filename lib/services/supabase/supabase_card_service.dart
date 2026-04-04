// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/supabase/supabase_card_service.dart
// PURPOSE: Supabase CRUD for deck cards and their content nodes
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/services/app_exception.dart';
import 'supabase_service.dart';

class SupabaseCardService extends SupabaseService {
  // ── Card rows ─────────────────────────────────────────

  /// Fetches all cards for [deckId] with joined content nodes.
  Future<List<Map<String, dynamic>>> fetchCards(String deckId) =>
      guard(() async {
        final response = await client
            .from('card_templates')
            .select(
              '*, notes(*), mc_options(*), fitb_segments(*), mm_pairs!card_id(*)',
            )
            .eq('deckId', deckId)
            .order('sortOrder');
        return List<Map<String, dynamic>>.from(response);
      });

  Future<Map<String, dynamic>> insertCard(Map<String, dynamic> data) =>
      guard(() => client.from('card_templates').insert(data).select().single());

  Future<void> updateCard(String id, Map<String, dynamic> data) =>
      guard(() => client.from('card_templates').update(data).eq('id', id));

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

  /// Upserts a single deck_card row. Does NOT touch child tables.
  Future<void> upsertCardRow(Map<String, dynamic> data) =>
      guard(() => client.from('card_templates').upsert(data));

  /// Deletes remote card_templates for [deckId] whose IDs are NOT in [keepIds].
  Future<void> deleteOrphanCards(String deckId, List<String> keepIds) =>
      guard(() async {
        final remote = await client
            .from('card_templates')
            .select('id')
            .eq('deckId', deckId);
        final remoteIds = List<Map<String, dynamic>>.from(remote)
            .map((r) => r['id'] as String)
            .toList();
        final toDelete =
            remoteIds.where((id) => !keepIds.contains(id)).toList();
        if (toDelete.isEmpty) return;
        await client.from('card_templates').delete().inFilter('id', toDelete);
      });

  // ── Content node CRUD ─────────────────────────────────

  Future<Map<String, dynamic>?> insertNote(Map<String, dynamic> data) =>
      guard(() => client.from('notes').insert(data).select().single());

  Future<Map<String, dynamic>?> insertMCOption(Map<String, dynamic> data) =>
      guard(() => client.from('mc_options').insert(data).select().single());

  Future<Map<String, dynamic>?> insertFITBSegment(
          Map<String, dynamic> data) =>
      guard(() => client.from('fitb_segments').insert(data).select().single());

  Future<Map<String, dynamic>?> insertMMPair(Map<String, dynamic> data) =>
      guard(() => client.from('mm_pairs').insert(data).select().single());

  /// Deletes all content-node rows for [cardId] in parallel.
  Future<void> deleteChildrenByCardId(String cardId) => guard(() async {
        await Future.wait([
          client.from('notes').delete().eq('card_id', cardId),
          client.from('mc_options').delete().eq('card_id', cardId),
          client.from('fitb_segments').delete().eq('card_id', cardId),
          client.from('mm_pairs').delete().eq('card_id', cardId),
        ]);
      });

  // ── Batch inserts ─────────────────────────────────────

  Future<void> batchInsertNotes(List<Map<String, dynamic>> data) =>
      _batchInsert('notes', data);

  Future<void> batchInsertMCOptions(List<Map<String, dynamic>> data) =>
      _batchInsert('mc_options', data);

  Future<void> batchInsertFITBSegments(List<Map<String, dynamic>> data) =>
      _batchInsert('fitb_segments', data);

  Future<void> batchInsertMMPairs(List<Map<String, dynamic>> data) =>
      _batchInsert('mm_pairs', data);

  Future<void> _batchInsert(String table, List<Map<String, dynamic>> data) {
    if (data.isEmpty) return Future.value();
    return guard(() => client.from(table).insert(data));
  }
}
