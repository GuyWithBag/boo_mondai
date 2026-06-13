import 'package:boo_mondai/lib.barrel.dart'
    show
        DeckSearchSortField,
        SearchSortDirection,
        SegmentOption,
        DeckSearchFilter,
        SearchFilterCodec,
        SearchFilterModalField,
        SearchFilterDirective,
        SearchFilterTextEditor,
        DeckSearchFilterDirective,
        SearchFilterChipEditor,
        SearchFilterEnumEditor,
        SearchFilterSliderEditor;

final class DeckSearchFilterCodec
    implements SearchFilterCodec<DeckSearchFilter> {
  const DeckSearchFilterCodec();

  @override
  DeckSearchFilter parse(String input) => DeckSearchFilter.parse(input);

  @override
  String format(DeckSearchFilter filter) => filter.toSearchText();

  @override
  List<SearchFilterModalField<DeckSearchFilter>> get modalFields => [
    SearchFilterModalField(
      directive: SearchFilterDirective(name: 'free_text', order: -1),
      label: 'Search terms',
      buildEditor: (context, filter, onChanged) {
        return SearchFilterTextEditor(
          value: filter.freeText,
          placeholder: 'Search decks',
          onChanged: (value) => onChanged(
            DeckSearchFilter(
              freeText: value,
              tagIds: filter.tagIds,
              tagNames: filter.tagNames,
              sortField: filter.sortField,
              sortDirection: filter.sortDirection,
              fuzzyCutoff: filter.fuzzyCutoff,
            ),
          ),
        );
      },
    ),
    SearchFilterModalField(
      directive: DeckSearchFilterDirective.tag,
      label: 'Tag names',
      buildEditor: (context, filter, onChanged) {
        final values = filter.tagNames.toList()..sort();
        return SearchFilterChipEditor(
          values: values,
          placeholder: 'tag name',
          onChanged: (value) => onChanged(
            DeckSearchFilter(
              freeText: filter.freeText,
              tagIds: filter.tagIds,
              tagNames: value.toSet(),
              sortField: filter.sortField,
              sortDirection: filter.sortDirection,
              fuzzyCutoff: filter.fuzzyCutoff,
            ),
          ),
        );
      },
    ),
    SearchFilterModalField(
      directive: DeckSearchFilterDirective.tagId,
      label: 'Tag IDs',
      buildEditor: (context, filter, onChanged) {
        final values = filter.tagIds.toList()..sort();
        return SearchFilterChipEditor(
          values: values,
          placeholder: 'tag id',
          onChanged: (value) => onChanged(
            DeckSearchFilter(
              freeText: filter.freeText,
              tagIds: value.toSet(),
              tagNames: filter.tagNames,
              sortField: filter.sortField,
              sortDirection: filter.sortDirection,
              fuzzyCutoff: filter.fuzzyCutoff,
            ),
          ),
        );
      },
    ),
    SearchFilterModalField(
      directive: DeckSearchFilterDirective.sort,
      label: 'Sort field',
      buildEditor: (context, filter, onChanged) {
        return SearchFilterEnumEditor<DeckSearchSortField>(
          value: filter.sortField,
          onChanged: (value) => onChanged(
            DeckSearchFilter(
              freeText: filter.freeText,
              tagIds: filter.tagIds,
              tagNames: filter.tagNames,
              sortField: value,
              sortDirection: filter.sortDirection,
              fuzzyCutoff: filter.fuzzyCutoff,
            ),
          ),
          options: const [
            SegmentOption(value: DeckSearchSortField.letters, label: 'Letters'),
            SegmentOption(
              value: DeckSearchSortField.createdAt,
              label: 'Created',
            ),
            SegmentOption(
              value: DeckSearchSortField.updatedAt,
              label: 'Updated',
            ),
          ],
        );
      },
    ),
    SearchFilterModalField(
      directive: DeckSearchFilterDirective.direction,
      label: 'Sort direction',
      buildEditor: (context, filter, onChanged) {
        return SearchFilterEnumEditor<SearchSortDirection>(
          value: filter.sortDirection,
          onChanged: (value) => onChanged(
            DeckSearchFilter(
              freeText: filter.freeText,
              tagIds: filter.tagIds,
              tagNames: filter.tagNames,
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
      directive: DeckSearchFilterDirective.fuzzy,
      label: 'Fuzzy cutoff',
      buildEditor: (context, filter, onChanged) {
        return SearchFilterSliderEditor(
          value: filter.fuzzyCutoff,
          min: 0,
          max: 100,
          divisions: 100,
          labelBuilder: (value) => 'Cutoff: $value',
          onChanged: (value) => onChanged(
            DeckSearchFilter(
              freeText: filter.freeText,
              tagIds: filter.tagIds,
              tagNames: filter.tagNames,
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
