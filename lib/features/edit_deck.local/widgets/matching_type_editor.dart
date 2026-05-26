import 'package:boo_mondai/lib.barrel.dart'
    show
        MatchPairData,
        AppTokens,
        surfaceStyle,
        SurfaceTone,
        appTextStyle,
        TextSize,
        TextWeight,
        TextTone,
        ButtonTone,
        Button;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

import 'matching_type_pair.dart';

class MatchingTypeEditor extends StatelessWidget {
  const MatchingTypeEditor({
    required this.pairs,
    required this.onPairAdd,
    required this.onPairRemove,
    required this.onPairUpdate,
    super.key,
  });

  final List<MatchPairData> pairs;
  final VoidCallback onPairAdd;
  final ValueChanged<int> onPairRemove;
  final void Function(int index, MatchPairData pair) onPairUpdate;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return Surface(
      style: surfaceStyle.resolve(tokens, const [SurfaceTone.surface]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Matching Pairs'.toUpperCase(),
            style: appTextStyle.resolve(tokens, [
              TextSize.labelSmall,
              TextWeight.heavy,
              TextTone.muted,
            ]),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const SizedBox(width: 44),
              Expanded(
                child: Text(
                  'TERM',
                  style: appTextStyle.resolve(tokens, [
                    TextSize.labelSmall,
                    TextWeight.heavy,
                    TextTone.muted,
                  ]),
                ),
              ),
              const SizedBox(width: 56),
              Expanded(
                child: Text(
                  'MATCH',
                  style: appTextStyle.resolve(tokens, [
                    TextSize.labelSmall,
                    TextWeight.heavy,
                    TextTone.muted,
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
              onTermChanged: (value) => onPairUpdate(
                entry.key,
                MatchPairData(term: value, match: entry.value.match),
              ),
              onMatchChanged: (value) => onPairUpdate(
                entry.key,
                MatchPairData(term: entry.value.term, match: value),
              ),
              onRemove: () => onPairRemove(entry.key),
            ),
            const SizedBox(height: 14),
          ],
          const SizedBox(height: 28),
          Button(
            leading: const Icon(Icons.add),
            tone: ButtonTone.dashed,
            onPressed: onPairAdd,
            child: const Text('Add Pair'),
          ),
        ],
      ),
    );
  }
}
