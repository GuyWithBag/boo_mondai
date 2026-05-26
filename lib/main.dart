// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/main.dart
// PURPOSE: Entry point — Hive init, Supabase init, provider registration, runApp
// PROVIDERS: all
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:developer' as developer;

import 'package:app_links/app_links.dart';
import 'package:barrel_annotation/barrel_annotation.dart';
import 'package:boo_mondai/core/hive/hive_registrar.g.dart' show HiveRegistrar;
import 'package:boo_mondai/env.dart' show Env;
import 'package:boo_mondai/lib.barrel.dart'
    show
        RemoteDB,
        LocalDB,
        Services,
        NotificationService,
        AuthController,
        DrillSessionController,
        ViewReviewsController,
        ReviewSessionController,
        ViewDecksLocalController,
        ViewDecksOnlineController,
        ViewLeaderboardController,
        StreakController,
        ResearchController,
        UserSettingsService,
        BooMondaiApp;
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@BarrelConfig(
  exclude: [
    'lib/core/hive/hive.barrel.dart',
    'lib/**/**/*.mapper.dart',
    'lib/**/*.mapper.dart',
    'lib/*.mapper.dart',
  ],
)
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── Hive ────────────────────────────────────────────
  await Hive.initFlutter('boo_mondai');
  Hive.registerAdapters();

  // ── Supabase ────────────────────────────────────────
  await Supabase.initialize(url: Env.supabaseUrl, anonKey: Env.supabaseAnonKey);
  await RemoteDB.init();
  await LocalDB.init();
  Services.init();

  // ── Other services ──────────────────────────────────
  final notificationService = NotificationService();
  await notificationService.init();

  // ── Restore session ─────────────────────────────────
  final authController = AuthController();
  await authController.restoreSession();
  final initialUserSettings =
      await UserSettingsService.getOrCreateForCurrentProfile();

  // This is what catches the link on Linux when the OS tries
  // to open the app via the .desktop file
  final appLinks = AppLinks();
  appLinks.uriLinkStream.listen((uri) {
    developer.log('Received deep link: $uri');
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authController),
        ChangeNotifierProvider(create: (_) => DrillSessionController()),
        ChangeNotifierProvider(create: (_) => ViewReviewsController()),
        ChangeNotifierProvider(create: (_) => ReviewSessionController()),
        ChangeNotifierProvider(create: (_) => ViewDecksLocalController()),
        ChangeNotifierProvider(create: (_) => ViewDecksOnlineController()),
        ChangeNotifierProvider(create: (_) => ViewLeaderboardController()),
        ChangeNotifierProvider(create: (_) => StreakController()),
        ChangeNotifierProvider(create: (_) => ResearchController()),
      ],
      child: BooMondaiApp(
        authController: authController,
        initialUserSettings: initialUserSettings,
      ),
    ),
  );
}
