// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: test/helpers/fake_deck_card.dart
// PURPOSE: Provides fake DeckCard instances and lists for unit and widget tests
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/models/models.dart';

/// Creates a [DeckCard] with a single [Note] for use in tests.
/// [question] maps to Note.frontText; [answer] maps to Note.backText.
DeckCard fakeDeckCard({
  String? id,
  String? question,
  String? answer,
}) {
  final cardId = id ?? '00000000-0000-0000-0000-000000000020';
  return DeckCard(
    id: cardId,
    deckId: '00000000-0000-0000-0000-000000000010',
    cardType: CardType.normal,
    questionType: QuestionType.readAndSelect,
    sortOrder: 0,
    createdAt: DateTime(2026, 1, 1),
    notes: [
      Note(
        id: '${cardId}_note',
        cardId: cardId,
        frontText: question ?? '犬',
        backText: answer ?? 'dog, いぬ, inu',
        isReverse: false,
        createdAt: DateTime(2026, 1, 1),
      ),
    ],
  );
}

List<DeckCard> fakeDeckCardList({int count = 3}) => List.generate(
      count,
      (i) => fakeDeckCard(id: '00000000-0000-0000-0000-00000000002$i'),
    );
