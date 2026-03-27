// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: test/providers/leaderboard_provider_test.dart
// PURPOSE: Unit tests for LeaderboardProvider — fetch, sort, and language filter
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../helpers/mock_supabase_service.mocks.dart';
import 'package:boo_mondai/providers/providers.dart';
import 'package:boo_mondai/services/services.dart';

void main() {
  late LeaderboardProvider provider;
  late MockSupabaseService mockSupabase;

  setUp(() {
    mockSupabase = MockSupabaseService();
    provider = LeaderboardProvider(supabaseService: mockSupabase);
  });

  Map<String, dynamic> makeEntry({
    required String userId,
    required String name,
    required int score,
    String? language,
  }) =>
      {
        'user_id': userId,
        'display_name': name,
        'target_language': language,
        'quiz_score': score,
        'review_count': 10,
        'current_streak': 3,
      };

  group('initial state', () {
    test('has empty entries and no error', () {
      expect(provider.entries, isEmpty);
      expect(provider.filteredLanguage, isNull);
      expect(provider.isLoading, false);
      expect(provider.error, isNull);
    });
  });

  group('fetchLeaderboard', () {
    test('success populates entries (pre-sorted by Supabase)', () async {
      final data = [
        makeEntry(userId: 'u1', name: 'Alice', score: 100),
        makeEntry(userId: 'u2', name: 'Bob', score: 50),
      ];

      when(mockSupabase.fetchLeaderboard())
          .thenAnswer((_) async => data);

      await provider.fetchLeaderboard();

      expect(provider.entries.length, 2);
      expect(provider.entries.first.quizScore, 100);
      expect(provider.entries.last.quizScore, 50);
      expect(provider.isLoading, false);
      expect(provider.error, isNull);
    });

    test('with language filter passes parameter to service', () async {
      when(mockSupabase.fetchLeaderboard(targetLanguage: 'japanese'))
          .thenAnswer((_) async => [
                makeEntry(
                    userId: 'u1',
                    name: 'Alice',
                    score: 80,
                    language: 'japanese'),
              ]);

      await provider.fetchLeaderboard(targetLanguage: 'japanese');

      expect(provider.entries.length, 1);
      expect(provider.filteredLanguage, 'japanese');
      verify(mockSupabase.fetchLeaderboard(targetLanguage: 'japanese'))
          .called(1);
    });

    test('failure sets error', () async {
      when(mockSupabase.fetchLeaderboard())
          .thenThrow(const AppException('Network error'));

      await provider.fetchLeaderboard();

      expect(provider.error, 'Network error');
      expect(provider.entries, isEmpty);
    });
  });

  group('setLanguageFilter', () {
    test('sets language and re-fetches', () async {
      when(mockSupabase.fetchLeaderboard(targetLanguage: 'korean'))
          .thenAnswer((_) async => []);

      provider.setLanguageFilter('korean');

      expect(provider.filteredLanguage, 'korean');
      // Wait for the async fetch triggered by setLanguageFilter
      await Future<void>.delayed(Duration.zero);
      verify(mockSupabase.fetchLeaderboard(targetLanguage: 'korean'))
          .called(1);
    });

    test('null language clears filter', () async {
      when(mockSupabase.fetchLeaderboard())
          .thenAnswer((_) async => []);

      provider.setLanguageFilter(null);

      expect(provider.filteredLanguage, isNull);
    });
  });
}
