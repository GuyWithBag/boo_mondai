// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: test/helpers/fake_deck_card.dart
// PURPOSE: Provides fake DeckCard instances and lists for unit and widget tests
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/models/deck_card.dart';

DeckCard fakeDeckCard({String? id, String? question, String? answer}) =>
    DeckCard(
      id: id ?? '00000000-0000-0000-0000-000000000020',
      deckId: '00000000-0000-0000-0000-000000000010',
      question: question ?? '犬',
      answer: answer ?? 'dog, いぬ, inu',
      questionImageUrl: null,
      answerImageUrl: null,
      sortOrder: 0,
      createdAt: DateTime(2026, 1, 1),
    );

List<DeckCard> fakeDeckCardList({int count = 3}) => List.generate(
      count,
      (i) => fakeDeckCard(id: '00000000-0000-0000-0000-00000000002$i'),
    );
