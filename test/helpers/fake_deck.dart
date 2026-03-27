import 'package:boo_mondai/models/models.dart';
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: test/helpers/fake_deck.dart
// PURPOSE: Provides fake Deck instances and lists for unit and widget tests
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Deck fakeDeck({String? id, bool? isPremade}) => Deck(
      id: id ?? '00000000-0000-0000-0000-000000000010',
      creatorId: '00000000-0000-0000-0000-000000000002',
      title: 'Test Deck',
      description: 'A test deck',
      targetLanguage: 'japanese',
      isPremade: isPremade ?? false,
      isPublic: true,
      cardCount: 3,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    );

List<Deck> fakeDeckList({int count = 3}) => List.generate(
      count,
      (i) => fakeDeck(id: '00000000-0000-0000-0000-00000000001$i'),
    );
