import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        FilteredSearchBarController,
        SearchFilter,
        SearchFilterCodec,
        SearchResultTile,
        SearchResults,
        TextFieldFrame,
        TextFieldSize,
        TextFieldTone,
        appTextFieldStyle,
        useFilteredSearchBarController;
import 'package:flutter/material.dart'
    show
        BuildContext,
        Widget,
        ValueChanged,
        VoidCallback,
        OverlayEntry,
        RenderBox,
        Offset,
        Icon,
        LayerLink,
        Colors,
        BoxConstraints,
        BorderRadius,
        Border,
        BoxShadow,
        BoxDecoration,
        ListView,
        EdgeInsets,
        InkWell,
        ClipRRect,
        DecoratedBox,
        ConstrainedBox,
        Material,
        CompositedTransformFollower,
        Positioned,
        Overlay,
        TextInputAction,
        Icons,
        IconButton,
        InputDecoration,
        TextField,
        WidgetsBinding,
        CompositedTransformTarget;
import 'package:flutter_hooks/flutter_hooks.dart'
    show HookWidget, useMemoized, useRef, useListenable, useEffect;

import 'package:theme_variants/theme_variants.dart' show ThemeVariantsContext;

typedef SearchResultBuilder<TObject> =
    Widget Function(BuildContext context, TObject result, int index);

typedef SearchFilterModalBuilder<TFilter extends SearchFilter> =
    Future<TFilter?> Function(BuildContext context, TFilter currentFilter);

