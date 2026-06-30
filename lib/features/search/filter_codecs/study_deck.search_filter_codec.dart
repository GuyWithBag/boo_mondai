import 'package:boo_mondai/lib.barrel.dart'
    show
        DueFilterThreshold,
        SegmentOption,
        StudyDeckSearchFilter,
        SearchFilterCodec,
        SearchFilterModalField,
        SearchFilterDirective,
        SearchFilterTextEditor,
        StudyDeckSearchFilterDirective,
        SearchFilterEnumEditor,
        SearchFilterSliderEditor;

final class StudyDeckSearchFilterCodec
    implements SearchFilterCodec<StudyDeckSearchFilter> {
  const StudyDeckSearchFilterCodec();

  @override
  StudyDeckSearchFilter parse(String input) {
    return StudyDeckSearchFilter.parse(input);
  }

  @override
  String format(StudyDeckSearchFilter filter) => filter.toSearchText();

  @override
  List<SearchFilterModalField<StudyDeckSearchFilter>> get modalFields => [
    SearchFilterModalField(
      directive: SearchFilterDirective(name: 'free_text', order: -1),
      label: 'Search terms',
      buildEditor: (context, filter, onChanged) {
        return SearchFilterTextEditor(
          value: filter.freeText,
          placeholder: 'Search review decks',
          onChanged: (value) => onChanged(
            StudyDeckSearchFilter(
              freeText: value,
              dueFilter: filter.dueFilter,
              fuzzyCutoff: filter.fuzzyCutoff,
            ),
          ),
        );
      },
    ),
    SearchFilterModalField(
      directive: StudyDeckSearchFilterDirective.due,
      label: 'Due window',
      buildEditor: (context, filter, onChanged) {
        return SearchFilterEnumEditor<DueFilterThreshold>(
          value: filter.dueFilter,
          onChanged: (value) => onChanged(
            StudyDeckSearchFilter(
              freeText: filter.freeText,
              dueFilter: value,
              fuzzyCutoff: filter.fuzzyCutoff,
            ),
          ),
          options: const [
            SegmentOption(
              value: DueFilterThreshold.exactAndOverdue,
              label: 'Exact',
            ),
            SegmentOption(
              value: DueFilterThreshold.lookAheadOneHour,
              label: '1h',
            ),
            SegmentOption(
              value: DueFilterThreshold.lookAheadOneDay,
              label: '1d',
            ),
            SegmentOption(value: DueFilterThreshold.cramAll, label: 'Cram'),
          ],
        );
      },
    ),
    SearchFilterModalField(
      directive: StudyDeckSearchFilterDirective.fuzzy,
      label: 'Fuzzy cutoff',
      buildEditor: (context, filter, onChanged) {
        return SearchFilterSliderEditor(
          value: filter.fuzzyCutoff,
          min: 0,
          max: 100,
          divisions: 100,
          labelBuilder: (value) => 'Cutoff: $value',
          onChanged: (value) => onChanged(
            StudyDeckSearchFilter(
              freeText: filter.freeText,
              dueFilter: filter.dueFilter,
              fuzzyCutoff: value,
            ),
          ),
        );
      },
    ),
  ];
}
