// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: test/helpers/pump_app.dart
// PURPOSE: Wraps a widget with all providers, MaterialApp.router, and go_router for widget tests
// PROVIDERS: AuthProvider, DeckProvider, CardProvider, QuizProvider, FsrsProvider, LeaderboardProvider, StreakProvider, ResearchProvider
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/controllers/quiz_queue_controller.dart';
import 'package:boo_mondai/providers/auth_provider.dart';
import 'package:boo_mondai/providers/card_provider.dart';
import 'package:boo_mondai/providers/deck_provider.dart';
import 'package:boo_mondai/providers/fsrs_provider.dart';
import 'package:boo_mondai/providers/leaderboard_provider.dart';
import 'package:boo_mondai/providers/quiz_provider.dart';
import 'package:boo_mondai/providers/research_provider.dart';
import 'package:boo_mondai/providers/streak_provider.dart';
import 'package:boo_mondai/services/fsrs_service.dart';
import 'package:boo_mondai/services/hive_service.dart';
import 'package:boo_mondai/services/supabase_service.dart';

/// Pumps a widget wrapped with all providers, a [MaterialApp.router], and a
/// simple [GoRouter] that renders [child] at the root route.
///
/// Pass mock services to override the defaults. If not provided, real
/// instances are created (callers should always supply mocks in practice).
///
/// Use [initialRoute] to set the starting location for the router.
extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget child, {
    SupabaseService? supabaseService,
    HiveService? hiveService,
    FsrsService? fsrsService,
    AuthProvider? authProvider,
    DeckProvider? deckProvider,
    CardProvider? cardProvider,
    QuizProvider? quizProvider,
    FsrsProvider? fsrsProvider,
    LeaderboardProvider? leaderboardProvider,
    StreakProvider? streakProvider,
    ResearchProvider? researchProvider,
    GoRouter? router,
    String initialRoute = '/',
  }) async {
    final supa = supabaseService ?? SupabaseService();
    final hive = hiveService ?? HiveService();
    final fsrs = fsrsService ?? FsrsService();

    final auth = authProvider ??
        AuthProvider(supabaseService: supa, hiveService: hive);
    final deck = deckProvider ??
        DeckProvider(supabaseService: supa, hiveService: hive);
    final card = cardProvider ??
        CardProvider(supabaseService: supa, hiveService: hive);
    final quiz = quizProvider ??
        QuizProvider(
          supabaseService: supa,
          hiveService: hive,
          fsrsService: fsrs,
          queueController: QuizQueueController(),
        );
    final fsrsProv = fsrsProvider ??
        FsrsProvider(
          fsrsService: fsrs,
          hiveService: hive,
          supabaseService: supa,
        );
    final leaderboard = leaderboardProvider ??
        LeaderboardProvider(supabaseService: supa);
    final streak = streakProvider ??
        StreakProvider(supabaseService: supa, hiveService: hive);
    final research = researchProvider ??
        ResearchProvider(supabaseService: supa);

    final testRouter = router ??
        GoRouter(
          initialLocation: initialRoute,
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => child,
            ),
          ],
        );

    await pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>.value(value: auth),
          ChangeNotifierProvider<DeckProvider>.value(value: deck),
          ChangeNotifierProvider<CardProvider>.value(value: card),
          ChangeNotifierProvider<QuizProvider>.value(value: quiz),
          ChangeNotifierProvider<FsrsProvider>.value(value: fsrsProv),
          ChangeNotifierProvider<LeaderboardProvider>.value(value: leaderboard),
          ChangeNotifierProvider<StreakProvider>.value(value: streak),
          ChangeNotifierProvider<ResearchProvider>.value(value: research),
        ],
        child: MaterialApp.router(
          routerConfig: testRouter,
        ),
      ),
    );
  }
}
