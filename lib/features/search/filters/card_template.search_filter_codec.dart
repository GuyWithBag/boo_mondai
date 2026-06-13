import 'package:boo_mondai/lib.barrel.dart'
    show
        CardTemplateSearchSortField,
        SearchSortDirection,
        SegmentOption,
        CardTemplateSearchFilter,
        SearchFilterCodec,
        SearchFilterModalField,
        SearchFilterDirective,
        SearchFilterTextEditor,
        CardTemplateSearchFilterDirective,
        SearchFilterChipEditor,
        SearchFilterEnumEditor,
        SearchFilterSliderEditor;

final class CardTemplateSearchFilterCodec
    implements SearchFilterCodec<CardTemplateSearchFilter> {
  const CardTemplateSearchFilterCodec();

  @override
  CardTemplateSearchFilter parse(String input) {
    return CardTemplateSearchFilter.parse(input);
  }

  @override
  String format(CardTemplateSearchFilter filter) => filter.toSearchText();

  @override
  List<SearchFilterModalField<CardTemplateSearchFilter>> get modalFields => [
    SearchFilterModalField(
      directive: SearchFilterDirective(name: 'free_text', order: -1),
      label: 'Search terms',
      buildEditor: (context, filter, onChanged) {
        return SearchFilterTextEditor(
          value: filter.freeText,
          placeholder: 'Search templates',
          onChanged: (value) => onChanged(
            CardTemplateSearchFilter(
              freeText: value,
              deckIds: filter.deckIds,
              templateIds: filter.templateIds,
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
      directive: CardTemplateSearchFilterDirective.deck,
      label: 'Deck IDs',
      buildEditor: (context, filter, onChanged) {
        final values = filter.deckIds.toList()..sort();
        return SearchFilterChipEditor(
          values: values,
          placeholder: 'deck id',
          onChanged: (value) => onChanged(
            CardTemplateSearchFilter(
              freeText: filter.freeText,
              deckIds: value.toSet(),
              templateIds: filter.templateIds,
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
      directive: CardTemplateSearchFilterDirective.template,
      label: 'Template IDs',
      buildEditor: (context, filter, onChanged) {
        final values = filter.templateIds.toList()..sort();
        return SearchFilterChipEditor(
          values: values,
          placeholder: 'template id',
          onChanged: (value) => onChanged(
            CardTemplateSearchFilter(
              freeText: filter.freeText,
              deckIds: filter.deckIds,
              templateIds: value.toSet(),
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
      directive: CardTemplateSearchFilterDirective.tag,
      label: 'Tag names',
      buildEditor: (context, filter, onChanged) {
        final values = filter.tagNames.toList()..sort();
        return SearchFilterChipEditor(
          values: values,
          placeholder: 'tag name',
          onChanged: (value) => onChanged(
            CardTemplateSearchFilter(
              freeText: filter.freeText,
              deckIds: filter.deckIds,
              templateIds: filter.templateIds,
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
      directive: CardTemplateSearchFilterDirective.tagId,
      label: 'Tag IDs',
      buildEditor: (context, filter, onChanged) {
        final values = filter.tagIds.toList()..sort();
        return SearchFilterChipEditor(
          values: values,
          placeholder: 'tag id',
          onChanged: (value) => onChanged(
            CardTemplateSearchFilter(
              freeText: filter.freeText,
              deckIds: filter.deckIds,
              templateIds: filter.templateIds,
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
      directive: CardTemplateSearchFilterDirective.sort,
      label: 'Sort field',
      buildEditor: (context, filter, onChanged) {
        return SearchFilterEnumEditor<CardTemplateSearchSortField>(
          value: filter.sortField,
          onChanged: (value) => onChanged(
            CardTemplateSearchFilter(
              freeText: filter.freeText,
              deckIds: filter.deckIds,
              templateIds: filter.templateIds,
              tagIds: filter.tagIds,
              tagNames: filter.tagNames,
              sortField: value,
              sortDirection: filter.sortDirection,
              fuzzyCutoff: filter.fuzzyCutoff,
            ),
          ),
          options: const [
            SegmentOption(
              value: CardTemplateSearchSortField.sortOrder,
              label: 'Sort order',
            ),
            SegmentOption(
              value: CardTemplateSearchSortField.createdAt,
              label: 'Created',
            ),
            SegmentOption(
              value: CardTemplateSearchSortField.updatedAt,
              label: 'Updated',
            ),
          ],
        );
      },
    ),
    SearchFilterModalField(
      directive: CardTemplateSearchFilterDirective.direction,
      label: 'Sort direction',
      buildEditor: (context, filter, onChanged) {
        return SearchFilterEnumEditor<SearchSortDirection>(
          value: filter.sortDirection,
          onChanged: (value) => onChanged(
            CardTemplateSearchFilter(
              freeText: filter.freeText,
              deckIds: filter.deckIds,
              templateIds: filter.templateIds,
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
      directive: CardTemplateSearchFilterDirective.fuzzy,
      label: 'Fuzzy cutoff',
      buildEditor: (context, filter, onChanged) {
        return SearchFilterSliderEditor(
          value: filter.fuzzyCutoff,
          min: 0,
          max: 100,
          divisions: 100,
          labelBuilder: (value) => 'Cutoff: $value',
          onChanged: (value) => onChanged(
            CardTemplateSearchFilter(
              freeText: filter.freeText,
              deckIds: filter.deckIds,
              templateIds: filter.templateIds,
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
