library;

import 'dart:typed_data';

// Danger: None of this generating adapters work unless you import the file directly.
//Importing from lib will cause the generator to get confused and will not generate the proper files.
import 'package:boo_mondai/core/helpers/casing.type.dart';
import 'package:boo_mondai/core/models/vector2.hive.dart';
import 'package:boo_mondai/features/cached_media/cached_media.dart';
import 'package:boo_mondai/features/cards/models/card.template.dto.dart';
import 'package:boo_mondai/features/cards/models/card.type.dto.dart';
import 'package:boo_mondai/features/cards/models/fill_in_the_blank.answer_key.dto.dart';
import 'package:boo_mondai/features/cards/models/fill_in_the_blanks.template.dto.dart';
import 'package:boo_mondai/features/cards/models/flashcard.template.dto.dart';
import 'package:boo_mondai/features/cards/models/identification.answer_key.dto.dart';
import 'package:boo_mondai/features/cards/models/identification.template.dto.dart';
import 'package:boo_mondai/features/cards/models/matching_type.value.dto.dart';
import 'package:boo_mondai/features/cards/models/matching_type.template.dto.dart';
import 'package:boo_mondai/features/cards/models/multiple_choice.option.dto.dart';
import 'package:boo_mondai/features/cards/models/multiple_choice.template.dto.dart';
import 'package:boo_mondai/features/cards/models/word_scramble.template.dart';
import 'package:boo_mondai/features/content/models/content.dto.dart';
import 'package:boo_mondai/features/content/models/content.type.dart';
import 'package:boo_mondai/features/deck_listings/models/deck_listing.dto.dart';
import 'package:boo_mondai/features/decks/models/deck.dto.dart';
import 'package:boo_mondai/features/decks/models/visibility_state.dto.dart';
import 'package:boo_mondai/features/fsrs/models/fsrs_card.dto.dart';
import 'package:boo_mondai/features/fsrs/models/fsrs_review_log.dto.dart';
import 'package:boo_mondai/features/notifications/models/notification.intent.dart';
import 'package:boo_mondai/features/notifications/models/notification.intent.type.dart';
import 'package:boo_mondai/features/profile/models/profile.dto.dart';
import 'package:boo_mondai/features/profile/models/profile.role.dto.dart';
import 'package:boo_mondai/features/progress_checkpoints/models/progress_checkpoint.dto.dart';
import 'package:boo_mondai/features/review.study_session/models/review_session.dto.dart';
// import 'package:boo_mondai/features/settings/models/setting.dart';
import 'package:boo_mondai/features/settings/models/user_settings.dart';
import 'package:boo_mondai/features/streak/streak.dto.dart';
import 'package:boo_mondai/features/study_cards/study_card.dto.dart';
import 'package:boo_mondai/features/study_session/models/study_session.answer.dart';
import 'package:boo_mondai/features/study_session/models/study_session.completed_results.dart';
import 'package:boo_mondai/features/study_session/models/study_session.snapshot.dart';
import 'package:boo_mondai/features/study_session/session_mode.dart';
import 'package:boo_mondai/features/study_session/session_steps/card.session_step.dart';
import 'package:boo_mondai/features/study_session/session_steps/message.session_step.dart';
import 'package:boo_mondai/features/study_session/session_steps/session_step.dto.dart';
import 'package:boo_mondai/features/surveys/models/survey_response.dto.dart';
import 'package:boo_mondai/features/sync/models/sync_client.dart';
import 'package:boo_mondai/features/sync_deletion/models/sync_deletion.dto.dart';
import 'package:boo_mondai/features/tags/models/card_template_tag.dto.dart';
import 'package:boo_mondai/features/tags/models/deck_tag.dto.dart';
import 'package:boo_mondai/features/tags/models/tag.dto.dart';
import 'package:boo_mondai/features/tags/models/user_study_card_tag.dto.dart';
import 'package:boo_mondai/ui/edit_deck/models/question_type.dart';
import 'package:boo_mondai/ui/study_session.card_stage/models/study_rating.dto.dart';
import 'package:fsrs/fsrs.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@GenerateAdapters([
  AdapterSpec<Profile>(),
  AdapterSpec<ProfileRole>(),
  AdapterSpec<Deck>(),

  AdapterSpec<FillInTheBlanksTemplate>(),
  AdapterSpec<MultipleChoiceTemplate>(),
  AdapterSpec<FlashcardTemplate>(),
  AdapterSpec<MatchingTypeTemplate>(),
  AdapterSpec<IdentificationTemplate>(),
  AdapterSpec<WordScrambleTemplate>(),

  AdapterSpec<IdentificationAnswerKey>(),
  AdapterSpec<MultipleChoiceOption>(),
  AdapterSpec<FillInTheBlankAnswerKey>(),
  AdapterSpec<MatchingTypeValue>(),

  AdapterSpec<StudyCard>(),
  AdapterSpec<StudyRating>(),
  AdapterSpec<Card>(),

  AdapterSpec<FsrsCard>(),

  AdapterSpec<ReviewLog>(),
  AdapterSpec<ReviewSession>(),
  AdapterSpec<StudySessionCardStep>(),
  AdapterSpec<StudySessionMessageStep>(),
  AdapterSpec<StudySessionAnswer>(),
  AdapterSpec<StudySessionSnapshot>(),
  AdapterSpec<StudySessionCompletedResults>(),
  AdapterSpec<SessionMode>(),

  AdapterSpec<FsrsReviewLog>(),
  AdapterSpec<State>(),
  AdapterSpec<Streak>(),
  AdapterSpec<Rating>(),
  AdapterSpec<CardTemplateDirection>(),
  AdapterSpec<CasingType>(),
  AdapterSpec<CardTemplateType>(),
  AdapterSpec<User>(),
  AdapterSpec<VisibilityState>(),
  AdapterSpec<Tag>(),
  AdapterSpec<DeckListing>(),
  AdapterSpec<DeckTag>(),
  AdapterSpec<CardTemplateTag>(),
  AdapterSpec<UserStudyCardTag>(),

  // AdapterSpec<Setting>(),
  AdapterSpec<UserSettings>(),
  AdapterSpec<ProgressCheckpoint>(),
  AdapterSpec<ProgressCheckpointType>(),
  AdapterSpec<ProgressCheckpointStatus>(),

  AdapterSpec<SyncDeletion>(),
  AdapterSpec<SyncClient>(),

  AdapterSpec<CachedMedia>(),
  AdapterSpec<Content>(),
  AdapterSpec<ContentType>(),
  AdapterSpec<SurveyResponse>(),
  AdapterSpec<NotificationIntent>(),
  AdapterSpec<NotificationIntentType>(),

  AdapterSpec<Vector2Hive>(),
])
part 'adapters.g.dart';
