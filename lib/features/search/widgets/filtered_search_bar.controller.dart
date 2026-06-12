import 'package:boo_mondai/features/search/filters/search_filter.dart';
import 'package:boo_mondai/features/search/filters/search_filter_codec.dart';
import 'package:boo_mondai/features/search/results/search_results.dart';
import 'package:flutter/widgets.dart';

class FilteredSearchBarController<TObject, TFilter extends SearchFilter>
    extends ChangeNotifier {
  FilteredSearchBarController({
    required SearchFilterCodec<TFilter> filterCodec,
    required SearchResults<TObject, TFilter> searchResults,
    Iterable<TObject> items = const [],
    String initialText = '',
    TFilter? initialFilter,
    TextEditingController? textController,
    FocusNode? focusNode,
  }) : _filterCodec = filterCodec,
       _searchResults = searchResults,
       _items = items.toList(),
       textController =
           textController ??
           TextEditingController(
             text: initialFilter == null
                 ? initialText
                 : filterCodec.format(initialFilter),
           ),
       focusNode = focusNode ?? FocusNode(),
       _ownsTextController = textController == null,
       _ownsFocusNode = focusNode == null {
    _filter = initialFilter ?? _filterCodec.parse(this.textController.text);
    _results = _searchResults.resolve(items: _items, filter: _filter);
    this.textController.addListener(_handleTextChanged);
    this.focusNode.addListener(_handleFocusChanged);
  }

  final SearchFilterCodec<TFilter> _filterCodec;
  final SearchResults<TObject, TFilter> _searchResults;
  final TextEditingController textController;
  final FocusNode focusNode;
  final bool _ownsTextController;
  final bool _ownsFocusNode;

  List<TObject> _items;
  late TFilter _filter;
  late List<TObject> _results;
  bool _isDropdownOpen = false;

  String get text => textController.text;
  TFilter get filter => _filter;
  List<TObject> get results => _results;
  bool get hasText => text.trim().isNotEmpty;
  bool get hasFocus => focusNode.hasFocus;
  bool get isDropdownOpen => _isDropdownOpen;
  bool get hasDropdownResults => hasText && _results.isNotEmpty;
  bool get shouldShowDropdown => _isDropdownOpen && hasDropdownResults;
  bool get hasDirectiveText =>
      _filter.toSearchText().trim() != _filter.freeText.trim();
  TextEditingValue get value => textController.value;

  set value(TextEditingValue value) {
    textController.value = value;
  }

  void setText(String text) {
    if (textController.text == text) return;
    textController.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  void setItems(Iterable<TObject> items) {
    final nextItems = items.toList();
    if (_hasSameItems(nextItems)) return;

    _items = nextItems;
    _resolveResults();
    notifyListeners();
  }

  void applyFilter(TFilter filter) {
    _filter = filter;
    final nextText = _filterCodec.format(filter);
    _setTextWithoutNotify(nextText);
    _resolveResults();
    notifyListeners();
  }

  void clearValue() {
    if (textController.text.isEmpty) return;

    textController.clear();
    closeDropdown();
  }

  void selectResult() {
    closeDropdown();
    focusNode.unfocus();
  }

  bool isFilterButtonEnabled({required bool showFilterButton, bool? enabled}) {
    return showFilterButton && enabled != false;
  }

  void openDropdown() {
    if (_isDropdownOpen) return;
    _isDropdownOpen = true;
    notifyListeners();
  }

  void closeDropdown() {
    if (!_isDropdownOpen) return;
    _isDropdownOpen = false;
    notifyListeners();
  }

  void updateDropdownState() {
    if (focusNode.hasFocus && _results.isNotEmpty) {
      openDropdown();
    } else {
      closeDropdown();
    }
  }

  void _setTextWithoutNotify(String text) {
    if (textController.text == text) return;
    textController.removeListener(_handleTextChanged);
    textController.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
    textController.addListener(_handleTextChanged);
  }

  void _resolveResults() {
    _results = _searchResults.resolve(items: _items, filter: _filter);
  }

  bool _hasSameItems(List<TObject> nextItems) {
    if (_items.length != nextItems.length) return false;

    for (var i = 0; i < _items.length; i++) {
      if (!identical(_items[i], nextItems[i])) return false;
    }

    return true;
  }

  void _handleTextChanged() {
    _filter = _filterCodec.parse(textController.text);
    _resolveResults();
    updateDropdownState();
    notifyListeners();
  }

  void _handleFocusChanged() {
    updateDropdownState();
    notifyListeners();
  }

  @override
  void dispose() {
    textController.removeListener(_handleTextChanged);
    focusNode.removeListener(_handleFocusChanged);
    if (_ownsTextController) textController.dispose();
    if (_ownsFocusNode) focusNode.dispose();
    super.dispose();
  }
}
