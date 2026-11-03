import 'package:boo_mondai/lib.barrel.dart' show AppTokens, ThemeController;
import 'package:flutter/material.dart';

class SearchFilterFieldShell extends StatelessWidget {
  const SearchFilterFieldShell({
    required this.label,
    required this.child,
    super.key,
  });

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tokens = ThemeController.tokens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall,
        ),
        SizedBox(height: tokens.spaceLayoutGapSm),
        child,
      ],
    );
  }
}
