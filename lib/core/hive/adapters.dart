// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/hive/adapters.dart
// PURPOSE: Hive CE adapter registration using @GenerateAdapters
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

library;

import 'package:boo_mondai/lib.barrel.dart'
    show
        CachedProfile,
        Profile,
        Deck,
        MultipleChoiceOption,
        FillInTheBlanksTemplate,
        MultipleChoiceTemplate,
        FlashcardTemplate,
        MatchMadnessTemplate,
        IdentificationTemplate,
        StudyCard,
        FillInTheBlankSegment,
        WordScrambleTemplate,
        MatchMadnessPair,
        DrillSession,
        DrillAnswer,
        StudyRating,
        FsrsCard,
        ReviewSession,
        FsrsReviewLog,
        Streak,
        CardType,
        QuestionType,
        VisibilityState,
        Tag,
        DeckListing,
        DeckTag,
        CardTemplateTag,
        CardTemplate,
        UserStudyCardTag;
import 'package:fsrs/fsrs.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@GenerateAdapters([
  AdapterSpec<Profile>(),
  AdapterSpec<CachedProfile>(),
  AdapterSpec<Deck>(),
  AdapterSpec<MultipleChoiceOption>(),
  AdapterSpec<FillInTheBlanksTemplate>(),
  AdapterSpec<MultipleChoiceTemplate>(),
  AdapterSpec<FlashcardTemplate>(),
  AdapterSpec<MatchMadnessTemplate>(),
  AdapterSpec<IdentificationTemplate>(),
  AdapterSpec<StudyCard>(),
  AdapterSpec<FillInTheBlankSegment>(),
  AdapterSpec<WordScrambleTemplate>(),
  AdapterSpec<MatchMadnessPair>(),
  AdapterSpec<DrillSession>(),
  AdapterSpec<DrillAnswer>(),
  AdapterSpec<StudyRating>(),
  AdapterSpec<Card>(),
  AdapterSpec<FsrsCard>(),
  AdapterSpec<ReviewLog>(),
  AdapterSpec<ReviewSession>(),
  AdapterSpec<FsrsReviewLog>(),
  AdapterSpec<State>(),
  AdapterSpec<Streak>(),
  AdapterSpec<Rating>(),
  AdapterSpec<CardType>(),
  AdapterSpec<QuestionType>(),
  AdapterSpec<User>(),
  AdapterSpec<VisibilityState>(),
  AdapterSpec<Tag>(),
  AdapterSpec<DeckListing>(),
  AdapterSpec<DeckTag>(),
  AdapterSpec<CardTemplateTag>(),
  AdapterSpec<UserStudyCardTag>(),
])
// ignore: unused_element
part 'adapters.g.dart';
