// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: test/providers/streak_provider_test.dart
// PURPOSE: Unit tests for StreakProvider — fetch, record activity, streak logic
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../helpers/mock_supabase_service.mocks.dart';
import '../helpers/mock_hive_service.mocks.dart';
import 'package:boo_mondai/models/models.dart';
import 'package:boo_mondai/providers/providers.dart';
import 'package:boo_mondai/services/services.dart';

void main() {
  late StreakProvider provider;
  late MockSupabaseService mockSupabase;
  late MockHiveService mockHive;

  const userId = '00000000-0000-0000-0000-000000000002';

  setUp(() {
    mockSupabase = MockSupabaseService();
    mockHive = MockHiveService();
    provider = StreakProvider(
      supabaseService: mockSupabase,
      hiveService: mockHive,
    );
  });

  group('initial state', () {
    test('has no streak and no error', () {
      expect(provider.streak, isNull);
      expect(provider.currentStreak, 0);
      expect(provider.longestStreak, 0);
      expect(provider.isLoading, false);
      expect(provider.error, isNull);
    });
  });

  group('fetchStreak', () {
    test('loads from Hive first then syncs from Supabase', () async {
      final hiveStreak = Streak(
        id: 'streak-1',
        userId: userId,
        currentStreak: 3,
        longestStreak: 10,
        lastActivityDate: DateTime(2026, 3, 25),
      );
      final supabaseData = {
        'id': 'streak-1',
        'user_id': userId,
        'current_streak': 5,
        'longest_streak': 12,
        'last_activity_date': '2026-03-25',
      };

      when(mockHive.getStreak(userId)).thenReturn(hiveStreak);
      when(mockSupabase.fetchStreak(userId))
          .thenAnswer((_) async => supabaseData);
      when(mockHive.saveStreak(any)).thenAnswer((_) async {});

      await provider.fetchStreak(userId);

      // Should end up with Supabase version
      expect(provider.currentStreak, 5);
      expect(provider.longestStreak, 12);
      expect(provider.isLoading, false);
      verify(mockHive.saveStreak(any)).called(1);
    });

    test('failure sets error but keeps Hive data', () async {
      final hiveStreak = Streak(
        id: 'streak-1',
        userId: userId,
        currentStreak: 3,
        longestStreak: 10,
      );

      when(mockHive.getStreak(userId)).thenReturn(hiveStreak);
      when(mockSupabase.fetchStreak(userId))
          .thenThrow(const AppException('Network error'));

      await provider.fetchStreak(userId);

      expect(provider.error, 'Network error');
      expect(provider.currentStreak, 3); // Hive data preserved
    });
  });

  group('recordActivity', () {
    test('same day is a no-op (no change)', () async {
      final today = DateTime.now();
      final todayDate = DateTime(today.year, today.month, today.day);

      final existingStreak = Streak(
        id: 'streak-1',
        userId: userId,
        currentStreak: 5,
        longestStreak: 10,
        lastActivityDate: todayDate,
      );

      // Set provider's internal streak via fetchStreak
      when(mockHive.getStreak(userId)).thenReturn(existingStreak);
      when(mockSupabase.fetchStreak(userId)).thenAnswer((_) async => null);
      await provider.fetchStreak(userId);

      await provider.recordActivity(userId);

      // No change — should not save
      expect(provider.currentStreak, 5);
      verifyNever(mockHive.saveStreak(any));
    });

    test('consecutive day increments streak', () async {
      final today = DateTime.now();
      final todayDate = DateTime(today.year, today.month, today.day);
      final yesterday = todayDate.subtract(const Duration(days: 1));

      final existingStreak = Streak(
        id: 'streak-1',
        userId: userId,
        currentStreak: 5,
        longestStreak: 10,
        lastActivityDate: yesterday,
      );

      when(mockHive.getStreak(userId)).thenReturn(existingStreak);
      when(mockSupabase.fetchStreak(userId)).thenAnswer((_) async => null);
      await provider.fetchStreak(userId);

      when(mockHive.saveStreak(any)).thenAnswer((_) async {});
      when(mockSupabase.upsertStreak(any)).thenAnswer((_) async {});

      await provider.recordActivity(userId);

      expect(provider.currentStreak, 6);
      verify(mockHive.saveStreak(any)).called(1);
    });

    test('gap in days resets streak to 1', () async {
      final today = DateTime.now();
      final todayDate = DateTime(today.year, today.month, today.day);
      final twoDaysAgo = todayDate.subtract(const Duration(days: 2));

      final existingStreak = Streak(
        id: 'streak-1',
        userId: userId,
        currentStreak: 5,
        longestStreak: 10,
        lastActivityDate: twoDaysAgo,
      );

      when(mockHive.getStreak(userId)).thenReturn(existingStreak);
      when(mockSupabase.fetchStreak(userId)).thenAnswer((_) async => null);
      await provider.fetchStreak(userId);

      when(mockHive.saveStreak(any)).thenAnswer((_) async {});
      when(mockSupabase.upsertStreak(any)).thenAnswer((_) async {});

      await provider.recordActivity(userId);

      expect(provider.currentStreak, 1);
      // longestStreak should remain unchanged (10 > 1)
      expect(provider.longestStreak, 10);
    });

    test('longestStreak updates when exceeded', () async {
      final today = DateTime.now();
      final todayDate = DateTime(today.year, today.month, today.day);
      final yesterday = todayDate.subtract(const Duration(days: 1));

      final existingStreak = Streak(
        id: 'streak-1',
        userId: userId,
        currentStreak: 10,
        longestStreak: 10,
        lastActivityDate: yesterday,
      );

      when(mockHive.getStreak(userId)).thenReturn(existingStreak);
      when(mockSupabase.fetchStreak(userId)).thenAnswer((_) async => null);
      await provider.fetchStreak(userId);

      when(mockHive.saveStreak(any)).thenAnswer((_) async {});
      when(mockSupabase.upsertStreak(any)).thenAnswer((_) async {});

      await provider.recordActivity(userId);

      expect(provider.currentStreak, 11);
      expect(provider.longestStreak, 11);
    });

    test('creates new streak when none exists', () async {
      when(mockHive.getStreak(userId)).thenReturn(null);
      when(mockSupabase.fetchStreak(userId)).thenAnswer((_) async => null);
      await provider.fetchStreak(userId);
      expect(provider.streak, isNull);

      when(mockHive.saveStreak(any)).thenAnswer((_) async {});
      when(mockSupabase.upsertStreak(any)).thenAnswer((_) async {});

      await provider.recordActivity(userId);

      expect(provider.currentStreak, 1);
      expect(provider.longestStreak, 1);
    });

    test('Supabase sync failure sets error but local save succeeds', () async {
      when(mockHive.getStreak(userId)).thenReturn(null);
      when(mockSupabase.fetchStreak(userId)).thenAnswer((_) async => null);
      await provider.fetchStreak(userId);

      when(mockHive.saveStreak(any)).thenAnswer((_) async {});
      when(mockSupabase.upsertStreak(any))
          .thenThrow(const AppException('Offline'));

      await provider.recordActivity(userId);

      expect(provider.currentStreak, 1);
      expect(provider.error, 'Offline');
    });
  });
}
