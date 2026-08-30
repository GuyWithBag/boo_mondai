import 'package:boo_mondai/lib.barrel.dart'
    show
        CardType,
        EditDeckQuestionTypeHelper,
        MatchPairData,
        MatchPairHelper,
        MultipleChoiceOption,
        MultipleChoiceOptionHelper,
        QuestionType,
        StringHelper;
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MultipleChoiceOptionHelper', () {
    test('selectCorrectAt marks only the selected option correct', () {
      final options = [
        const MultipleChoiceOption(
          id: 'option-a',
          templateId: 'template-1',
          optionText: 'A',
          isCorrect: true,
          displayOrder: 0,
        ),
        const MultipleChoiceOption(
          id: 'option-b',
          templateId: 'template-1',
          optionText: 'B',
          isCorrect: false,
          displayOrder: 1,
        ),
        const MultipleChoiceOption(
          id: 'option-c',
          templateId: 'template-1',
          optionText: 'C',
          isCorrect: false,
          displayOrder: 2,
        ),
      ];

      final updated = MultipleChoiceOptionHelper.selectCorrectAt(options, 2);

      expect(updated.map((option) => option.isCorrect), [false, false, true]);
      expect(updated.map((option) => option.optionText), ['A', 'B', 'C']);
      expect(updated.map((option) => option.id), [
        'option-a',
        'option-b',
        'option-c',
      ]);
    });

    test('updateTextAt preserves correctness', () {
      final options = [
        const MultipleChoiceOption(
          id: 'option-a',
          templateId: 'template-1',
          optionText: 'A',
          isCorrect: true,
          displayOrder: 0,
        ),
      ];

      final updated = MultipleChoiceOptionHelper.updateTextAt(
        options,
        0,
        'Answer',
      );

      expect(updated.single.optionText, 'Answer');
      expect(updated.single.isCorrect, isTrue);
      expect(updated.single.id, 'option-a');
    });
  });

  group('MatchPairHelper', () {
    test('updates term and match independently', () {
      final pairs = [const MatchPairData(term: 'one', match: 'ichi')];

      final withTerm = MatchPairHelper.updateTermAt(pairs, 0, 'two');
      final withMatch = MatchPairHelper.updateMatchAt(withTerm, 0, 'ni');

      expect(withMatch.single.term, 'two');
      expect(withMatch.single.match, 'ni');
    });
  });

  group('EditDeckQuestionTypeHelper', () {
    test('resets card type for non-flashcard formats', () {
      expect(
        EditDeckQuestionTypeHelper.cardTypeForQuestionType(
          QuestionType.multipleChoice,
          CardType.both,
        ),
        CardType.normal,
      );
    });

    test('preserves card type for flashcards', () {
      expect(
        EditDeckQuestionTypeHelper.cardTypeForQuestionType(
          QuestionType.flashcard,
          CardType.both,
        ),
        CardType.both,
      );
    });
  });

  group('TextHelper', () {
    test('splits comma separated text', () {
      expect(StringHelper.toTrimmedCommaSeparatedValues('one, two, ,three'), [
        'one',
        'two',
        'three',
      ]);
    });
  });
}
