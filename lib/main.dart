import 'dart:developer' as developer;
import 'package:app_links/app_links.dart';
import 'package:barrel_annotation/barrel_annotation.dart';
import 'package:boo_mondai/core/hive/hive_registrar.g.dart' show HiveRegistrar;
import 'package:boo_mondai/env.dart' show Env;
import 'package:boo_mondai/features/ui_sounds/ui_sounds.barrel.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        RemoteDB,
        LocalDB,
        Services,
        AuthController,
        ChangeTrackerController,
        ChangeTrackerService,
        ViewDecksLocalController,
        ViewDeckListingsController,
        StreakController,
        SettingsStore,
        NotificationsController,
        SyncController,
        SyncDeckService,
        ChangeTrackerRouteArgs,
        BooMondaiApp;
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:provider/provider.dart';
import 'package:signals/signals_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@BarrelConfig(
  exclude: [
    'lib/core/hive/hive.barrel.dart',
    'lib/core/helpers/image_file_provider_io.dart',
    'lib/core/helpers/image_file_provider_stub.dart',
    'lib/**/**/*.mapper.dart',
    'lib/**/*.mapper.dart',
    'lib/*.mapper.dart',
  ],
)
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await UiSoundsService.init();

  // ── Hive ────────────────────────────────────────────
  await Hive.initFlutter('boo_mondai');
  Hive.registerAdapters();
  // ── Supabase ────────────────────────────────────────
  await Supabase.initialize(
    url: Env.supabaseUrl,
    publishableKey: Env.supabaseAnonKey,
  );
  await RemoteDB.init();
  await LocalDB.init();
  Services.init();
  // ── Settings (must come before notifications) ───────
  final settingsStore = SettingsStore.instance;
  await settingsStore.init();

  await NotificationsController.instance.init();
  // ── Restore session ─────────────────────────────────
  final authController = AuthController();
  // ── App-level sync ──────────────────────────────────
  final viewDecksLocalController = ViewDecksLocalController();
  final syncChangeTrackerController = ChangeTrackerController(
    service: ChangeTrackerService(inboundLabel: 'pull', outboundLabel: 'push'),
    pageArgs: signal(const ChangeTrackerRouteArgs.missing(entryId: '')),
  );
  final syncController = SyncController(
    title: 'Sync decks',
    profileId: () => LocalDB.currentProfile.getOrCreate().id,
    getTables: SyncDeckService.getTables,
    onSynced: viewDecksLocalController.load,
  );
  // ── Deep links ──────────────────────────────────────
  final appLinks = AppLinks();
  appLinks.uriLinkStream.listen((uri) {
    developer.log('Received deep link: $uri');
  });
  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: authController),
        Provider.value(value: syncChangeTrackerController),
        Provider.value(value: syncController),
        Provider.value(value: viewDecksLocalController),
        Provider(create: (_) => ViewDeckListingsController()),
        ChangeNotifierProvider(create: (_) => StreakController()),
      ],
      child: BooMondaiApp(authController: authController),
    ),
  );
  WidgetsBinding.instance.addPostFrameCallback((_) {
    authController.startRemoteSessionRestoreListener();
  });
}
