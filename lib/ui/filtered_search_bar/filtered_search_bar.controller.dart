import 'package:boo_mondai/features/search/models/search.token_shape.dart';
import 'package:boo_mondai/features/search/models/search_tokens.dart';
import 'package:boo_mondai/features/search/search.service.dart';
import 'package:boo_mondai/features/search_filter.modal/search_filter.modal.dart';
import 'package:boo_mondai/features/search_filter.modal/search_filter.modal_field.dart';
import 'package:flutter/widgets.dart';
import 'package:signals/signals_flutter.dart';

typedef FilteredSearchModalOpener<TObject> =
    Future<void> Function(
      BuildContext context,
      FilteredSearchBarController<TObject> controller,
    );

class FilteredSearchBarController<TObject> {
  FilteredSearchBarController({
    required this.tokenShapes,
    required this.searchTextLabel,
    this.itemFilter,
    this.sorter,
    this.defaultFuzzyCutoff = 60,
    this.modalFields = const [],
    FilteredSearchModalOpener<TObject>? openFilterModal,
    Iterable<TObject> items = const [],
    String initialInput = '',
    TextEditingController? textController,
    FocusNode? focusNode,
  }) : textController =
           textController ?? TextEditingController(text: initialInput),
       focusNode = focusNode ?? FocusNode(),
       _openFilterModal = openFilterModal,
       _ownsTextController = textController == null,
       _ownsFocusNode = focusNode == null {
    input = signal(this.textController.text);
    sourceItems = signal(items.toList());
    hasFocus = signal(this.focusNode.hasFocus);
    tokens = computed(
      () => SearchTokens(input: input.value, tokenShapes: tokenShapes),
    );
    results = computed(
      () => SearchService.resolve<TObject>(
        input: input.value,
        items: sourceItems.value,
        tokenShapes: tokenShapes,
        searchTextLabel: searchTextLabel,
        itemFilter: itemFilter,
        sorter: sorter,
        defaultFuzzyCutoff: defaultFuzzyCutoff,
      ),
    );
    hasText = computed(() => input.value.trim().isNotEmpty);
    hasDropdownResults = computed(
      () => hasText.value && results.value.isNotEmpty,
    );
    shouldShowDropdown = computed(
      () => hasFocus.value && hasDropdownResults.value,
    );

    this.textController.addListener(_handleTextChanged);
    this.focusNode.addListener(_handleFocusChanged);
  }

  final List<SearchTokenShape> tokenShapes;
  final SearchTextLabel<TObject> searchTextLabel;
  final SearchItemFilter<TObject>? itemFilter;
  final SearchSorter<TObject>? sorter;
  final int defaultFuzzyCutoff;
  final List<SearchTokenModalField> modalFields;
  final FilteredSearchModalOpener<TObject>? _openFilterModal;
  final TextEditingController textController;
  final FocusNode focusNode;
  final bool _ownsTextController;
  final bool _ownsFocusNode;

  late final Signal<String> input;
  late final Signal<List<TObject>> sourceItems;
  late final Signal<bool> hasFocus;
  late final Computed<SearchTokens> tokens;
  late final Computed<List<TObject>> results;
  late final Computed<bool> hasText;
  late final Computed<bool> hasDropdownResults;
  late final Computed<bool> shouldShowDropdown;

  String get text => input.value;
  bool get hasFilterModal => tokenShapes.isNotEmpty;

  void setInput(String value) {
    if (textController.text == value) {
      input.value = value;
      return;
    }

    textController.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }

  void setItems(Iterable<TObject> items) {
    sourceItems.value = items.toList();
  }

  void clear() {
    if (textController.text.isEmpty) return;

    textController.clear();
  }

  void selectResult() {
    focusNode.unfocus();
  }

  Future<void> openFilterModal(BuildContext context) async {
    final customOpenFilterModal = _openFilterModal;
    if (customOpenFilterModal != null) {
      await customOpenFilterModal(context, this);
      return;
    }

    final nextInput = await showSearchFilterModal(
      context: context,
      currentTokens: tokens.value,
      tokenShapes: tokenShapes,
      fields: modalFields,
    );
    if (nextInput == null) return;

    setInput(nextInput);
  }

  void _handleTextChanged() {
    input.value = textController.text;
  }

  void _handleFocusChanged() {
    hasFocus.value = focusNode.hasFocus;
  }

  void dispose() {
    textController.removeListener(_handleTextChanged);
    focusNode.removeListener(_handleFocusChanged);
    if (_ownsTextController) textController.dispose();
    if (_ownsFocusNode) focusNode.dispose();

    shouldShowDropdown.dispose();
    hasDropdownResults.dispose();
    hasText.dispose();
    results.dispose();
    tokens.dispose();
    hasFocus.dispose();
    sourceItems.dispose();
    input.dispose();
  }
}
