// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/quiz_session/match_madness_interaction.dart
// PURPOSE: Match madness interaction where users pair terms with matches
// PROVIDERS: QuizSessionPageController
// HOOKS: useState, useEffect
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:boo_mondai/controllers/controllers.barrel.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';

class MatchMadnessInteraction extends HookWidget {
  const MatchMadnessInteraction({
    super.key,
    required this.template, // <-- NEW: Specific template
    required this.controller,
  });

  final MatchMadnessTemplate template;
  final SessionController controller;

  @override
  Widget build(BuildContext context) {
    final pairs = template.pairs;
    final selectedTerm = useState<String?>(null);
    final matched = useState<Set<String>>({});

    // Reset the game state if the template changes
    useEffect(() {
      selectedTerm.value = null;
      matched.value = {};
      return null;
    }, [template.id]);

    void onTermTap(String pairId) {
      if (matched.value.contains(pairId)) return;
      selectedTerm.value = pairId;
    }

    void onMatchTap(String pairId) {
      if (matched.value.contains(pairId)) return;

      if (selectedTerm.value == pairId) {
        // Correct match
        matched.value = {...matched.value, pairId};
        selectedTerm.value = null;

        // If all pairs are matched, auto-submit as a correct answer!
        if (matched.value.length == pairs.length) {
          controller.submitAnswer('Matched all pairs', QuizAnswerType.good);
        }
      } else {
        // Incorrect match, just deselect
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
