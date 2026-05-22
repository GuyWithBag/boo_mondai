import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

import 'package:boo_mondai/shared/theme/theme.barrel.dart';
import 'matching_type_input.dart';

class MatchPair extends StatelessWidget {
  const MatchPair({
    required this.term,
    required this.match,
    required this.onTermChanged,
    required this.onMatchChanged,
    required this.onRemove,
    this.canRemove = true,
    super.key,
  });

  final String term;
  final String match;
  final ValueChanged<String> onTermChanged;
  final ValueChanged<String> onMatchChanged;
  final VoidCallback onRemove;
  final bool canRemove;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return Row(
      children: [
        Icon(Icons.drag_indicator, color: tokens.textMuted),
        const SizedBox(width: 12),
        Expanded(
          child: MatchingTypeInput(value: term, onChanged: onTermChanged),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Icon(Icons.compare_arrows, color: tokens.textMuted),
        ),
        Expanded(
          child: MatchingTypeInput(value: match, onChanged: onMatchChanged),
        ),
        IconButton(
          onPressed: canRemove ? onRemove : null,
          icon: Icon(Icons.delete, color: tokens.textMuted),
        ),
      ],
    );
  }
}
