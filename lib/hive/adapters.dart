// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/hive/adapters.dart
// PURPOSE: Hive CE adapter registration using @GenerateAdapters
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

library;

import 'package:boo_mondai/models/models.barrel.dart';
import 'package:fsrs/fsrs.dart';
import 'package:hive_ce/hive_ce.dart';

@GenerateAdapters([
  AdapterSpec<UserProfile>(),
  AdapterSpec<CachedProfile>(),
  AdapterSpec<Deck>(),
  AdapterSpec<DeckCard>(),
  AdapterSpec<Note>(),
  AdapterSpec<MultipleChoiceOption>(),
  AdapterSpec<FillInTheBlankSegment>(),
  AdapterSpec<MatchMadnessPair>(),
  // AdapterSpec<QuizSession>(),
  // AdapterSpec<QuizAnswer>(),
  // AdapterSpec<Card>(),
  AdapterSpec<Card>(),
  // AdapterSpec<ReviewLog>(),
  AdapterSpec<ReviewLog>(),
  AdapterSpec<Streak>(),
  AdapterSpec<CardType>(),
  AdapterSpec<QuestionType>(),
])
// ignore: unused_element
part 'adapters.g.dart';
