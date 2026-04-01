// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/supabase/supabase_deck_service.dart
// PURPOSE: Supabase CRUD for decks
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'supabase_service.dart';

class SupabaseDeckService extends SupabaseService {
  Future<List<Map<String, dynamic>>> fetchDecks({
    bool publicOnly = true,
  }) =>
      guard(() async {
        var query = client.from('decks').select(
              '*, source_deck:decks!source_deck_id(creator_id)',
            );
        if (publicOnly) {
          query = query.eq('is_public', true);
        }
        final response = await query.order('created_at', ascending: false);
        return List<Map<String, dynamic>>.from(response);
      });

  Future<List<Map<String, dynamic>>> fetchUserDecks(String userId) =>
      guard(() async {
        final response = await client
            .from('decks')
            .select()
            .eq('creator_id', userId)
            .order('created_at', ascending: false);
        return List<Map<String, dynamic>>.from(response);
      });

  Future<Map<String, dynamic>> insertDeck(Map<String, dynamic> data) =>
      guard(() => client.from('decks').insert(data).select().single());

  Future<void> updateDeck(String id, Map<String, dynamic> data) =>
      guard(() => client.from('decks').update(data).eq('id', id));

  Future<void> upsertDeck(Map<String, dynamic> data) =>
      guard(() => client.from('decks').upsert(data));

  Future<void> deleteDeck(String id) =>
      guard(() => client.from('decks').delete().eq('id', id));
}
