import 'package:boo_mondai/lib.barrel.dart' show AppTokens;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

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
    final tokens = context.themeTokens<AppTokens>();
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
