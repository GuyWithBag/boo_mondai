import 'package:boo_mondai/lib.barrel.dart'
    show
        CardTemplate,
        FillInTheBlanksTemplate,
        FlashcardTemplate,
        IdentificationTemplate,
        MatchMadnessTemplate,
        MultipleChoiceTemplate,
        WordScrambleTemplate,
        MarkdownMediaField;

abstract final class MarkdownMediaFieldsHelper {
  static List<MarkdownMediaField> markdownFields(CardTemplate template) {
    return switch (template) {
      FlashcardTemplate() => const [
        MarkdownMediaField(
          name: 'front-text',
          getValue: _getFlashcardFrontText,
          setValue: _setFlashcardFrontText,
        ),
        MarkdownMediaField(
          name: 'back-text',
          getValue: _getFlashcardBackText,
          setValue: _setFlashcardBackText,
        ),
      ],
      IdentificationTemplate() => const [
        MarkdownMediaField(
          name: 'prompt-text',
          getValue: _getIdentificationPromptText,
          setValue: _setIdentificationPromptText,
        ),
      ],
      MultipleChoiceTemplate(:final options) => [
        const MarkdownMediaField(
          name: 'question-prompt',
          getValue: _getMultipleChoiceQuestionPrompt,
          setValue: _setMultipleChoiceQuestionPrompt,
        ),
        for (var index = 0; index < options.length; index++)
          MarkdownMediaField(
            name: 'option-${options[index].id}',
            getValue: (template) =>
                (template as MultipleChoiceTemplate).options[index].optionText,
            setValue: (template, value) {
              final multipleChoice = template as MultipleChoiceTemplate;
              final updatedOptions = multipleChoice.options.toList();
              updatedOptions[index] = updatedOptions[index].copyWith(
                optionText: value,
              );
              return multipleChoice.copyWith(options: updatedOptions);
            },
          ),
      ],
      WordScrambleTemplate() => const [
        MarkdownMediaField(
          name: 'sentence-to-scramble',
          getValue: _getWordScrambleSentenceToScramble,
          setValue: _setWordScrambleSentenceToScramble,
        ),
      ],
      FillInTheBlanksTemplate(:final segments) => [
        for (var index = 0; index < segments.length; index++)
          MarkdownMediaField(
            name: 'segment-${segments[index].id}',
            getValue: (template) =>
                (template as FillInTheBlanksTemplate).segments[index].fullText,
            setValue: (template, value) {
              final fillInTheBlanks = template as FillInTheBlanksTemplate;
              final updatedSegments = fillInTheBlanks.segments.toList();
              updatedSegments[index] = updatedSegments[index].copyWith(
                fullText: value,
              );
              return fillInTheBlanks.copyWith(segments: updatedSegments);
            },
          ),
      ],
      MatchMadnessTemplate(:final pairs) => [
        for (var index = 0; index < pairs.length; index++) ...[
          MarkdownMediaField(
            name: 'pair-${pairs[index].id}-term',
            getValue: (template) =>
                (template as MatchMadnessTemplate).pairs[index].term,
            setValue: (template, value) {
              final matchMadness = template as MatchMadnessTemplate;
              final updatedPairs = matchMadness.pairs.toList();
              updatedPairs[index] = updatedPairs[index].copyWith(term: value);
              return matchMadness.copyWith(pairs: updatedPairs);
            },
          ),
          MarkdownMediaField(
            name: 'pair-${pairs[index].id}-match',
            getValue: (template) =>
                (template as MatchMadnessTemplate).pairs[index].match,
            setValue: (template, value) {
              final matchMadness = template as MatchMadnessTemplate;
              final updatedPairs = matchMadness.pairs.toList();
              updatedPairs[index] = updatedPairs[index].copyWith(match: value);
              return matchMadness.copyWith(pairs: updatedPairs);
            },
          ),
        ],
      ],
      _ => const [],
    };
  }

  static String _getFlashcardFrontText(CardTemplate template) =>
      (template as FlashcardTemplate).frontText;
  static CardTemplate _setFlashcardFrontText(
    CardTemplate template,
    String value,
  ) => (template as FlashcardTemplate).copyWith(frontText: value);
  static String _getFlashcardBackText(CardTemplate template) =>
      (template as FlashcardTemplate).backText;
  static CardTemplate _setFlashcardBackText(
    CardTemplate template,
    String value,
  ) => (template as FlashcardTemplate).copyWith(backText: value);

  static String _getIdentificationPromptText(CardTemplate template) =>
      (template as IdentificationTemplate).promptText;
  static CardTemplate _setIdentificationPromptText(
    CardTemplate template,
    String value,
  ) => (template as IdentificationTemplate).copyWith(promptText: value);

  static String _getMultipleChoiceQuestionPrompt(CardTemplate template) =>
      (template as MultipleChoiceTemplate).questionPrompt;
  static CardTemplate _setMultipleChoiceQuestionPrompt(
    CardTemplate template,
    String value,
  ) => (template as MultipleChoiceTemplate).copyWith(questionPrompt: value);

  static String _getWordScrambleSentenceToScramble(CardTemplate template) =>
      (template as WordScrambleTemplate).sentenceToScramble;
  static CardTemplate _setWordScrambleSentenceToScramble(
    CardTemplate template,
    String value,
  ) => (template as WordScrambleTemplate).copyWith(sentenceToScramble: value);
}
