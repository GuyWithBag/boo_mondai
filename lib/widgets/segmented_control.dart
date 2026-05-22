import 'package:boo_mondai/variant_styles/variant_styles.barrel.dart';
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

import 'package:boo_mondai/shared/shared.barrel.dart';

class SegmentOption<T> {
  const SegmentOption({required this.value, required this.label});

  final T value;
  final String label;
}

class SegmentedControl<T> extends StatelessWidget {
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

    return Surface(
      style: SurfaceStyle(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: tokens.softGray,
          borderRadius: BorderRadius.circular(tokens.radius3xl),
        ),
      ),

      child: Wrap(
        spacing: 8,
        children: [
          for (final option in options)
            _SegmentedControlOption<T>(
              option: option,
              selected: option.value == value,
              enabled: enabled,
              onTap: () => onChanged(option.value),
            ),
        ],
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
          BorderRadius.circular(tokens.radius2xl),
      onTap: enabled ? onTap : null,
      child: Surface(style: style, child: Text(option.label)),
    );
  }
}
