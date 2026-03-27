// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/hive/adapters.dart
// PURPOSE: Hive CE adapter registration using @GenerateAdapters
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

library;

import 'package:hive_ce/hive_ce.dart';
import 'package:boo_mondai/models/user_profile.dart';
import 'package:boo_mondai/models/deck.dart';
import 'package:boo_mondai/models/deck_card.dart';
import 'package:boo_mondai/models/card_type.dart';
import 'package:boo_mondai/models/question_type.dart';
import 'package:boo_mondai/models/note.dart';
import 'package:boo_mondai/models/multiple_choice_option.dart';
import 'package:boo_mondai/models/fill_in_the_blank_segment.dart';
import 'package:boo_mondai/models/match_madness_pair.dart';
import 'package:boo_mondai/models/fsrs_card_state.dart';
import 'package:boo_mondai/models/review_log_entry.dart';
import 'package:boo_mondai/models/streak.dart';

@GenerateAdapters([
  AdapterSpec<UserProfile>(),
  AdapterSpec<Deck>(),
  AdapterSpec<DeckCard>(),
  AdapterSpec<FsrsCardState>(),
  AdapterSpec<ReviewLogEntry>(),
  AdapterSpec<Streak>(),
])
// ignore: unused_element

part 'adapters.g.dart';
