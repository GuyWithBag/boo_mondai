import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        Button,
        ButtonColor,
        ButtonVariant,
        CardTemplateFormState,
        MatchPair,
        SectionEyebrow,
        SurfaceColor,
        TextColor,
        TextSize,
        TextWeight,
        surfaceStyle,
        textStyle,
        useMatchingTypeEditor;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class MatchingTypeEditor extends HookWidget {
  const MatchingTypeEditor({required this.formState, super.key});

  final CardTemplateFormState formState;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final editor = useMatchingTypeEditor(formState);
    final pairs = editor.pairs;

    return Surface(
      style: surfaceStyle.resolve(tokens, const [SurfaceColor.baseline]),
      child: Column(
        spacing: tokens.spaceLayoutGapMd,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionEyebrow('Matching Pairs'.toUpperCase()),
          Row(
            children: [
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
            ],
          ),
          Column(
            spacing: tokens.spaceLayoutGapMd,
            children: [
              for (final entry in pairs.asMap().entries) ...[
                MatchPair(
                  term: entry.value.term,
                  match: entry.value.match,
                  canRemove: pairs.length > 2,
                  onTermChanged: (value) =>
                      editor.updatePairTerm(entry.key, value),
                  onMatchChanged: (value) =>
                      editor.updatePairMatch(entry.key, value),
                  onRemove: () => editor.removePair(entry.key),
                ),
              ],
            ],
          ),

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
