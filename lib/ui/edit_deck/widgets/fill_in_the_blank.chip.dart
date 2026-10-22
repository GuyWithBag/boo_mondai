import 'package:boo_mondai/lib.barrel.dart'
    show InlineSpanEntry, AppTokens, chipStyle, ChipTone;
import 'package:flutter/material.dart'
    show
        BuildContext,
        VoidCallback,
        StatelessWidget,
        Widget,
        Icon,
        Text,
        Icons,
        InputChip,
        ChipTheme;
import 'package:theme_variants/theme_variants.dart' show ThemeVariantsContext;

class BlankChip extends StatelessWidget {
  const BlankChip({super.key, required this.entry, required this.onDelete});

  final InlineSpanEntry entry;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final theme = chipStyle.resolve(tokens, [ChipTone.ghost]);
    return ChipTheme(
      data: theme,
      child: InputChip(
        label: Text(entry.text),
        // The X icon: tapping removes the blank and restores the word.
        onDeleted: onDelete,
        deleteIcon: const Icon(Icons.close, size: 16),
      ),
    );
  }
}
