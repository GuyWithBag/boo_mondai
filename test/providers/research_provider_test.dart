// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: test/providers/research_provider_test.dart
// PURPOSE: Unit tests for ResearchProvider — code redemption, generation, surveys, tests, dashboard data
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../helpers/mock_supabase_service.mocks.dart';
import 'package:boo_mondai/providers/providers.dart';
import 'package:boo_mondai/services/services.dart';

void main() {
  late ResearchProvider provider;
  late MockSupabaseService mockSupabase;

  const userId = '00000000-0000-0000-0000-000000000002';
  const researcherId = '00000000-0000-0000-0000-000000000001';

  setUp(() {
    mockSupabase = MockSupabaseService();
    provider = ResearchProvider(supabaseService: mockSupabase);
  });

  group('initial state', () {
    test('has empty lists and no error', () {
      expect(provider.researchUser, isNull);
      expect(provider.codes, isEmpty);
      expect(provider.unlockedFlows, isEmpty);
      expect(provider.surveyResponses, isEmpty);
      expect(provider.testResults, isEmpty);
      expect(provider.isLoading, false);
      expect(provider.error, isNull);
    });
  });

  group('redeemCode', () {
    test('valid code returns unlocked flow name', () async {
      when(mockSupabase.redeemResearchCode('VOCAB-A-001', userId))
          .thenAnswer((_) async => {
                'id': 'code-1',
                'code': 'VOCAB-A-001',
                'target_role': 'group_a_participant',
                'unlocks': 'vocabulary_test_a',
                'created_by': researcherId,
              });

      final result = await provider.redeemCode(userId, 'VOCAB-A-001');

      expect(result, 'vocabulary_test_a');
      expect(provider.unlockedFlows, contains('vocabulary_test_a'));
      expect(provider.isLoading, false);
      expect(provider.error, isNull);
    });

    test('invalid code sets error and returns null', () async {
      when(mockSupabase.redeemResearchCode('BAD-CODE', userId))
          .thenThrow(const AppException('Code not found'));

      final result = await provider.redeemCode(userId, 'BAD-CODE');

      expect(result, isNull);
      expect(provider.error, 'Code not found');
      expect(provider.isLoading, false);
    });

    test('already used code sets error', () async {
      when(mockSupabase.redeemResearchCode('USED-CODE', userId))
          .thenThrow(const AppException('Code already used'));

      final result = await provider.redeemCode(userId, 'USED-CODE');

      expect(result, isNull);
      expect(provider.error, 'Code already used');
    });
  });

  group('generateCode', () {
    test('success creates code and adds to list', () async {
      when(mockSupabase.insertResearchCode(any)).thenAnswer((_) async => {
            'id': 'new-code-id',
            'code': 'GEN12345',
            'target_role': 'group_a_participant',
            'unlocks': 'experience_survey_short_term',
            'created_by': researcherId,
            'used_by': null,
            'used_at': null,
            'created_at': DateTime.now().toIso8601String(),
          });

      final result = await provider.generateCode(
        researcherId,
        'group_a_participant',
        'experience_survey_short_term',
      );

      expect(result, isNotNull);
      expect(result!.unlocks, 'experience_survey_short_term');
      expect(provider.codes.length, 1);
      expect(provider.error, isNull);
    });

    test('failure sets error and returns null', () async {
      when(mockSupabase.insertResearchCode(any))
          .thenThrow(const AppException('Permission denied'));

      final result = await provider.generateCode(
        'non-researcher',
        'group_a_participant',
        'vocabulary_test_a',
      );

      expect(result, isNull);
      expect(provider.error, 'Permission denied');
    });
  });

  group('submitSurvey', () {
    test('proficiency screener inserts to correct table', () async {
      when(mockSupabase.insertSurveyResponse(
              'research_proficiency_screener', any))
          .thenAnswer((_) async {});

      await provider.submitSurvey(
        userId,
        'proficiency_screener',
        null,
        {'item_1': 3, 'item_2': 4, 'item_3': 2, 'item_4': 5, 'item_5': 3, 'item_6': 4},
      );

      expect(provider.error, isNull);
      expect(provider.isLoading, false);
      verify(mockSupabase.insertSurveyResponse(
              'research_proficiency_screener', any))
          .called(1);
    });

    test('experience survey includes time_point', () async {
      when(mockSupabase.insertSurveyResponse(
              'research_experience_survey', any))
          .thenAnswer((_) async {});

      await provider.submitSurvey(
        userId,
        'experience_survey',
        'short_term',
        {
          'enjoyment_1': 4, 'enjoyment_2': 3, 'enjoyment_3': 5,
          'enjoyment_4': 4, 'enjoyment_5': 3,
          'engagement_1': 4, 'engagement_2': 3, 'engagement_3': 5,
          'engagement_4': 4, 'engagement_5': 3,
          'motivation_1': 4, 'motivation_2': 3, 'motivation_3': 5,
          'motivation_4': 4, 'motivation_5': 3,
        },
      );

      expect(provider.error, isNull);
      final captured = verify(mockSupabase.insertSurveyResponse(
              'research_experience_survey', captureAny))
          .captured
          .single as Map<String, dynamic>;
      expect(captured['time_point'], 'short_term');
    });

    test('SUS survey computes sus_score correctly', () async {
      when(mockSupabase.insertSurveyResponse('research_sus', any))
          .thenAnswer((_) async {});

      // Standard SUS: all items = 3
      // Odd items (1,3,5,7,9) sum = 15; Even items (2,4,6,8,10) sum = 15
      // Score = ((15 - 5) + (25 - 15)) * 2.5 = (10 + 10) * 2.5 = 50.0
      final responses = <String, int>{
        'item_1': 3, 'item_2': 3, 'item_3': 3, 'item_4': 3, 'item_5': 3,
        'item_6': 3, 'item_7': 3, 'item_8': 3, 'item_9': 3, 'item_10': 3,
      };

      await provider.submitSurvey(userId, 'sus', null, responses);

      expect(provider.error, isNull);
      final captured = verify(
              mockSupabase.insertSurveyResponse('research_sus', captureAny))
          .captured
          .single as Map<String, dynamic>;
      expect(captured['sus_score'], 50.0);
    });

    test('SUS perfect score computes correctly', () async {
      when(mockSupabase.insertSurveyResponse('research_sus', any))
          .thenAnswer((_) async {});

      // Best case: odd items=5, even items=1
      // Odd sum = 25; Even sum = 5
      // Score = ((25 - 5) + (25 - 5)) * 2.5 = (20 + 20) * 2.5 = 100.0
      final responses = <String, int>{
        'item_1': 5, 'item_2': 1, 'item_3': 5, 'item_4': 1, 'item_5': 5,
        'item_6': 1, 'item_7': 5, 'item_8': 1, 'item_9': 5, 'item_10': 1,
      };

      await provider.submitSurvey(userId, 'sus', null, responses);

      final captured = verify(
              mockSupabase.insertSurveyResponse('research_sus', captureAny))
          .captured
          .single as Map<String, dynamic>;
      expect(captured['sus_score'], 100.0);
    });

    test('failure sets error', () async {
      when(mockSupabase.insertSurveyResponse(any, any))
          .thenThrow(const AppException('Duplicate entry'));

      await provider.submitSurvey(userId, 'language_interest', null, {
        'item_1': 4, 'item_2': 3, 'item_3': 5, 'item_4': 4, 'item_5': 3,
      });

      expect(provider.error, 'Duplicate entry');
    });
  });

  group('submitVocabularyTest', () {
    test('success inserts test result', () async {
      when(mockSupabase.insertVocabularyTest(any))
          .thenAnswer((_) async {});

      await provider.submitVocabularyTest(
        userId,
        'A',
        25,
        {'q1': 'B', 'q2': 'C'},
      );

      expect(provider.error, isNull);
      expect(provider.isLoading, false);
      verify(mockSupabase.insertVocabularyTest(any)).called(1);
    });

    test('failure sets error', () async {
      when(mockSupabase.insertVocabularyTest(any))
          .thenThrow(const AppException('Insert failed'));

      await provider.submitVocabularyTest(userId, 'A', 20, {});

      expect(provider.error, 'Insert failed');
    });
  });

  group('fetchAllResearchData', () {
    test('success populates research users, codes, and test results', () async {
      when(mockSupabase.fetchAllResearchData()).thenAnswer((_) async => {
            'research_users': [
              {
                'id': 'ru-1',
                'user_id': userId,
                'role': 'group_a_participant',
                'target_language': 'japanese',
                'created_at': '2026-01-01T00:00:00.000Z',
              }
            ],
            'vocabulary_test': [
              {
                'id': 'vt-1',
                'user_id': userId,
                'test_set': 'A',
                'score': 28,
                'answers': {'q1': 'A'},
                'submitted_at': '2026-01-01T00:00:00.000Z',
              }
            ],
          });
      when(mockSupabase.fetchResearchCodes()).thenAnswer((_) async => [
            {
              'id': 'rc-1',
              'code': 'TEST-001',
              'target_role': 'group_a_participant',
              'unlocks': 'vocabulary_test_a',
              'created_by': researcherId,
              'used_by': null,
              'used_at': null,
              'created_at': '2026-01-01T00:00:00.000Z',
            }
          ]);

      await provider.fetchAllResearchData();

      expect(provider.researchUsers.length, 1);
      expect(provider.codes.length, 1);
      expect(provider.testResults.length, 1);
      expect(provider.isLoading, false);
      expect(provider.error, isNull);
    });

    test('failure sets error', () async {
      when(mockSupabase.fetchAllResearchData())
          .thenThrow(const AppException('Permission denied'));

      await provider.fetchAllResearchData();

      expect(provider.error, 'Permission denied');
    });
  });

  group('addResearchUser', () {
    test('success calls insertResearchUser', () async {
      when(mockSupabase.insertResearchUser(any)).thenAnswer((_) async {});

      await provider.addResearchUser(
        userId,
        'group_a_participant',
        'japanese',
      );

      expect(provider.error, isNull);
      verify(mockSupabase.insertResearchUser(any)).called(1);
    });

    test('failure sets error', () async {
      when(mockSupabase.insertResearchUser(any))
          .thenThrow(const AppException('Already exists'));

      await provider.addResearchUser(userId, 'group_a_participant', 'japanese');

      expect(provider.error, 'Already exists');
    });
  });
}
