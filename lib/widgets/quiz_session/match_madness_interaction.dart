// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/quiz_session/match_madness_interaction.dart
// PURPOSE: Match madness interaction where users pair terms with matches
// PROVIDERS: QuizProvider
// HOOKS: useState
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/providers/providers.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';

class MatchMadnessInteraction extends HookWidget {
  const MatchMadnessInteraction({
    super.key,
    required this.card,
    required this.quiz,
  });
  final DeckCard card;
  final QuizProvider quiz;

  @override
  Widget build(BuildContext context) {
    final pairs = card.pairs;
    final selectedTerm = useState<String?>(null);
    final matched = useState<Set<String>>({});

    void onTermTap(String pairId) {
      if (matched.value.contains(pairId)) return;
      selectedTerm.value = pairId;
    }

    void onMatchTap(String pairId) {
      if (matched.value.contains(pairId)) return;
      if (selectedTerm.value == pairId) {
        matched.value = {...matched.value, pairId};
        selectedTerm.value = null;
        if (matched.value.length == pairs.length) {
          context.read<QuizProvider>().revealAnswer();
        }
      } else {
        selectedTerm.value = null;
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Match all pairs',
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.sm),
        ...pairs.map((pair) {
          final isMatched = matched.value.contains(pair.id);
          final isSelected = selectedTerm.value == pair.id;
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Row(
              children: [
                Expanded(
                  child: MatchTile(
                    label: pair.term,
                    isMatched: isMatched,
                    isSelected: isSelected,
                    onTap: () => onTermTap(pair.id),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Icon(
                  isMatched ? Icons.link : Icons.link_off,
                  color: isMatched
                      ? AppColors.correct
                      : AppColors.textSecondary.withValues(alpha: 0.3),
                  size: 18,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: MatchTile(
                    label: pair.match,
                    isMatched: isMatched,
                    isSelected: isSelected,
                    onTap: () => onMatchTap(pair.id),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
