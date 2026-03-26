// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/main.dart
// PURPOSE: Entry point — Hive init, Supabase init, provider registration, runApp
// PROVIDERS: all
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:boo_mondai/app.dart';
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
import 'package:boo_mondai/services/notification_service.dart';
import 'package:boo_mondai/services/supabase_service.dart';
import 'package:boo_mondai/shared/env.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── Hive ────────────────────────────────────────────
  await Hive.initFlutter();
  final hiveService = HiveService();
  await hiveService.init();

  // ── Supabase ────────────────────────────────────────
  await Supabase.initialize(
    url: Env.supabaseUrl,
    anonKey: Env.supabaseAnonKey,
  );
  final supabaseService = SupabaseService();

  // ── Other services ──────────────────────────────────
  final fsrsService = FsrsService();
  final notificationService = NotificationService();
  await notificationService.init();

  // ── Restore session ─────────────────────────────────
  final authProvider = AuthProvider(
    supabaseService: supabaseService,
    hiveService: hiveService,
  );
  await authProvider.restoreSession();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider(
          create: (_) => DeckProvider(
            supabaseService: supabaseService,
            hiveService: hiveService,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => CardProvider(
            supabaseService: supabaseService,
            hiveService: hiveService,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => QuizProvider(
            supabaseService: supabaseService,
            hiveService: hiveService,
            fsrsService: fsrsService,
            queueController: QuizQueueController(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => FsrsProvider(
            fsrsService: fsrsService,
            hiveService: hiveService,
            supabaseService: supabaseService,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => LeaderboardProvider(
            supabaseService: supabaseService,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => StreakProvider(
            supabaseService: supabaseService,
            hiveService: hiveService,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ResearchProvider(
            supabaseService: supabaseService,
          ),
        ),
      ],
      child: const BooMondaiApp(),
    ),
  );
}
