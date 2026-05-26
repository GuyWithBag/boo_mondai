import 'package:boo_mondai/lib.barrel.dart'
    show ChipTone, AppTokens, appChipStyle;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class ToggleChip extends StatelessWidget {
  const ToggleChip({
    super.key,
    required this.label,
    required this.selected,
    this.onChanged,
    this.selectedTone = ChipTone.filled,
    this.unselectedTone = ChipTone.easy,
    this.isBusy = false,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool>? onChanged;
  final ChipTone selectedTone;
  final ChipTone unselectedTone;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final tone = selected ? selectedTone : unselectedTone;

    return ChipTheme(
      data: appChipStyle.resolve(tokens, [tone]),
      child: ActionChip(
        label: Text(label),
        onPressed: onChanged == null || isBusy
            ? null
            : () => onChanged!(!selected),
      ),
    );
  }
}
