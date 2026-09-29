import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        SegmentControlOptionState,
        SurfaceBorder,
        SurfaceColor,
        SurfacePadding,
        SurfaceShadow,
        SurfaceShape,
        segmentControlOptionStyle,
        surfaceStyle,
        SelectionController;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class SegmentOption<T> {
  const SegmentOption({required this.value, required this.label});

  final T value;
  final String label;
}

class SegmentedControl<T> extends HookWidget {
  const SegmentedControl({
    required this.options,
    required this.value,
    required this.onChanged,
    this.enabled = true,
    this.isOptionEnabled,
    this.onDisabledOptionPressed,
    super.key,
    this.isScrollable = false,
  });

  final List<SegmentOption<T>> options;
  final T value;
  final ValueChanged<T> onChanged;
  final bool enabled;
  final bool Function(T value)? isOptionEnabled;
  final ValueChanged<T>? onDisabledOptionPressed;
  final bool isScrollable;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    // Todo: Make the constructor accept a controller instead.
    final selection = useMemoized(
      () => SelectionController<T>(
        selectedValues: {value},
        onSelectionChanged: (selected) {
          if (selected.isEmpty) return;
          onChanged(selected.first);
        },
      ),
    );
    useEffect(() {
      selection.selectedValues.value = {value};
      return null;
    }, [selection, value]);
    useEffect(() => selection.dispose, [selection]);

    Widget buildOption({
      required SegmentOption<T> option,
      required bool selected,
      required bool enabled,
      required VoidCallback? onTap,
    }) {
      if (isScrollable) {
        return _SegmentedControlOption<T>(
          option: option,
          selected: selected,
          enabled: enabled,
          onTap: onTap,
        );
      }
      return Expanded(
        child: _SegmentedControlOption<T>(
          option: option,
          selected: selected,
          enabled: enabled,
          onTap: onTap,
        ),
      );
    }

    Widget body = Row(
      spacing: tokens.spaceLayoutGapSm,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        for (final option in options)
          buildOption(
            option: option,
            selected: selection.isSelected(option.value),
            enabled: enabled && (isOptionEnabled?.call(option.value) ?? true),
            onTap: !enabled
                ? null
                : (isOptionEnabled?.call(option.value) ?? true)
                ? () => selection.select(option.value)
                : () => onDisabledOptionPressed?.call(option.value),
          ),
      ],
    );

    if (isScrollable) {
      body = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: body,
      );
    }

    return Surface(
      style: surfaceStyle
          .resolve(tokens, const [
            SurfaceColor.muted,
            SurfaceBorder.none,
            SurfaceShadow.none,
            SurfacePadding.sm,
            SurfaceShape.roundedSm,
          ])
          .copyWith(padding: EdgeInsets.all(10)),

      child: body,
    );
  }
}

class _SegmentedControlOption<T> extends StatelessWidget {
  const _SegmentedControlOption({
    required this.option,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  final SegmentOption<T> option;
  final bool selected;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final state = !enabled
        ? SegmentControlOptionState.disabled
        : selected
        ? SegmentControlOptionState.selected
        : SegmentControlOptionState.idle;
    final style = segmentControlOptionStyle.resolve(tokens, [state]);

    return InkWell(
      borderRadius:
          style.decoration.borderRadius as BorderRadius? ??
          BorderRadius.circular(tokens.radiusSurfaceXsm),
      onTap: onTap,
      child: Surface(
        style: style,
        child: Center(child: Text(option.label)),
      ),
    );
  }
}
