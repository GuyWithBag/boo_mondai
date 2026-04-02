// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/deck_editor/match_row.dart
// PURPOSE: Single term-match pair row with inline text editing
// PROVIDERS: none
// HOOKS: useTextEditingController, useEffect
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';
import 'package:boo_mondai/models/models.barrel.dart';

/// A single row representing a term-match pair within the [MatchEditor].
class MatchRow extends HookWidget {
  const MatchRow({
    super.key,
    required this.index,
    required this.pair,
    required this.canRemove,
    required this.onRemove,
    required this.onChanged,
  });

  /// The position of this pair in the list (1-indexed for display).
  final int index;

  /// The raw data for this pair.
  final MatchPairData pair;

  /// Whether this pair can be removed from the list (usually requires at least 2 pairs).
  final bool canRemove;

  /// Callback to remove this pair.
  final VoidCallback onRemove;

  /// Callback when the term or match text changes.
  final void Function(MatchPairData updatedPair) onChanged;

  @override
  Widget build(BuildContext context) {
    final termController = useTextEditingController(text: pair.term);
    final matchController = useTextEditingController(text: pair.match);

    // Sync controllers if the pair data changes externally (e.g., when switching cards).
    useEffect(() {
      if (termController.text != pair.term) {
        termController.text = pair.term;
        termController.selection = TextSelection.collapsed(
          offset: pair.term.length,
        );
      }
      if (matchController.text != pair.match) {
        matchController.text = pair.match;
        matchController.selection = TextSelection.collapsed(
          offset: pair.match.length,
        );
      }
      return null;
    }, [pair.term, pair.match]);

    final themeColorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm + 2,
      ),
      decoration: BoxDecoration(
        color: themeColorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: themeColorScheme.surfaceContainerHighest),
      ),
      child: Row(
        children: [
          // Row number indicator.
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: themeColorScheme.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Text(
              '${index + 1}',
              style: TextStyle(
                color: themeColorScheme.primary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),

          // Term input field.
          Expanded(
            child: Theme(
              data: Theme.of(context).copyWith(
                inputDecorationTheme: const InputDecorationTheme(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
              ),
              child: TextField(
                controller: termController,
                decoration: const InputDecoration(hintText: 'Term'),
                onChanged: (value) =>
                    onChanged((term: value, match: pair.match)),
              ),
            ),
          ),

          const SizedBox(width: AppSpacing.sm),
          Icon(
            Icons.compare_arrows,
            color: themeColorScheme.primary.withValues(alpha: 0.5),
            size: 22,
          ),
          const SizedBox(width: AppSpacing.sm),

          // Match input field.
          Expanded(
            child: Theme(
              data: Theme.of(context).copyWith(
                inputDecorationTheme: const InputDecorationTheme(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
              ),
              child: TextField(
                controller: matchController,
                decoration: const InputDecoration(hintText: 'Match'),
                onChanged: (value) =>
                    onChanged((term: pair.term, match: value)),
              ),
            ),
          ),

          const SizedBox(width: AppSpacing.xs),
          if (canRemove)
            IconButton(
              icon: const Icon(Icons.close, size: 18),
              onPressed: onRemove,
              tooltip: 'Remove pair',
              color: AppColors.textSecondary,
              visualDensity: VisualDensity.compact,
            )
          else
            const SizedBox(width: 40),
        ],
      ),
    );
  }
}
