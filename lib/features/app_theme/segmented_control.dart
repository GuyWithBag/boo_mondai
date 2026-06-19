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
        useSelectionController,
        surfaceStyle;
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
    super.key,
  });

  final List<SegmentOption<T>> options;
  final T value;
  final ValueChanged<T> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final selection = useSelectionController<T>(
      selectedValues: [value],
      onSelectionChanged: (selected) {
        if (selected.isEmpty) return;
        onChanged(selected.first);
      },
    );

    return Surface(
      style: surfaceStyle
          .resolve(tokens, const [
            SurfaceColor.muted,
            SurfaceBorder.none,
            SurfaceShadow.none,
            SurfacePadding.xsm,
            SurfaceShape.roundedSm,
          ])
          .copyWith(padding: EdgeInsets.all(10)),

      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          spacing: tokens.spaceLayoutGapSm,
          children: [
            for (final option in options)
              _SegmentedControlOption<T>(
                option: option,
                selected: selection.isSelected(option.value),
                enabled: enabled,
                onTap: () => selection.select(option.value),
              ),
          ],
        ),
      ),
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
  final VoidCallback onTap;

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
      onTap: enabled ? onTap : null,
      child: Surface(style: style, child: Text(option.label)),
    );
  }
}
