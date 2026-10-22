import 'package:boo_mondai/lib.barrel.dart'
    show SearchTokenShape, SearchTokens, StudyDeckEntry;

abstract final class ViewStudyDecksSearch {
  static const sort = SearchTokenShape(name: 'sort', aliases: ['sort_by']);
  static const direction = SearchTokenShape(
    name: 'direction',
    aliases: ['dir', 'order'],
  );
  static const fuzzy = SearchTokenShape(name: 'fuzzy', aliases: ['cutoff']);

  static const tokenShapes = [sort, direction, fuzzy];

  static String searchTextLabel(StudyDeckEntry entry) {
    final deck = entry.deck;
    return [
      deck.title,
      deck.shortDescription,
      deck.longDescription,
      for (final tag in deck.tags) tag.name,
      entry.totalDue.toString(),
    ].join(' ');
  }

  static List<StudyDeckEntry> sorter(
    List<StudyDeckEntry> entries,
    SearchTokens tokens,
  ) {
    final sorted = [...entries];
    final sortValue = tokens.getLast(sort)?.trim().toLowerCase();
    final isAscending =
        tokens.getLast(direction)?.trim().toLowerCase() == 'ascending' ||
        tokens.getLast(direction)?.trim().toLowerCase() == 'asc';

    sorted.sort((a, b) {
      final comparison = switch (sortValue) {
        'letters' || 'title' || 'name' => a.deck.title.toLowerCase().compareTo(
          b.deck.title.toLowerCase(),
        ),
        'created_at' ||
        'created' => a.deck.createdAt.compareTo(b.deck.createdAt),
        'updated_at' ||
        'updated' => a.deck.updatedAt.compareTo(b.deck.updatedAt),
        _ => a.totalDue.compareTo(b.totalDue),
      };
      return isAscending ? comparison : -comparison;
    });
    return sorted;
  }
}
