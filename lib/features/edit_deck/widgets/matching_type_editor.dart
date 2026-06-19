import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        DeckCardFormState,
        useMatchingTypeEditor,
        surfaceStyle,
        SurfaceColor,
        textStyle,
        TextSize,
        TextWeight,
        TextColor,
        ButtonColor,
        ButtonVariant,
        Button;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

import 'matching_type_pair.dart';

class MatchingTypeEditor extends HookWidget {
  const MatchingTypeEditor({required this.formState, super.key});

  final DeckCardFormState formState;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final editor = useMatchingTypeEditor(formState);
    final pairs = editor.pairs;

    return Surface(
      style: surfaceStyle.resolve(tokens, const [SurfaceColor.baseline]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Matching Pairs'.toUpperCase(),
            style: textStyle.resolve(tokens, [
              TextSize.labelSmall,
              TextWeight.heavy,
              TextColor.muted,
            ]),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const SizedBox(width: 44),
              Expanded(
                child: Text(
                  'TERM',
                  style: textStyle.resolve(tokens, [
                    TextSize.labelSmall,
                    TextWeight.heavy,
                    TextColor.muted,
                  ]),
                ),
              ),
              const SizedBox(width: 56),
              Expanded(
                child: Text(
                  'MATCH',
                  style: textStyle.resolve(tokens, [
                    TextSize.labelSmall,
                    TextWeight.heavy,
                    TextColor.muted,
                  ]),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 12),
          for (final entry in pairs.asMap().entries) ...[
            MatchPair(
              term: entry.value.term,
              match: entry.value.match,
              canRemove: pairs.length > 2,
              onTermChanged: (value) => editor.updatePairTerm(entry.key, value),
              onMatchChanged: (value) =>
                  editor.updatePairMatch(entry.key, value),
              onRemove: () => editor.removePair(entry.key),
            ),
            const SizedBox(height: 14),
          ],
          const SizedBox(height: 28),
          Button(
            leading: const Icon(Icons.add),
            variants: const [ButtonVariant.dashed, ButtonColor.dashed],
            onPressed: editor.addPair,
            child: const Text('Add Pair'),
          ),
        ],
      ),
    );
  }
}
