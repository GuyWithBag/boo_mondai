import 'package:boo_mondai/lib.barrel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DeckMapNormalizer', () {
    test('flattens canonical template field names', () {
      const service = DecksImporterService();
      final maps = service.textToMaps('''
{
  "type": "Deck",
  "title": "All 6",
  "templates": [
    {
      "type": "matching_type",
      "values": [
        {
          "text": "bonjour",
          "matchPosition": {"x": 0.0, "y": 0.0},
          "position": {"x": 1.0, "y": 1.0}
        }
      ]
    },
    {
      "type": "flashcard",
      "frontText": "bonjour ![Person](/attachments/person.webp)",
      "backText": "hello",
      "direction": "normal"
    },
    {
      "type": "word_scramble",
      "sentenceToScramble": "Je parle francais"
    },
    {
      "type": "identification",
      "promptText": "Translate: hello",
      "answers": [
        {
          "value": "bonjour",
          "casingType": "any"
        }
      ]
    },
    {
      "type": "fill_in_the_blanks",
      "promptText": "Je parle francais.",
      "answerKeys": [
        {
          "value": "francais",
          "casingType": "any",
          "order": 0
        }
      ]
    },
    {
      "type": "multiple_choice",
      "questionPrompt": "Which word means hello?",
      "options": [
        {
          "optionText": "bonjour",
          "isCorrect": true
        }
      ]
    }
  ]
}
''');
      final result = DeckMapNormalizer.flattenDeckMap(maps.single);
      final templates = service.templatesFromResult(result);

      expect(result.decks, hasLength(1));
      expect(templates, hasLength(6));
      expect(
        templates.whereType<MatchingTypeTemplate>().single.values,
        hasLength(1),
      );
      expect(
        templates.whereType<FlashcardTemplate>().single.frontText,
        contains('/attachments/person.webp'),
      );
      expect(
        templates.whereType<WordScrambleTemplate>().single.sentenceToScramble,
        'Je parle francais',
      );
      expect(
        templates
            .whereType<IdentificationTemplate>()
            .single
            .answers
            .single
            .value,
        'bonjour',
      );
      expect(
        templates
            .whereType<FillInTheBlanksTemplate>()
            .single
            .answerKeys
            .single
            .value,
        'francais',
      );
      expect(
        templates
            .whereType<MultipleChoiceTemplate>()
            .single
            .options
            .single
            .optionText,
        'bonjour',
      );
    });
  });
}
