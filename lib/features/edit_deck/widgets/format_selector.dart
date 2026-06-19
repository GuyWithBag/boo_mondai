import 'package:boo_mondai/lib.barrel.dart'
    show Button, AppTokens, useSelectionController;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class FormatSelector extends HookWidget {
  const FormatSelector({
    required this.selectedIndex,
    required this.onChanged,
    super.key,
  });

  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final formats = [
      (Icons.slideshow_outlined, 'Flashcard'),
      (Icons.list, 'Multiple Choice'),
      (Icons.draw, 'Fill in Blanks'),
      (Icons.shuffle, 'Match Madness'),
    ];
    final tokens = context.themeTokens<AppTokens>();
    final selection = useSelectionController<int>(
      selectedValues: [selectedIndex],
      onSelectionChanged: (selected) {
        if (selected.isEmpty) return;
        onChanged(selected.first);
      },
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: tokens.spaceLayoutGapSm,
        children: [
          for (var index = 0; index < formats.length; index++) ...[
            Button(
              leading: Icon(formats[index].$1),
              selected: selection.isSelected(index),
              onPressed: () => selection.select(index),
              child: Text(formats[index].$2, style: TextStyle(fontSize: 14)),
            ),
          ],
        ],
      ),
    );
  }
}
