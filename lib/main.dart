// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/main.dart
// PURPOSE: Entry point — Hive init, Supabase init, provider registration, runApp
// PROVIDERS: all
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:barrel_annotation/barrel_annotation.dart';
import 'package:boo_mondai/hive/hive_registrar.g.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:boo_mondai/app.dart';
import 'package:boo_mondai/controllers/controllers.barrel.dart';
import 'package:boo_mondai/providers/providers.barrel.dart';
import 'package:boo_mondai/services/services.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';

import 'repositories/repositories.barrel.dart';

@BarrelConfig(
  exclude: ['lib/hive/hive.barrel.dart', 'lib/models/*.mapper.dart'],
)
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── Hive ────────────────────────────────────────────
  await Hive.initFlutter('boo_mondai');
  Hive.registerAdapters();
  // final hiveService = HiveService();
  // await hiveService.init();

  // ── Supabase ────────────────────────────────────────
  await Supabase.initialize(url: Env.supabaseUrl, anonKey: Env.supabaseAnonKey);
  await Repositories.init();
  Services.init();

  // ── Other services ──────────────────────────────────
  final notificationService = NotificationService();
  await notificationService.init();

  // ── Restore session ─────────────────────────────────
  final authProvider = AuthProvider();
  // await authProvider.restoreSession();
  authProvider.mockSignIn();

  runApp(
    MultiProvider(
      providers: [
        // Provider<HiveService>.value(value: hiveService),
        // Provider<SupabaseService>.value(value: supabaseService),
        ChangeNotifierProvider.value(value: authProvider),
        // ChangeNotifierProvider(
        //   create: (_) => DeckProvider(
        //     supabaseService: supabaseService,
        //     hiveService: hiveService,
        //   ),
        // ),
        // ChangeNotifierProvider(
        //   create: (_) => CardProvider(
        //     supabaseService: supabaseService,
        //     hiveService: hiveService,
        //   ),
        // ),
        // ChangeNotifierProvider(
        //   create: (_) => ViewDeckController(hiveService: hiveService),
        // ),
        ChangeNotifierProvider(create: (_) => QuizSessionPageController()),
        ChangeNotifierProvider(create: (_) => ReviewDashboardController()),
        ChangeNotifierProvider(create: (_) => MyDecksPageController()),
        // ChangeNotifierProvider(
        //   create: (_) => FsrsProvider(
        //     fsrsService: fsrsService,
        //     // hiveService: hiveService,
        //     supabaseService: supabaseService,
        //   ),
        // ),
        ChangeNotifierProvider(create: (_) => LeaderboardProvider()),
        // ChangeNotifierProvider(
        //   create: (_) => StreakProvider(
        //     supabaseService: supabaseService,
        //     // hiveService: hiveService,
        //   ),
        // ),
        // ChangeNotifierProvider(
        //   create: (_) => ResearchProvider(supabaseService: supabaseService),
        // ),
      ],
      child: const BooMondaiApp(),
    ),
  );
}
