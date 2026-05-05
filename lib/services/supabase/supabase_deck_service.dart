// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/supabase/supabase_deck_service.dart
// PURPOSE: Supabase CRUD for decks
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'supabase_service.dart';

class SupabaseDeckService extends SupabaseService {
  /// Fetches all public decks (or all decks when [publicOnly] is false),
  /// with a joined source-deck authorId for attribution display.
  Future<List<Map<String, dynamic>>> fetchDecks({bool publicOnly = true}) =>
      guard(() async {
        var query = client
            .from('decks')
            .select('*, source_deck:decks!sourceDeckId(authorId)');
        if (publicOnly) query = query.eq('isPublic', true);
        final response = await query.order('createdAt', ascending: false);
        return List<Map<String, dynamic>>.from(response);
      });

  Future<List<Map<String, dynamic>>> fetchUserDecks(String userId) =>
      fetchAll('decks', filters: {'authorId': userId}, orderBy: 'createdAt');

  Future<Map<String, dynamic>> insertDeck(Map<String, dynamic> data) =>
      insertOne('decks', data);

  Future<void> updateDeck(String id, Map<String, dynamic> data) =>
      updateById('decks', id, data);

  Future<void> upsertDeck(Map<String, dynamic> data) =>
      upsertRow('decks', data);

  Future<void> deleteDeck(String id) => deleteById('decks', id);
}
