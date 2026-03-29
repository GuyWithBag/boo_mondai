// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/deck_editor/match_row.dart
// PURPOSE: Single term-match pair row with inline text editing
// PROVIDERS: none
// HOOKS: useTextEditingController, useEffect
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';

class MatchRow extends HookWidget {
  const MatchRow({
    super.key,
    required this.index,
    required this.pair,
    required this.canRemove,
    required this.onRemove,
    required this.onChanged,
  });

  final int index;
  final Pair pair;
  final bool canRemove;
  final VoidCallback onRemove;
  final void Function(Pair) onChanged;

  @override
  Widget build(BuildContext context) {
    final termCtrl = useTextEditingController(text: pair.term);
    final matchCtrl = useTextEditingController(text: pair.match);
    useEffect(() {
      if (termCtrl.text != pair.term) {
        termCtrl.text = pair.term;
        termCtrl.selection = TextSelection.collapsed(offset: pair.term.length);
      }
      if (matchCtrl.text != pair.match) {
        matchCtrl.text = pair.match;
        matchCtrl.selection = TextSelection.collapsed(
          offset: pair.match.length,
        );
      }
      return null;
    }, [pair.term, pair.match]);

    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm + 2,
      ),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: scheme.surfaceContainerHighest),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Text(
              '${index + 1}',
              style: TextStyle(
                color: scheme.primary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
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
                controller: termCtrl,
                decoration: const InputDecoration(hintText: 'Term'),
                onChanged: (v) => onChanged((term: v, match: pair.match)),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Icon(
            Icons.compare_arrows,
            color: scheme.primary.withValues(alpha: 0.5),
            size: 22,
          ),
          const SizedBox(width: AppSpacing.sm),
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
                controller: matchCtrl,
                decoration: const InputDecoration(hintText: 'Match'),
                onChanged: (v) => onChanged((term: pair.term, match: v)),
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
