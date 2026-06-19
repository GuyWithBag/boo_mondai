import 'package:boo_mondai/lib.barrel.dart'
    show
        DueFilterThreshold,
        SegmentOption,
        ReviewDeckSearchFilter,
        SearchFilterCodec,
        SearchFilterModalField,
        SearchFilterDirective,
        SearchFilterTextEditor,
        ReviewDeckSearchFilterDirective,
        SearchFilterEnumEditor,
        SearchFilterSliderEditor;

final class ReviewDeckSearchFilterCodec
    implements SearchFilterCodec<ReviewDeckSearchFilter> {
  const ReviewDeckSearchFilterCodec();

  @override
  ReviewDeckSearchFilter parse(String input) {
    return ReviewDeckSearchFilter.parse(input);
  }

  @override
  String format(ReviewDeckSearchFilter filter) => filter.toSearchText();

  @override
  List<SearchFilterModalField<ReviewDeckSearchFilter>> get modalFields => [
    SearchFilterModalField(
      directive: SearchFilterDirective(name: 'free_text', order: -1),
      label: 'Search terms',
      buildEditor: (context, filter, onChanged) {
        return SearchFilterTextEditor(
          value: filter.freeText,
          placeholder: 'Search review decks',
          onChanged: (value) => onChanged(
            ReviewDeckSearchFilter(
              freeText: value,
              dueFilter: filter.dueFilter,
              fuzzyCutoff: filter.fuzzyCutoff,
            ),
          ),
        );
      },
    ),
    SearchFilterModalField(
      directive: ReviewDeckSearchFilterDirective.due,
      label: 'Due window',
      buildEditor: (context, filter, onChanged) {
        return SearchFilterEnumEditor<DueFilterThreshold>(
          value: filter.dueFilter,
          onChanged: (value) => onChanged(
            ReviewDeckSearchFilter(
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
      directive: ReviewDeckSearchFilterDirective.fuzzy,
      label: 'Fuzzy cutoff',
      buildEditor: (context, filter, onChanged) {
        return SearchFilterSliderEditor(
          value: filter.fuzzyCutoff,
          min: 0,
          max: 100,
          divisions: 100,
          labelBuilder: (value) => 'Cutoff: $value',
          onChanged: (value) => onChanged(
            ReviewDeckSearchFilter(
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
