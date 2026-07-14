// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/hive/adapters.dart
// PURPOSE: Hive CE adapter registration using @GenerateAdapters
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// ignore_for_file: non_type_as_type_argument

library;

import 'package:boo_mondai/lib.barrel.dart'
    show
        CachedProfile,
        CardTemplate,
        CardTemplateTag,
        CardType,
        Deck,
        DeckListing,
        DeckTag,
        DrillAnswer,
        DrillSession,
        FillInTheBlankSegment,
        FillInTheBlanksTemplate,
        FlashcardTemplate,
        FsrsCard,
        FsrsReviewLog,
        IdentificationTemplate,
        ImportExportBackup,
        StoredMedia,
        SyncDeletion,
        MatchMadnessPair,
        MatchMadnessTemplate,
        MultipleChoiceOption,
        MultipleChoiceTemplate,
        ProgressCheckpoint,
        ProgressCheckpointStatus,
        ProgressCheckpointType,
        Profile,
        QuestionType,
        ReviewSession,
        SessionFlowSnapshot,
        PendingStepSubmission,
        SessionStep,
        CardSessionStep,
        MessageSessionStep,
        SummarySessionStep,
        StudySessionStepRecord,
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
  AdapterSpec<SessionFlowSnapshot>(),
  AdapterSpec<PendingStepSubmission>(),
  AdapterSpec<CardSessionStep>(),
  AdapterSpec<MessageSessionStep>(),
  AdapterSpec<SummarySessionStep>(),
  AdapterSpec<StudySessionStepRecord>(),
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
  AdapterSpec<ImportExportBackup>(),
  AdapterSpec<UserSettings>(),
  AdapterSpec<ProgressCheckpoint>(),
  AdapterSpec<ProgressCheckpointType>(),
  AdapterSpec<ProgressCheckpointStatus>(),
  AdapterSpec<StoredMedia>(),
  AdapterSpec<SyncDeletion>(),
])
// ignore: unused_element
part 'adapters.g.dart';
