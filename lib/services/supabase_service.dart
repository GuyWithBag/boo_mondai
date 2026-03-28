// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/supabase_service.dart
// PURPOSE: Single access point for all Supabase operations
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:boo_mondai/services/app_exception.dart';

class SupabaseService {
  SupabaseClient get _client => Supabase.instance.client;

  // ── Auth ────────────────────────────────────────────
  Future<AuthResponse> signIn(String email, String password) async {
    try {
      return await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } on AuthException catch (e) {
      throw AppException(e.message, code: e.statusCode);
    }
  }

  Future<AuthResponse> signUp(String email, String password) async {
    try {
      return await _client.auth.signUp(email: email, password: password);
    } on AuthException catch (e) {
      throw AppException(e.message, code: e.statusCode);
    }
  }

  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } on AuthException catch (e) {
      throw AppException(e.message, code: e.statusCode);
    }
  }

  Session? get currentSession => _client.auth.currentSession;
  User? get currentUser => _client.auth.currentUser;

  // ── Profiles ────────────────────────────────────────
  Future<Map<String, dynamic>?> getProfile(String userId) async {
    try {
      final response =
          await _client.from('profiles').select().eq('id', userId).maybeSingle();
      return response;
    } on PostgrestException catch (e) {
      throw AppException(e.message, code: e.code);
    }
  }

  Future<void> upsertProfile(Map<String, dynamic> data) async {
    try {
      await _client.from('profiles').upsert(data);
    } on PostgrestException catch (e) {
      throw AppException(e.message, code: e.code);
    }
  }

  // ── Decks ───────────────────────────────────────────
  Future<List<Map<String, dynamic>>> fetchDecks({bool publicOnly = true}) async {
    try {
      var query = _client.from('decks').select(
            '*, source_deck:decks!source_deck_id(creator_id)',
          );
      if (publicOnly) {
        query = query.eq('is_public', true);
      }
      final response = await query.order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } on PostgrestException catch (e) {
      throw AppException(e.message, code: e.code);
    }
  }

  Future<List<Map<String, dynamic>>> fetchUserDecks(String userId) async {
    try {
      final response = await _client
          .from('decks')
          .select()
          .eq('creator_id', userId)
          .order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } on PostgrestException catch (e) {
      throw AppException(e.message, code: e.code);
    }
  }

  Future<Map<String, dynamic>> insertDeck(Map<String, dynamic> data) async {
    try {
      final response =
          await _client.from('decks').insert(data).select().single();
      return response;
    } on PostgrestException catch (e) {
      throw AppException(e.message, code: e.code);
    }
  }

  Future<void> updateDeck(String id, Map<String, dynamic> data) async {
    try {
      await _client.from('decks').update(data).eq('id', id);
    } on PostgrestException catch (e) {
      throw AppException(e.message, code: e.code);
    }
  }

  Future<void> deleteDeck(String id) async {
    try {
      await _client.from('decks').delete().eq('id', id);
    } on PostgrestException catch (e) {
      throw AppException(e.message, code: e.code);
    }
  }

  // ── Cards ───────────────────────────────────────────

  /// Fetches all cards for [deckId] with their content nodes joined:
  /// notes, mc_options, fitb_segments, mm_pairs.
  Future<List<Map<String, dynamic>>> fetchCards(String deckId) async {
    try {
      final response = await _client
          .from('deck_cards')
          .select(
            '*, notes(*), mc_options(*), fitb_segments(*), mm_pairs!card_id(*)',
          )
          .eq('deck_id', deckId)
          .order('sort_order');
      return List<Map<String, dynamic>>.from(response);
    } on PostgrestException catch (e) {
      throw AppException(e.message, code: e.code);
    }
  }

  Future<Map<String, dynamic>> insertCard(Map<String, dynamic> data) async {
    try {
      final response =
          await _client.from('deck_cards').insert(data).select().single();
      return response;
    } on PostgrestException catch (e) {
      throw AppException(e.message, code: e.code);
    }
  }

  Future<void> updateCard(String id, Map<String, dynamic> data) async {
    try {
      await _client.from('deck_cards').update(data).eq('id', id);
    } on PostgrestException catch (e) {
      throw AppException(e.message, code: e.code);
    }
  }

  Future<void> deleteCard(String id) async {
    try {
      final deleted =
          await _client.from('deck_cards').delete().eq('id', id).select();
      if (deleted.isEmpty) {
        throw AppException('Card not found or permission denied');
      }
    } on PostgrestException catch (e) {
      throw AppException(e.message, code: e.code);
    }
  }

  Future<Map<String, dynamic>?> insertNote(Map<String, dynamic> data) async {
    try {
      final response =
          await _client.from('notes').insert(data).select().single();
      return response;
    } on PostgrestException catch (e) {
      throw AppException(e.message, code: e.code);
    }
  }

  Future<Map<String, dynamic>?> insertMCOption(
      Map<String, dynamic> data) async {
    try {
      final response =
          await _client.from('mc_options').insert(data).select().single();
      return response;
    } on PostgrestException catch (e) {
      throw AppException(e.message, code: e.code);
    }
  }

  Future<Map<String, dynamic>?> insertFITBSegment(
      Map<String, dynamic> data) async {
    try {
      final response =
          await _client.from('fitb_segments').insert(data).select().single();
      return response;
    } on PostgrestException catch (e) {
      throw AppException(e.message, code: e.code);
    }
  }

  Future<Map<String, dynamic>?> insertMMPair(
      Map<String, dynamic> data) async {
    try {
      final response =
          await _client.from('mm_pairs').insert(data).select().single();
      return response;
    } on PostgrestException catch (e) {
      throw AppException(e.message, code: e.code);
    }
  }

  // ── Local-first deck push helpers ────────────────────

  /// Upserts a single deck_card row. Does NOT touch child tables.
  Future<void> upsertCardRow(Map<String, dynamic> data) async {
    try {
      await _client.from('deck_cards').upsert(data);
    } on PostgrestException catch (e) {
      throw AppException(e.message, code: e.code);
    }
  }

  /// Deletes all content-node rows (notes, mc_options, fitb_segments,
  /// mm_pairs) for [cardId] in one parallel batch.
  Future<void> deleteChildrenByCardId(String cardId) async {
    try {
      await Future.wait([
        _client.from('notes').delete().eq('card_id', cardId),
        _client.from('mc_options').delete().eq('card_id', cardId),
        _client.from('fitb_segments').delete().eq('card_id', cardId),
        _client.from('mm_pairs').delete().eq('card_id', cardId),
      ]);
    } on PostgrestException catch (e) {
      throw AppException(e.message, code: e.code);
    }
  }

  /// Deletes remote deck_cards for [deckId] whose IDs are NOT in [keepIds].
  Future<void> deleteOrphanCards(
      String deckId, List<String> keepIds) async {
    try {
      final remote = await _client
          .from('deck_cards')
          .select('id')
          .eq('deck_id', deckId);
      final remoteIds =
          List<Map<String, dynamic>>.from(remote).map((r) => r['id'] as String).toList();
      final toDelete =
          remoteIds.where((id) => !keepIds.contains(id)).toList();
      if (toDelete.isEmpty) return;
      await _client.from('deck_cards').delete().inFilter('id', toDelete);
    } on PostgrestException catch (e) {
      throw AppException(e.message, code: e.code);
    }
  }

  Future<void> batchInsertNotes(List<Map<String, dynamic>> data) async {
    if (data.isEmpty) return;
    try {
      await _client.from('notes').insert(data);
    } on PostgrestException catch (e) {
      throw AppException(e.message, code: e.code);
    }
  }

  Future<void> batchInsertMCOptions(List<Map<String, dynamic>> data) async {
    if (data.isEmpty) return;
    try {
      await _client.from('mc_options').insert(data);
    } on PostgrestException catch (e) {
      throw AppException(e.message, code: e.code);
    }
  }

  Future<void> batchInsertFITBSegments(
      List<Map<String, dynamic>> data) async {
    if (data.isEmpty) return;
    try {
      await _client.from('fitb_segments').insert(data);
    } on PostgrestException catch (e) {
      throw AppException(e.message, code: e.code);
    }
  }

  Future<void> batchInsertMMPairs(List<Map<String, dynamic>> data) async {
    if (data.isEmpty) return;
    try {
      await _client.from('mm_pairs').insert(data);
    } on PostgrestException catch (e) {
      throw AppException(e.message, code: e.code);
    }
  }

  // ── Quiz ────────────────────────────────────────────
  Future<Map<String, dynamic>> insertQuizSession(
      Map<String, dynamic> data) async {
    try {
      final response =
          await _client.from('quiz_sessions').insert(data).select().single();
      return response;
    } on PostgrestException catch (e) {
      throw AppException(e.message, code: e.code);
    }
  }

  Future<void> updateQuizSession(
      String id, Map<String, dynamic> data) async {
    try {
      await _client.from('quiz_sessions').update(data).eq('id', id);
    } on PostgrestException catch (e) {
      throw AppException(e.message, code: e.code);
    }
  }

  Future<void> insertQuizAnswer(Map<String, dynamic> data) async {
    try {
      await _client.from('quiz_answers').insert(data);
    } on PostgrestException catch (e) {
      throw AppException(e.message, code: e.code);
    }
  }

  /// Inserts multiple quiz answers in a single round-trip.
  Future<void> batchInsertQuizAnswers(
      List<Map<String, dynamic>> answers) async {
    if (answers.isEmpty) return;
    try {
      await _client.from('quiz_answers').insert(answers);
    } on PostgrestException catch (e) {
      throw AppException(e.message, code: e.code);
    }
  }

  // ── FSRS ────────────────────────────────────────────
  Future<void> upsertFsrsCard(Map<String, dynamic> data) async {
    try {
      await _client.from('fsrs_cards').upsert(data);
    } on PostgrestException catch (e) {
      throw AppException(e.message, code: e.code);
    }
  }

  Future<void> insertReviewLog(Map<String, dynamic> data) async {
    try {
      await _client.from('review_logs').insert(data);
    } on PostgrestException catch (e) {
      throw AppException(e.message, code: e.code);
    }
  }

  // ── Leaderboard ─────────────────────────────────────
  Future<List<Map<String, dynamic>>> fetchLeaderboard({
    String? targetLanguage,
  }) async {
    try {
      var query = _client.from('leaderboard').select();
      if (targetLanguage != null) {
        query = query.eq('target_language', targetLanguage);
      }
      final response = await query.order('quiz_score', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } on PostgrestException catch (e) {
      throw AppException(e.message, code: e.code);
    }
  }

  // ── Streaks ─────────────────────────────────────────
  Future<void> upsertStreak(Map<String, dynamic> data) async {
    try {
      await _client.from('streaks').upsert(data);
    } on PostgrestException catch (e) {
      throw AppException(e.message, code: e.code);
    }
  }

  Future<Map<String, dynamic>?> fetchStreak(String userId) async {
    try {
      return await _client
          .from('streaks')
          .select()
          .eq('user_id', userId)
          .maybeSingle();
    } on PostgrestException catch (e) {
      throw AppException(e.message, code: e.code);
    }
  }

  // ── Research ────────────────────────────────────────
  Future<List<Map<String, dynamic>>> fetchResearchCodes({
    String? createdBy,
  }) async {
    try {
      var query = _client.from('research_codes').select();
      if (createdBy != null) {
        query = query.eq('created_by', createdBy);
      }
      final response = await query.order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } on PostgrestException catch (e) {
      throw AppException(e.message, code: e.code);
    }
  }

  Future<Map<String, dynamic>> insertResearchCode(
      Map<String, dynamic> data) async {
    try {
      final response =
          await _client.from('research_codes').insert(data).select().single();
      return response;
    } on PostgrestException catch (e) {
      throw AppException(e.message, code: e.code);
    }
  }

  Future<Map<String, dynamic>> redeemResearchCode(
      String code, String userId) async {
    try {
      final codeRow = await _client
          .from('research_codes')
          .select()
          .eq('code', code)
          .isFilter('used_by', null)
          .single();

      await _client.from('research_codes').update({
        'used_by': userId,
        'used_at': DateTime.now().toIso8601String(),
      }).eq('id', codeRow['id']);

      return codeRow;
    } on PostgrestException catch (e) {
      throw AppException(e.message, code: e.code);
    }
  }

  Future<void> insertSurveyResponse(
      String table, Map<String, dynamic> data) async {
    try {
      await _client.from(table).insert(data);
    } on PostgrestException catch (e) {
      throw AppException(e.message, code: e.code);
    }
  }

  Future<void> insertVocabularyTest(Map<String, dynamic> data) async {
    try {
      await _client.from('research_vocabulary_test').insert(data);
    } on PostgrestException catch (e) {
      throw AppException(e.message, code: e.code);
    }
  }

  Future<Map<String, List<Map<String, dynamic>>>>
      fetchAllResearchData() async {
    try {
      final results = await Future.wait([
        _client.from('research_users').select('*, profiles:user_id(display_name)'),
        _client.from('research_codes').select(),
        _client.from('research_proficiency_screener').select(),
        _client.from('research_language_interest').select(),
        _client.from('research_vocabulary_test').select(),
        _client.from('research_experience_survey').select(),
        _client.from('research_preview_usefulness').select(),
        _client.from('research_fsrs_usefulness').select(),
        _client.from('research_ugc_perception').select(),
        _client.from('research_sus').select(),
      ]);

      return {
        'research_users': List<Map<String, dynamic>>.from(results[0]),
        'research_codes': List<Map<String, dynamic>>.from(results[1]),
        'proficiency_screener': List<Map<String, dynamic>>.from(results[2]),
        'language_interest': List<Map<String, dynamic>>.from(results[3]),
        'vocabulary_test': List<Map<String, dynamic>>.from(results[4]),
        'experience_survey': List<Map<String, dynamic>>.from(results[5]),
        'preview_usefulness': List<Map<String, dynamic>>.from(results[6]),
        'fsrs_usefulness': List<Map<String, dynamic>>.from(results[7]),
        'ugc_perception': List<Map<String, dynamic>>.from(results[8]),
        'sus': List<Map<String, dynamic>>.from(results[9]),
      };
    } on PostgrestException catch (e) {
      throw AppException(e.message, code: e.code);
    }
  }

  Future<void> insertResearchUser(Map<String, dynamic> data) async {
    try {
      await _client.from('research_users').insert(data);
    } on PostgrestException catch (e) {
      throw AppException(e.message, code: e.code);
    }
  }

  // ── Storage ─────────────────────────────────────────
  Future<String> uploadImage(
      String bucket, String path, Uint8List bytes) async {
    try {
      await _client.storage.from(bucket).uploadBinary(path, bytes);
      return _client.storage.from(bucket).getPublicUrl(path);
    } catch (e) {
      throw AppException('Failed to upload image: $e');
    }
  }

  Future<void> deleteImage(String bucket, String path) async {
    try {
      await _client.storage.from(bucket).remove([path]);
    } catch (e) {
      throw AppException('Failed to delete image: $e');
    }
  }
}
