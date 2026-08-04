import 'package:boo_mondai/lib.barrel.dart'
    show
        Survey,
        SurveyChoiceOption,
        SurveyContentBlock,
        SurveyDefinition,
        SurveyLikertInputBlock,
        SurveyMultipleChoiceInputBlock,
        SurveyPage,
        SurveyStatus,
        SurveyTextInputBlock;

abstract final class FirstDrillSurvey {
  static const String id = 'first-drill-survey-v1';
  static const String introPageId = 'first-drill-survey-v1-intro';
  static const String questionsPageId = 'first-drill-survey-v1-questions';
  static const String contentBlockId = 'first-drill-survey-v1-content';
  static const String ratingBlockId = 'first-drill-survey-v1-rating';
  static const String feelingBlockId = 'first-drill-survey-v1-feeling';
  static const String noteBlockId = 'first-drill-survey-v1-note';

  static SurveyDefinition build({required String profileId}) {
    final now = DateTime.now();

    return SurveyDefinition(
      survey: Survey(
        id: id,
        profileId: profileId,
        title: 'First drill feedback',
        description: 'A short feedback survey after the first drill.',
        status: SurveyStatus.published,
        createdAt: now,
        updatedAt: now,
      ),
      pages: const [
        SurveyPage(id: introPageId, surveyId: id, position: 0),
        SurveyPage(id: questionsPageId, surveyId: id, position: 1),
      ],
      blocks: const [
        SurveyContentBlock(
          id: contentBlockId,
          surveyId: id,
          pageId: introPageId,
          position: 0,
          markdown:
              'Thanks for finishing your first drill. This quick check helps tune the early study experience.',
        ),
        SurveyLikertInputBlock(
          id: ratingBlockId,
          surveyId: id,
          pageId: questionsPageId,
          position: 0,
          key: 'first_drill_rating',
          prompt: 'How useful did that drill feel?',
          minValue: 1,
          maxValue: 5,
          minLabel: 'Not useful',
          maxLabel: 'Very useful',
        ),
        SurveyMultipleChoiceInputBlock(
          id: feelingBlockId,
          surveyId: id,
          pageId: questionsPageId,
          position: 1,
          key: 'first_drill_feeling',
          prompt: 'What best describes the drill?',
          maxAnswers: 2,
          options: [
            SurveyChoiceOption(
              id: 'first-drill-survey-v1-feeling-clear',
              blockId: feelingBlockId,
              position: 0,
              value: 'clear',
              label: 'Clear',
            ),
            SurveyChoiceOption(
              id: 'first-drill-survey-v1-feeling-too_easy',
              blockId: feelingBlockId,
              position: 1,
              value: 'too_easy',
              label: 'Too easy',
            ),
            SurveyChoiceOption(
              id: 'first-drill-survey-v1-feeling-too_hard',
              blockId: feelingBlockId,
              position: 2,
              value: 'too_hard',
              label: 'Too hard',
            ),
          ],
        ),
        SurveyTextInputBlock(
          id: noteBlockId,
          surveyId: id,
          pageId: questionsPageId,
          position: 2,
          key: 'first_drill_note',
          prompt: 'Anything confusing?',
          isRequired: false,
          isLongText: true,
          placeholder: 'Optional',
        ),
      ],
    );
  }
}
