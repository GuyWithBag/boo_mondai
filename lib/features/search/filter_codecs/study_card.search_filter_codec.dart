import 'package:boo_mondai/lib.barrel.dart'
    show
        SearchFilterCodec,
        StudyCardSearchFilter,
        SearchFilterModalField,
        SearchFilterDirective,
        SearchFilterTextEditor,
        StudyCardSearchFilterDirective,
        SearchFilterChipEditor,
        SearchFilterBoolEditor,
        SearchFilterSliderEditor;

final class StudyCardSearchFilterCodec
    implements SearchFilterCodec<StudyCardSearchFilter> {
  const StudyCardSearchFilterCodec();

  @override
  StudyCardSearchFilter parse(String input) {
    return StudyCardSearchFilter.parse(input);
  }

  @override
  String format(StudyCardSearchFilter filter) => filter.toSearchText();

  @override
  List<SearchFilterModalField<StudyCardSearchFilter>> get modalFields => [
    SearchFilterModalField(
      directive: SearchFilterDirective(name: 'free_text', order: -1),
      label: 'Search terms',
      buildEditor: (context, filter, onChanged) {
        return SearchFilterTextEditor(
          value: filter.freeText,
          placeholder: 'Search cards',
          onChanged: (value) => onChanged(
            StudyCardSearchFilter(
              freeText: value,
              deckIds: filter.deckIds,
              templateIds: filter.templateIds,
              tagIds: filter.tagIds,
              tagNames: filter.tagNames,
              isReversed: filter.isReversed,
              fuzzyCutoff: filter.fuzzyCutoff,
            ),
          ),
        );
      },
    ),
    SearchFilterModalField(
      directive: StudyCardSearchFilterDirective.deck,
      label: 'Deck IDs',
      buildEditor: (context, filter, onChanged) {
        final values = filter.deckIds.toList()..sort();
        return SearchFilterChipEditor(
          values: values,
          placeholder: 'deck id',
          onChanged: (value) => onChanged(
            StudyCardSearchFilter(
              freeText: filter.freeText,
              deckIds: value.toSet(),
              templateIds: filter.templateIds,
              tagIds: filter.tagIds,
              tagNames: filter.tagNames,
              isReversed: filter.isReversed,
              fuzzyCutoff: filter.fuzzyCutoff,
            ),
          ),
        );
      },
    ),
    SearchFilterModalField(
      directive: StudyCardSearchFilterDirective.template,
      label: 'Template IDs',
      buildEditor: (context, filter, onChanged) {
        final values = filter.templateIds.toList()..sort();
        return SearchFilterChipEditor(
          values: values,
          placeholder: 'template id',
          onChanged: (value) => onChanged(
            StudyCardSearchFilter(
              freeText: filter.freeText,
              deckIds: filter.deckIds,
              templateIds: value.toSet(),
              tagIds: filter.tagIds,
              tagNames: filter.tagNames,
              isReversed: filter.isReversed,
              fuzzyCutoff: filter.fuzzyCutoff,
            ),
          ),
        );
      },
    ),
    SearchFilterModalField(
      directive: StudyCardSearchFilterDirective.tag,
      label: 'Tag names',
      buildEditor: (context, filter, onChanged) {
        final values = filter.tagNames.toList()..sort();
        return SearchFilterChipEditor(
          values: values,
          placeholder: 'tag name',
          onChanged: (value) => onChanged(
            StudyCardSearchFilter(
              freeText: filter.freeText,
              deckIds: filter.deckIds,
              templateIds: filter.templateIds,
              tagIds: filter.tagIds,
              tagNames: value.toSet(),
              isReversed: filter.isReversed,
              fuzzyCutoff: filter.fuzzyCutoff,
            ),
          ),
        );
      },
    ),
    SearchFilterModalField(
      directive: StudyCardSearchFilterDirective.tagId,
      label: 'Tag IDs',
      buildEditor: (context, filter, onChanged) {
        final values = filter.tagIds.toList()..sort();
        return SearchFilterChipEditor(
          values: values,
          placeholder: 'tag id',
          onChanged: (value) => onChanged(
            StudyCardSearchFilter(
              freeText: filter.freeText,
              deckIds: filter.deckIds,
              templateIds: filter.templateIds,
              tagIds: value.toSet(),
              tagNames: filter.tagNames,
              isReversed: filter.isReversed,
              fuzzyCutoff: filter.fuzzyCutoff,
            ),
          ),
        );
      },
    ),
    SearchFilterModalField(
      directive: StudyCardSearchFilterDirective.reversed,
      label: 'Reversed',
      buildEditor: (context, filter, onChanged) {
        return SearchFilterBoolEditor(
          value: filter.isReversed,
          onChanged: (value) => onChanged(
            StudyCardSearchFilter(
              freeText: filter.freeText,
              deckIds: filter.deckIds,
              templateIds: filter.templateIds,
              tagIds: filter.tagIds,
              tagNames: filter.tagNames,
              isReversed: value,
              fuzzyCutoff: filter.fuzzyCutoff,
            ),
          ),
        );
      },
    ),
    SearchFilterModalField(
      directive: StudyCardSearchFilterDirective.fuzzy,
      label: 'Fuzzy cutoff',
      buildEditor: (context, filter, onChanged) {
        return SearchFilterSliderEditor(
          value: filter.fuzzyCutoff,
          min: 0,
          max: 100,
          divisions: 100,
          labelBuilder: (value) => 'Cutoff: $value',
          onChanged: (value) => onChanged(
            StudyCardSearchFilter(
              freeText: filter.freeText,
              deckIds: filter.deckIds,
              templateIds: filter.templateIds,
              tagIds: filter.tagIds,
              tagNames: filter.tagNames,
              isReversed: filter.isReversed,
              fuzzyCutoff: value,
            ),
          ),
        );
      },
    ),
  ];
}
