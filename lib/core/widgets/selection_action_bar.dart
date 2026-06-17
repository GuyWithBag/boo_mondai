import 'package:boo_mondai/features/features.barrel.dart';
import 'package:boo_mondai/lib.barrel.dart' show AppSpacing, Button, AppTokens;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart'
    show Surface, ThemeVariantsContext;

class SelectionActionBar extends StatelessWidget {
  const SelectionActionBar({
    super.key,
    required this.count,
    required this.onClear,
    this.actions = const [],
  });

  final int count;
  final VoidCallback onClear;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    return Surface(
      style: surfaceStyle.resolve(tokens),
      child: Row(
        children: [
          Icon(Icons.select_all_rounded),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text('$count selected')),
          ...actions,
          const SizedBox(width: AppSpacing.sm),
          Button.icon(icon: Icons.close_rounded, onPressed: onClear),
        ],
      ),
    );
  }
}
