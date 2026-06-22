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
        CardMediaAttachment,
        CardMediaKind,
        CardTemplate,
        CardTemplateTag,
        CardType,
        Deck,
        DeckListing,
        DeckTag,
        DownloadCheckpoint,
        DownloadCheckpointStatus,
        DrillAnswer,
        DrillSession,
        FillInTheBlankSegment,
        FillInTheBlanksTemplate,
        FlashcardTemplate,
        FsrsCard,
        FsrsReviewLog,
        IdentificationTemplate,
        ImportExportBackup,
        MatchMadnessPair,
        MatchMadnessTemplate,
        MultipleChoiceOption,
        MultipleChoiceTemplate,
        Profile,
        QuestionType,
        ReviewSession,
        Streak,
        StudyCard,
        StudyRating,
        Tag,
        UserSettings,
        UserStudyCardTag,
        VisibilityState,
        WordScrambleTemplate;
import 'package:fsrs/fsrs.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@GenerateAdapters([
  AdapterSpec<Profile>(),
  AdapterSpec<CachedProfile>(),
  AdapterSpec<Deck>(),
  AdapterSpec<CardMediaAttachment>(),
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
  AdapterSpec<CardMediaKind>(),
  AdapterSpec<QuestionType>(),
  AdapterSpec<User>(),
  AdapterSpec<VisibilityState>(),
  AdapterSpec<Tag>(),
  AdapterSpec<DeckListing>(),
  AdapterSpec<DeckTag>(),
  AdapterSpec<CardTemplateTag>(),
  AdapterSpec<UserStudyCardTag>(),
  AdapterSpec<ImportExportBackup>(),
  AdapterSpec<UserSettings>(),
  AdapterSpec<DownloadCheckpoint>(),
  AdapterSpec<DownloadCheckpointStatus>(),
])
// ignore: unused_element
part 'adapters.g.dart';
