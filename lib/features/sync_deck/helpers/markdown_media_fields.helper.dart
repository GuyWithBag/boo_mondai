import 'package:boo_mondai/lib.barrel.dart'
    show
        CardTemplate,
        FillInTheBlanksTemplate,
        FlashcardTemplate,
        IdentificationTemplate,
        MatchingTypeTemplate,
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
      FillInTheBlanksTemplate() => [
        MarkdownMediaField(
          name: 'prompt-text',
          getValue: (template) =>
              (template as FillInTheBlanksTemplate).promptText,
          setValue: (template, value) =>
              (template as FillInTheBlanksTemplate).copyWith(promptText: value),
        ),
      ],
      // ToDo:
      // MatchingTypeTemplate(:final values) => [
      //   for (var index = 0; index < values.length; index++) ...[
      //     MarkdownMediaField(
      //       name: 'pair-${values[index].text}-term',
      //       getValue: (template) =>
      //           (template as MatchingTypeTemplate).values[index].text,
      //       setValue: (template, value) {
      //         final matchMadness = template as MatchingTypeTemplate;
      //         final updatedPairs = matchMadness.values.toList();
      //         updatedPairs[index] = updatedPairs[index].copyWith(text: value);
      //         return matchMadness.copyWith(values: updatedPairs);
      //       },
      //     ),
      //     MarkdownMediaField(
      //       name: 'pair-${values[index].id}-match',
      //       getValue: (template) =>
      //           (template as MatchingTypeTemplate).values[index].match,
      //       setValue: (template, value) {
      //         final matchMadness = template as MatchingTypeTemplate;
      //         final updatedPairs = matchMadness.values.toList();
      //         updatedPairs[index] = updatedPairs[index].copyWith(match: value);
      //         return matchMadness.copyWith(values: updatedPairs);
      //       },
      //     ),
      //   ],
      // ],
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
