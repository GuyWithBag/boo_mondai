// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/survey/survey_questions.dart
// PURPOSE: Builds survey question lists and titles by survey type
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
import 'package:boo_mondai/widgets/widgets.barrel.dart';

List<SurveyQuestion> buildSurveyQuestions(String surveyType) {
  switch (surveyType) {
    case 'proficiency_screener':
      return const [
        SurveyQuestion(
          'item_1',
          'I can recognize basic vocabulary in my target language (e.g. greetings, numbers)',
        ),
        SurveyQuestion(
          'item_2',
          'I can read simple sentences in my target language',
        ),
        SurveyQuestion(
          'item_3',
          'I can understand basic written instructions in my target language',
        ),
        SurveyQuestion(
          'item_4',
          'I have formally studied this language before (class, course, or program)',
        ),
        SurveyQuestion(
          'item_5',
          'I interact with this language regularly (media, work, travel, or cultural exposure)',
        ),
        SurveyQuestion(
          'item_6',
          'I have used a language learning app before (e.g. Duolingo, Anki, Memrise)',
        ),
      ];
    case 'language_interest':
      return const [
        SurveyQuestion(
          'item_1',
          'I am genuinely interested in learning my target language',
        ),
        SurveyQuestion(
          'item_2',
          'I am motivated to improve my proficiency in this language',
        ),
        SurveyQuestion(
          'item_3',
          'Learning this language is important to my personal or professional goals',
        ),
        SurveyQuestion(
          'item_4',
          'I enjoy consuming content in this language (music, film, books, etc.)',
        ),
        SurveyQuestion(
          'item_5',
          'I plan to continue studying this language after this study',
        ),
      ];
    case 'experience_survey':
      return const [
        // Enjoyment
        SurveyQuestion('enjoyment_1', 'I feel genuinely having fun'),
        SurveyQuestion('enjoyment_2', 'I feel happy when using the platform'),
        SurveyQuestion(
          'enjoyment_3',
          'I feel that it is great for killing time productively',
        ),
        SurveyQuestion('enjoyment_4', 'I feel exhausted when using it'),
        SurveyQuestion('enjoyment_5', 'I feel miserable when using it'),
        // Engagement
        SurveyQuestion(
          'engagement_1',
          'I wanted to explore all the options because it was very challenging',
        ),
        SurveyQuestion('engagement_2', 'I felt that time passed quickly'),
        SurveyQuestion('engagement_3', 'I wanted to complete the session'),
        SurveyQuestion('engagement_4', 'I did not care how the session ended'),
        SurveyQuestion('engagement_5', 'I felt bored during the session'),
        // Motivation
        SurveyQuestion(
          'motivation_1',
          'It was important to me to do well at this task',
        ),
        SurveyQuestion(
          'motivation_2',
          'I would describe this activity as very interesting',
        ),
        SurveyQuestion('motivation_3', 'I tried very hard on this activity'),
        SurveyQuestion(
          'motivation_4',
          'I did not try very hard to do well at this activity',
        ),
        SurveyQuestion('motivation_5', 'I did not put much energy into this'),
      ];
    case 'preview_usefulness':
      return const [
        SurveyQuestion(
          'item_1',
          'Previewing the vocabulary before the quiz helped me feel prepared',
        ),
        SurveyQuestion(
          'item_2',
          'The preview feature reduced my anxiety during the quiz',
        ),
        SurveyQuestion(
          'item_3',
          'I would choose to use the preview feature again in future sessions',
        ),
        SurveyQuestion(
          'item_4',
          'The preview made it easier to recall vocabulary during the quiz',
        ),
        SurveyQuestion(
          'item_5',
          'I would recommend the preview feature to other learners',
        ),
      ];
    case 'fsrs_usefulness':
      return const [
        SurveyQuestion(
          'item_1',
          'The review reminders helped me remember vocabulary better',
        ),
        SurveyQuestion(
          'item_2',
          'The Again/Hard/Good/Easy rating system felt accurate to my recall',
        ),
        SurveyQuestion(
          'item_3',
          'I felt the review sessions were worth my time',
        ),
        SurveyQuestion(
          'item_4',
          'The spaced review sessions helped me retain vocabulary longer',
        ),
        SurveyQuestion(
          'item_5',
          'I would continue using the FSRS review deck after this study',
        ),
      ];
    case 'ugc_perception':
      return const [
        SurveyQuestion(
          'item_1',
          'I would find it useful to create my own quiz decks for vocabulary I want to learn',
        ),
        SurveyQuestion(
          'item_2',
          'Creating my own flashcard content would help me understand the material better',
        ),
        SurveyQuestion(
          'item_3',
          'I would use a feature that allows me to build my own study decks',
        ),
        SurveyQuestion(
          'item_4',
          'I would find it helpful to access quiz decks created by other learners',
        ),
        SurveyQuestion(
          'item_5',
          'Using community-made decks would save me time in preparing study materials',
        ),
        SurveyQuestion(
          'item_6',
          'A platform where I can create and use other learners\' content would be more motivating than studying alone',
        ),
      ];
    case 'sus':
      return const [
        SurveyQuestion(
          'item_1',
          'I think that I would like to use this system frequently',
        ),
        SurveyQuestion('item_2', 'I found the system unnecessarily complex'),
        SurveyQuestion('item_3', 'I thought the system was easy to use'),
        SurveyQuestion(
          'item_4',
          'I think that I would need the support of a technical person to be able to use this system',
        ),
        SurveyQuestion(
          'item_5',
          'I found the various functions in this system were well integrated',
        ),
        SurveyQuestion(
          'item_6',
          'I thought there was too much inconsistency in this system',
        ),
        SurveyQuestion(
          'item_7',
          'I would imagine that most people would learn to use this system very quickly',
        ),
        SurveyQuestion('item_8', 'I found the system very cumbersome to use'),
        SurveyQuestion('item_9', 'I felt very confident using the system'),
        SurveyQuestion(
          'item_10',
          'I needed to learn a lot of things before I could get going with this system',
        ),
      ];
    default:
      return const [];
  }
}

String surveyTitle(String surveyType) {
  switch (surveyType) {
    case 'proficiency_screener':
      return 'Proficiency Screener';
    case 'language_interest':
      return 'Language Interest';
    case 'experience_survey':
      return 'Experience Survey';
    case 'preview_usefulness':
      return 'Preview Usefulness';
    case 'fsrs_usefulness':
      return 'FSRS Usefulness';
    case 'ugc_perception':
      return 'User-Generated Content';
    case 'sus':
      return 'System Usability Scale';
    default:
      return 'Survey';
  }
}
