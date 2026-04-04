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
  AdapterSpec<MultipleChoiceOption>(),
  AdapterSpec<FillInTheBlanksTemplate>(),
  AdapterSpec<MultipleChoiceTemplate>(),
  AdapterSpec<FlashcardTemplate>(),
  AdapterSpec<MatchMadnessTemplate>(),
  AdapterSpec<IdentificationTemplate>(),
  AdapterSpec<ReviewCard>(),
  AdapterSpec<FillInTheBlankSegment>(),
  AdapterSpec<MatchMadnessPair>(),
  AdapterSpec<UserDeckProgress>(),
  AdapterSpec<QuizSession>(),
  AdapterSpec<QuizAnswer>(),
  AdapterSpec<QuizAnswerType>(),
  AdapterSpec<Card>(),
  AdapterSpec<FsrsCard>(),
  AdapterSpec<ReviewLog>(),
  AdapterSpec<FsrsReviewLog>(),
  AdapterSpec<State>(),
  AdapterSpec<Streak>(),
  AdapterSpec<Rating>(),
  AdapterSpec<CardType>(),
  AdapterSpec<QuestionType>(),
])
// ignore: unused_element
part 'adapters.g.dart';
