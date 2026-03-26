// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/adapters.dart
// PURPOSE: Hive CE adapter registration using @GenerateAdapters
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
// NOTE: Our HiveService uses Box<Map> with manual JSON serialization
// (toJson/fromJson) rather than typed Hive adapters. This avoids
// adapter version conflicts and keeps Hive as a simple key-value
// cache layer.
//
// If you ever need typed boxes in the future, uncomment the
// @GenerateAdapters annotation below and run:
//   dart run build_runner build --delete-conflicting-outputs
//
// For now, this file exists as a placeholder per the project spec.

// import 'package:hive_ce/hive_ce.dart';
// import 'package:boo_mondai/models/user_profile.dart';
// import 'package:boo_mondai/models/deck.dart';
// import 'package:boo_mondai/models/deck_card.dart';
// import 'package:boo_mondai/models/fsrs_card_state.dart';
// import 'package:boo_mondai/models/review_log_entry.dart';
// import 'package:boo_mondai/models/streak.dart';
//
// @GenerateAdapters([
//   AdapterSpec<UserProfile>(),
//   AdapterSpec<Deck>(),
//   AdapterSpec<DeckCard>(),
//   AdapterSpec<FsrsCardState>(),
//   AdapterSpec<ReviewLogEntry>(),
//   AdapterSpec<Streak>(),
// ])
// ignore: unused_element
// library;
//
// part 'adapters.g.dart';
