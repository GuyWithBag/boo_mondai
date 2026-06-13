import 'package:boo_mondai/lib.barrel.dart'
    show
        DeckListingSearchSortField,
        SearchSortDirection,
        SegmentOption,
        DeckListingSearchFilter,
        SearchFilterCodec,
        SearchFilterModalField,
        SearchFilterDirective,
        SearchFilterTextEditor,
        DeckListingSearchFilterDirective,
        SearchFilterChipEditor,
        SearchFilterEnumEditor,
        SearchFilterSliderEditor;

final class DeckListingSearchFilterCodec
    implements SearchFilterCodec<DeckListingSearchFilter> {
  const DeckListingSearchFilterCodec();

  @override
  DeckListingSearchFilter parse(String input) {
    return DeckListingSearchFilter.parse(input);
  }

  @override
  String format(DeckListingSearchFilter filter) => filter.toSearchText();

  @override
  List<SearchFilterModalField<DeckListingSearchFilter>> get modalFields => [
    SearchFilterModalField(
      directive: SearchFilterDirective(name: 'free_text', order: -1),
      label: 'Search terms',
      buildEditor: (context, filter, onChanged) {
        return SearchFilterTextEditor(
          value: filter.freeText,
          placeholder: 'Search decks',
          onChanged: (value) => onChanged(
            DeckListingSearchFilter(
              freeText: value,
              deckIds: filter.deckIds,
              sortField: filter.sortField,
              sortDirection: filter.sortDirection,
              fuzzyCutoff: filter.fuzzyCutoff,
            ),
          ),
        );
      },
    ),
    SearchFilterModalField(
      directive: DeckListingSearchFilterDirective.deck,
      label: 'Deck IDs',
      buildEditor: (context, filter, onChanged) {
        final values = filter.deckIds.toList()..sort();
        return SearchFilterChipEditor(
          values: values,
          placeholder: 'deck id',
          onChanged: (value) => onChanged(
            DeckListingSearchFilter(
              freeText: filter.freeText,
              deckIds: value.toSet(),
              sortField: filter.sortField,
              sortDirection: filter.sortDirection,
              fuzzyCutoff: filter.fuzzyCutoff,
            ),
          ),
        );
      },
    ),
    SearchFilterModalField(
      directive: DeckListingSearchFilterDirective.sort,
      label: 'Sort field',
      buildEditor: (context, filter, onChanged) {
        return SearchFilterEnumEditor<DeckListingSearchSortField>(
          value: filter.sortField,
          onChanged: (value) => onChanged(
            DeckListingSearchFilter(
              freeText: filter.freeText,
              deckIds: filter.deckIds,
              sortField: value,
              sortDirection: filter.sortDirection,
              fuzzyCutoff: filter.fuzzyCutoff,
            ),
          ),
          options: const [
            SegmentOption(
              value: DeckListingSearchSortField.createdAt,
              label: 'Created',
            ),
            SegmentOption(
              value: DeckListingSearchSortField.updatedAt,
              label: 'Updated',
            ),
            SegmentOption(
              value: DeckListingSearchSortField.downloads,
              label: 'Downloads',
            ),
            SegmentOption(
              value: DeckListingSearchSortField.favorites,
              label: 'Favorites',
            ),
            SegmentOption(
              value: DeckListingSearchSortField.upvotes,
              label: 'Votes',
            ),
            SegmentOption(
              value: DeckListingSearchSortField.comments,
              label: 'Comments',
            ),
            SegmentOption(
              value: DeckListingSearchSortField.reviews,
              label: 'Reviews',
            ),
          ],
        );
      },
    ),
    SearchFilterModalField(
      directive: DeckListingSearchFilterDirective.direction,
      label: 'Sort direction',
      buildEditor: (context, filter, onChanged) {
        return SearchFilterEnumEditor<SearchSortDirection>(
          value: filter.sortDirection,
          onChanged: (value) => onChanged(
            DeckListingSearchFilter(
              freeText: filter.freeText,
              deckIds: filter.deckIds,
              sortField: filter.sortField,
              sortDirection: value,
              fuzzyCutoff: filter.fuzzyCutoff,
            ),
          ),
          options: const [
            SegmentOption(value: SearchSortDirection.ascending, label: 'Asc'),
            SegmentOption(value: SearchSortDirection.descending, label: 'Desc'),
          ],
        );
      },
    ),
    SearchFilterModalField(
      directive: DeckListingSearchFilterDirective.fuzzy,
      label: 'Fuzzy cutoff',
      buildEditor: (context, filter, onChanged) {
        return SearchFilterSliderEditor(
          value: filter.fuzzyCutoff,
          min: 0,
          max: 100,
          divisions: 100,
          labelBuilder: (value) => 'Cutoff: $value',
          onChanged: (value) => onChanged(
            DeckListingSearchFilter(
              freeText: filter.freeText,
              deckIds: filter.deckIds,
              sortField: filter.sortField,
              sortDirection: filter.sortDirection,
              fuzzyCutoff: value,
            ),
          ),
        );
      },
    ),
  ];
}
