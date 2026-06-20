import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        MatchingTypeInput,
        MarkdownText,
        MarkdownTextMode,
        TextFieldSize,
        TextFieldFrame,
        TextFieldTone;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

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
      spacing: tokens.spaceLayoutGapSm,
      children: [
        Expanded(
          child: MarkdownText(
            data: term,
            onChanged: onTermChanged,
            mode: MarkdownTextMode.input,
            variants: const [
              TextFieldSize.labelLarge,
              TextFieldFrame.outline,
              TextFieldTone.neutral,
            ],
          ),
        ),
        Icon(Icons.compare_arrows, color: tokens.colorTextMuted),
        Expanded(
          child: MarkdownText(
            data: match,
            onChanged: onMatchChanged,
            mode: MarkdownTextMode.input,
            variants: const [
              TextFieldSize.labelLarge,
              TextFieldFrame.outline,
              TextFieldTone.neutral,
            ],
          ),
        ),
        IconButton(
          onPressed: canRemove ? onRemove : null,
          icon: Icon(Icons.delete_rounded, color: tokens.colorTextMuted),
        ),
      ],
    );
  }
}
