// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/deck_card/selection_indicator.dart
// PURPOSE: Animated circle checkbox for multi-select mode on deck cards
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';

class SelectionIndicator extends StatelessWidget {
  const SelectionIndicator({super.key, required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? scheme.primary : Colors.transparent,
        border: Border.all(
          color: isSelected ? scheme.primary : AppColors.textSecondary,
          width: 2,
        ),
      ),
      child: isSelected
          ? Icon(Icons.check, size: 13, color: scheme.onPrimary)
          : null,
    );
  }
}
