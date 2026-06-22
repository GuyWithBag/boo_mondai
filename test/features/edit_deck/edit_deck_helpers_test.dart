import 'package:boo_mondai/lib.barrel.dart'
    show
        CardType,
        EditDeckQuestionTypeHelper,
        MatchPairData,
        MatchPairHelper,
        MultipleChoiceOptionData,
        MultipleChoiceOptionHelper,
        QuestionType,
        TextHelper;
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MultipleChoiceOptionHelper', () {
    test('selectCorrectAt marks only the selected option correct', () {
      final options = [
        const MultipleChoiceOptionData(text: 'A', isCorrect: true),
        const MultipleChoiceOptionData(text: 'B', isCorrect: false),
        const MultipleChoiceOptionData(text: 'C', isCorrect: false),
      ];

      final updated = MultipleChoiceOptionHelper.selectCorrectAt(options, 2);

      expect(updated.map((option) => option.isCorrect), [false, false, true]);
      expect(updated.map((option) => option.text), ['A', 'B', 'C']);
    });

    test('updateTextAt preserves correctness', () {
      final options = [
        const MultipleChoiceOptionData(text: 'A', isCorrect: true),
      ];

      final updated = MultipleChoiceOptionHelper.updateTextAt(
        options,
        0,
        'Answer',
      );

      expect(updated.single.text, 'Answer');
      expect(updated.single.isCorrect, isTrue);
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
      expect(TextHelper.getTrimmedCommaSeparatedValues('one, two, ,three'), [
        'one',
        'two',
        'three',
      ]);
    });
  });
}
