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
      var query = _client.from('decks').select();
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
  Future<List<Map<String, dynamic>>> fetchCards(String deckId) async {
    try {
      final response = await _client
          .from('deck_cards')
          .select()
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
      await _client.from('deck_cards').delete().eq('id', id);
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
        _client.from('research_users').select(),
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
