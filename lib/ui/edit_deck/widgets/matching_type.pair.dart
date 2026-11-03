import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        MarkdownText,
        MarkdownTextMode,
        TextFieldSize,
        TextFieldFrame,
        ThemeController;
import 'package:flutter/material.dart';

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
    final tokens = ThemeController.tokens;

    return Row(
      spacing: tokens.spaceLayoutGapSm,
      children: [
        Expanded(
          child: MarkdownText(
            allowAttachments: true,
            data: term,
            onChanged: onTermChanged,
            mode: MarkdownTextMode.input,
            variants: const [TextFieldSize.labelLarge, TextFieldFrame.outline],
          ),
        ),
        Icon(Icons.compare_arrows, color: tokens.colorTextMuted),
        Expanded(
          child: MarkdownText(
            allowAttachments: true,
            data: match,
            onChanged: onMatchChanged,
            mode: MarkdownTextMode.input,
            variants: const [TextFieldSize.labelLarge, TextFieldFrame.outline],
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