class FilteredSearchBar<TObject, TFilter extends SearchFilter>
    extends HookWidget {
  const FilteredSearchBar({
    required this.filterCodec,
    required this.searchResults,
    this.controller,
    this.items = const [],
    this.initialValue = '',
    this.initialFilter,
    this.placeholder = 'Search',
    this.enabled,
    this.autofocus = false,
    this.resultBuilder,
    this.onResultSelected,
    this.onChanged,
    this.onSubmitted,
    this.onCleared,
    this.onFilterChanged,
    this.onResultsChanged,
    this.onOpenFilterModal,
    this.maxDropdownHeight = 320,
    this.showFilterButton = true,
    super.key,
  });

  final SearchFilterCodec<TFilter> filterCodec;
  final SearchResults<TObject, TFilter> searchResults;
  final FilteredSearchBarController<TObject, TFilter>? controller;
  final Iterable<TObject> items;
  final String initialValue;
  final TFilter? initialFilter;
  final String placeholder;
  final bool? enabled;
  final bool autofocus;
  final SearchResultBuilder<TObject>? resultBuilder;
  final ValueChanged<TObject>? onResultSelected;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onCleared;
  final ValueChanged<TFilter>? onFilterChanged;
  final ValueChanged<List<TObject>>? onResultsChanged;
  final SearchFilterModalBuilder<TFilter>? onOpenFilterModal;
  final double maxDropdownHeight;
  final bool showFilterButton;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final layerLink = useMemoized(LayerLink.new);
    final overlayEntry = useRef<OverlayEntry?>(null);
    final dropdownUpdateId = useRef(0);
    final fallbackController = useFilteredSearchBarController<TObject, TFilter>(
      filterCodec: filterCodec,
      searchResults: searchResults,
      items: items,
      initialText: initialValue,
      initialFilter: initialFilter,
    );
    final searchController = controller ?? fallbackController;
    useListenable(searchController);

    useEffect(() {
      if (controller == null) return null;

      var isActive = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!isActive || !context.mounted) return;
        controller?.setItems(items);
      });

      return () => isActive = false;
    }, [controller, items]);

    void removeDropdownOverlay() {
      overlayEntry.value?.remove();
      overlayEntry.value = null;
    }

    void selectResult(TObject result) {
      searchController.selectResult();
      onResultSelected?.call(result);
    }

    Widget buildDropdown(BuildContext overlayContext) {
      final renderBox = context.findRenderObject() as RenderBox?;
      final width = renderBox?.size.width ?? 0;

      return Positioned(
        width: width,
        child: CompositedTransformFollower(
          link: layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 58),
          child: Material(
            color: Colors.transparent,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: maxDropdownHeight),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: tokens.backgroundSurface,
                  borderRadius: BorderRadius.circular(tokens.radiusSurfaceSm),
                  border: Border.all(color: tokens.borderNeutralSubtle),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 18,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(tokens.radiusSurfaceSm),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: searchController.results.length,
                    itemBuilder: (context, index) {
                      final result = searchController.results[index];
                      if (resultBuilder == null) {
                        return SearchResultTile.buildSearchResult<TObject>(
                          context,
                          result,
                          index,
                          onTap: () => selectResult(result),
                        );
                      }

                      return InkWell(
                        onTap: () => selectResult(result),
                        child: resultBuilder!(context, result, index),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    void updateDropdown() {
      final updateId = ++dropdownUpdateId.value;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted || dropdownUpdateId.value != updateId) return;

        searchController.updateDropdownState();

        if (!context.mounted || dropdownUpdateId.value != updateId) return;

        final shouldShow = searchController.shouldShowDropdown;

        if (!shouldShow) {
          removeDropdownOverlay();
          return;
        }

        if (overlayEntry.value == null) {
          overlayEntry.value = OverlayEntry(builder: buildDropdown);
          Overlay.of(context).insert(overlayEntry.value!);
        } else {
          overlayEntry.value?.markNeedsBuild();
        }
      });
    }

    useEffect(() {
      var isActive = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!isActive || !context.mounted) return;
        onFilterChanged?.call(searchController.filter);
        onResultsChanged?.call(searchController.results);
      });

      updateDropdown();
      return () => isActive = false;
    }, [searchController.filter, searchController.results]);

    useEffect(
      () {
        updateDropdown();
        return null;
      },
      [
        searchController.isDropdownOpen,
        searchController.text,
        searchController.results,
        resultBuilder,
        searchController.shouldShowDropdown,
      ],
    );

    useEffect(() => removeDropdownOverlay, const []);

    Future<void> openFilters() async {
      final filter = await onOpenFilterModal?.call(
        context,
        searchController.filter,
      );
      if (filter == null) return;

      searchController.applyFilter(filter);
      onChanged?.call(searchController.text);
      onFilterChanged?.call(searchController.filter);
      onResultsChanged?.call(searchController.results);
    }

    void clearValue() {
      searchController.clearValue();
      onChanged?.call('');
      onCleared?.call();
    }

    final style = appTextFieldStyle.resolve(tokens, const [
      TextFieldSize.normal,
      TextFieldFrame.outline,
      TextFieldTone.neutral,
    ]);
    final filterEnabled = searchController.isFilterButtonEnabled(
      showFilterButton: showFilterButton,
      enabled: enabled,
    );

    return CompositedTransformTarget(
      link: layerLink,
      child: TextField(
        controller: searchController.textController,
        focusNode: searchController.focusNode,
        enabled: enabled,
        autofocus: autofocus,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        textInputAction: TextInputAction.search,
        cursorColor: style.cursorColor,
        style: style.textStyle,
        decoration: InputDecoration(
          hintText: placeholder,
          prefixIcon: searchController.hasText
              ? IconButton(
                  tooltip: 'Clear search',
                  icon: const Icon(Icons.close),
                  onPressed: clearValue,
                )
              : const Icon(Icons.search),
          prefixIconColor: searchController.hasText
              ? tokens.textPrimary
              : tokens.textMuted,
          suffixIcon: filterEnabled
              ? IconButton(
                  tooltip: 'Filter search',
                  icon: Icon(
                    Icons.tune,
                    color: searchController.hasDirectiveText
                        ? tokens.primary
                        : tokens.textPrimary,
                  ),
                  onPressed: openFilters,
                )
              : null,
        ).applyDefaults(style.decorationTheme),
        onTap: searchController.updateDropdownState,
      ),
    );
  }
}
