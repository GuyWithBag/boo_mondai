import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        Button,
        CardVerticalAlignmentControl,
        EditDeckFormValidator,
        FormField,
        MatchingTypeEditorController,
        MatchMadnessTemplate,
        MatchPair,
        SectionEyebrow,
        SurfaceColor,
        TextColor,
        TextSize,
        TextWeight,
        surfaceStyle,
        textStyle;
import 'package:flutter/material.dart' hide FormField;
import 'package:flutter_hooks/flutter_hooks.dart' show useEffect, useMemoized;
import 'package:signals_hooks/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class MatchingTypeEditor extends SignalHookWidget {
  const MatchingTypeEditor({
    required this.template,
    required this.onChanged,
    super.key,
  });

  final MatchMadnessTemplate template;
  final ValueChanged<MatchMadnessTemplate> onChanged;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final editor = useMemoized(
      () => MatchingTypeEditorController(
        template: template,
        onChanged: onChanged,
      ),
      [template.id],
    );
    useEffect(() => editor.dispose, [editor]);
    final pairs = editor.pairs.value;

    return Column(
      spacing: tokens.spaceLayoutGapMd,
      children: [
        CardVerticalAlignmentControl(
          value: editor.verticallyCentered,
          onChanged: editor.updateVerticallyCentered,
        ),
        FormField(
          value: pairs,
          validator: EditDeckFormValidator.matchingPairs,
          builder: (_, _) => Surface(
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
                Button.dashed(
                  tokens: tokens,
                  leading: const Icon(Icons.add),
                  onPressed: editor.addPair,
                  child: const Text('Add Pair'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
