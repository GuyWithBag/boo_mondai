import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/services/services.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ViewDecksService', () {
    test('filters decks by fuzzy text and tag', () {
      final grammarTag = _tag(id: 'tag-grammar', name: 'Grammar');
      final vocabTag = _tag(id: 'tag-vocab', name: 'Vocabulary');
      final grammarDeck = _deck(
        id: 'grammar',
        title: 'N5 Grammar Basics',
        tags: [grammarTag],
      );
      final vocabDeck = _deck(
        id: 'vocab',
        title: 'N5 Vocabulary',
        tags: [vocabTag],
      );

      final results = ViewDecksService.filterDecks(
        decks: [vocabDeck, grammarDeck],
        query: 'gramer',
        tagId: grammarTag.id,
      );

      expect(results, [grammarDeck]);
    });

    test('sorts decks by updatedAt newest first', () {
      final older = _deck(id: 'older', title: 'A', updatedAt: DateTime(2024));
      final newer = _deck(id: 'newer', title: 'B', updatedAt: DateTime(2025));

      final results = ViewDecksService.sortDecks([older, newer]);

      expect(results, [newer, older]);
    });

    test('deduplicates available tags alphabetically', () {
      final grammarTag = _tag(id: 'tag-grammar', name: 'Grammar');
      final vocabTag = _tag(id: 'tag-vocab', name: 'Vocabulary');

      final results = ViewDecksService.availableTags([
        _deck(id: 'deck-1', title: 'Deck 1', tags: [vocabTag, grammarTag]),
        _deck(id: 'deck-2', title: 'Deck 2', tags: [grammarTag]),
      ]);

      expect(results, [grammarTag, vocabTag]);
    });

    test('supports oldest sorting when requested', () {
      final older = _deck(id: 'older', title: 'A', updatedAt: DateTime(2024));
      final newer = _deck(id: 'newer', title: 'B', updatedAt: DateTime(2025));

      final results = ViewDecksService.filterDecks(
        decks: [newer, older],
        sortDirection: BrowseSortDirection.ascending,
      );

      expect(results, [older, newer]);
    });

    test('parses fuzzy query with inline tag and sort filters', () {
      final grammarTag = _tag(id: 'tag-grammar', name: 'Japanese Grammar');
      final vocabTag = _tag(id: 'tag-vocab', name: 'Vocabulary');
      final older = _deck(
        id: 'older',
        title: 'N5 Grammar',
        updatedAt: DateTime(2024),
        tags: [grammarTag],
      );
      final newer = _deck(
        id: 'newer',
        title: 'Advanced Grammar',
        updatedAt: DateTime(2025),
        tags: [grammarTag],
      );
      final vocab = _deck(
        id: 'vocab',
        title: 'N5 Words',
        updatedAt: DateTime(2026),
        tags: [vocabTag],
      );

      final results = ViewDecksService.filterDecksFromText(
        decks: [vocab, newer, older],
        input: 'gramer tag:"Japanese Grammar" sort:oldest',
      );

      expect(results, [older, newer]);
    });

    test('parses hash tags and explicit field/order filters', () {
      final grammarTag = _tag(id: 'tag-grammar', name: 'Grammar');
      final aDeck = _deck(id: 'a', title: 'A Grammar', tags: [grammarTag]);
      final bDeck = _deck(id: 'b', title: 'B Grammar', tags: [grammarTag]);

      final results = ViewDecksService.filterDecksFromText(
        decks: [aDeck, bDeck],
        input: '#Grammar field:title order:desc',
      );

      expect(results, [bDeck, aDeck]);
    });
  });
}

Tag _tag({required String id, required String name}) {
  return Tag(id: id, name: name, createdAt: DateTime(2024));
}

Deck _deck({
  required String id,
  required String title,
  DateTime? updatedAt,
  List<Tag> tags = const [],
}) {
  return Deck(
    id: id,
    userId: 'user-1',
    title: title,
    visibilityState: VisibilityState.public,
    isPublished: true,
    cardCount: 0,
    createdAt: DateTime(2024),
    updatedAt: updatedAt ?? DateTime(2024),
    tags: tags,
  );
}
