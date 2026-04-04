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
              '*, source_deck:decks!sourceDeckId(authorId)',
            );
        if (publicOnly) {
          query = query.eq('isPublic', true);
        }
        final response = await query.order('createdAt', ascending: false);
        return List<Map<String, dynamic>>.from(response);
      });

  Future<List<Map<String, dynamic>>> fetchUserDecks(String userId) =>
      guard(() async {
        final response = await client
            .from('decks')
            .select()
            .eq('authorId', userId)
            .order('createdAt', ascending: false);
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
