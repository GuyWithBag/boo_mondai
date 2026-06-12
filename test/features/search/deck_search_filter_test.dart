import 'package:boo_mondai/lib.barrel.dart'
    show
        CardTemplateSearchFilter,
        CardTemplateSearchSortField,
        DeckListingSearchFilter,
        DeckListingSearchSortField,
        DeckSearchFilter,
        DeckSearchSortField,
        SearchSortDirection,
        StudyCardSearchFilter;
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DeckSearchFilter.parse', () {
    test('parses deck search query syntax', () {
      final filter = DeckSearchFilter.parse(
        'kanji #jlpt tag:"core vocab,verbs" tag_id:abc sort:az fuzzy:110',
      );

      expect(filter.freeText, 'kanji');
      expect(filter.tagNames, {'jlpt', 'core vocab', 'verbs'});
      expect(filter.tagIds, {'abc'});
      expect(filter.sortField, DeckSearchSortField.letters);
      expect(filter.sortDirection, SearchSortDirection.ascending);
      expect(filter.fuzzyCutoff, 100);
    });

    test('keeps unknown directives in the query', () {
      final filter = DeckSearchFilter.parse('front:hello sort:missing');

      expect(filter.freeText, 'front:hello sort:missing');
      expect(filter.sortField, DeckSearchSortField.updatedAt);
      expect(filter.sortDirection, SearchSortDirection.descending);
    });
  });

  group('DeckListingSearchFilter.parse', () {
    test('parses deck listing search query syntax', () {
      final filter = DeckListingSearchFilter.parse(
        'popular deck:deck-1 sort:downloads dir:desc fuzzy:55',
      );

      expect(filter.freeText, 'popular');
      expect(filter.deckIds, {'deck-1'});
      expect(filter.sortField, DeckListingSearchSortField.downloads);
      expect(filter.sortDirection, SearchSortDirection.descending);
      expect(filter.fuzzyCutoff, 55);
    });
  });

  group('CardTemplateSearchFilter.parse', () {
    test('parses card template search query syntax', () {
      final filter = CardTemplateSearchFilter.parse(
        'kanji #core deck:deck-1 template:template-1 tag_id:tag-1 sort:updated',
      );

      expect(filter.freeText, 'kanji');
      expect(filter.deckIds, {'deck-1'});
      expect(filter.templateIds, {'template-1'});
      expect(filter.tagNames, {'core'});
      expect(filter.tagIds, {'tag-1'});
      expect(filter.sortField, CardTemplateSearchSortField.updatedAt);
    });
  });

  group('StudyCardSearchFilter.parse', () {
    test('parses study card search query syntax', () {
      final filter = StudyCardSearchFilter.parse(
        'review #hard deck:deck-1 template:template-1 reversed:true fuzzy:25',
      );

      expect(filter.freeText, 'review');
      expect(filter.deckIds, {'deck-1'});
      expect(filter.templateIds, {'template-1'});
      expect(filter.tagNames, {'hard'});
      expect(filter.isReversed, isTrue);
      expect(filter.fuzzyCutoff, 25);
    });
  });
}
