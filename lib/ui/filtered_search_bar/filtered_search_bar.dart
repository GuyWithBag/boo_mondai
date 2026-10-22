import 'package:boo_mondai/core/theme/app_tokens.model.dart';
import 'package:boo_mondai/features/app_theme/app_theme.barrel.dart'
    show Button, TextField;
import 'package:boo_mondai/ui/filtered_search_bar/filtered_search.result_tile.dart';
import 'package:boo_mondai/ui/filtered_search_bar/filtered_search_bar.controller.dart';
import 'package:flutter/material.dart' hide TextField;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:signals_hooks/signals_hooks.dart';

import 'package:theme_variants/theme_variants.dart';

typedef SearchResultBuilder<TObject> =
    Widget Function(BuildContext context, TObject result, int index);

typedef SearchResultLabelBuilder<TObject> = String Function(TObject result);

class FilteredSearchBar<TObject> extends SignalHookWidget {
  const FilteredSearchBar({
    required this.controller,
    super.key,
    this.showFilterButton = true,
    this.placeholder = 'Search Here',
    this.enabled,
    this.autofocus = false,
    this.resultBuilder,
    this.resultLabelBuilder,
    this.onResultSelected,
    this.onChanged,
    this.onSubmitted,
    this.maxDropdownHeight = 320,
  });

  final FilteredSearchBarController<TObject> controller;
  final bool showFilterButton;
  final String placeholder;
  final bool? enabled;
  final bool autofocus;
  final SearchResultBuilder<TObject>? resultBuilder;
  final SearchResultLabelBuilder<TObject>? resultLabelBuilder;
  final ValueChanged<TObject>? onResultSelected;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final double maxDropdownHeight;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final layerLink = useMemoized(LayerLink.new);
    final overlayEntry = useRef<OverlayEntry?>(null);
    final dropdownUpdateId = useRef(0);
    final results = controller.results.value;
    final shouldShowDropdown = controller.shouldShowDropdown.value;

    void removeDropdownOverlay() {
      overlayEntry.value?.remove();
      overlayEntry.value = null;
    }

    void selectResult(TObject result) {
      controller.selectResult();
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
                  color: tokens.colorSurfaceBackground,
                  borderRadius: BorderRadius.circular(tokens.radiusSurfaceXsm),
                  border: Border.all(color: tokens.colorBorderNeutralSubtle),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 18,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(tokens.radiusSurfaceXsm),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final result = results[index];
                      if (resultBuilder != null) {
                        return InkWell(
                          onTap: () => selectResult(result),
                          child: resultBuilder!(context, result, index),
                        );
                      }

                      return SearchResultTile.buildSearchResult<TObject>(
                        context,
                        result,
                        index,
                        label: resultLabelBuilder?.call(result),
                        onTap: () => selectResult(result),
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

        if (!controller.shouldShowDropdown.value) {
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
      updateDropdown();
      return null;
    }, [shouldShowDropdown, results, resultBuilder, resultLabelBuilder]);

    useEffect(() => removeDropdownOverlay, const []);

    final filterEnabled = showFilterButton && controller.hasFilterModal;

    return CompositedTransformTarget(
      link: layerLink,
      child: Row(
        spacing: tokens.spaceLayoutGapSm,
        children: [
          Expanded(
            child: TextField(
              controller: controller.textController,
              focusNode: controller.focusNode,
              enabled: enabled,
              autofocus: autofocus,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              placeholder: placeholder,
              textInputAction: TextInputAction.search,
              variants: const [],
            ),
          ),
          if (showFilterButton)
            Button.icon(
              icon: Icons.tune,
              onPressed: filterEnabled
                  ? () => controller.openFilterModal(context)
                  : null,
              tokens: tokens,
            ),
        ],
      ),
    );
  }
}
