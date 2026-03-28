// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/deck_editor/fitb_preview.dart
// PURPOSE: Live preview of fill-in-the-blank sentence with blanks highlighted
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/shared/shared.dart';
import 'package:boo_mondai/pages/deck_editor/editor_types.dart';

class FitbPreview extends StatelessWidget {
  const FitbPreview({super.key, required this.sentence, required this.answersRaw});

  final String sentence;
  final String answersRaw;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final answers = splitFitbAnswers(answersRaw);
    final s = sentence.trim();
    final sl = s.toLowerCase();

    // Collect all (start, end) blank ranges, skipping answers not found
    final ranges = <(int, int)>[];
    for (final a in answers) {
      final idx = sl.indexOf(a.toLowerCase());
      if (idx >= 0) ranges.add((idx, idx + a.length));
    }
    // Sort by start position
    ranges.sort((a, b) => a.$1.compareTo(b.$1));

    if (ranges.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.incorrect.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppRadii.card),
          border: Border.all(color: AppColors.incorrect.withValues(alpha: 0.25)),
        ),
        child: Row(
          children: [
            const Icon(Icons.warning_amber_rounded,
                size: 16, color: AppColors.incorrect),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'No answers found in sentence',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.incorrect),
            ),
          ],
        ),
      );
    }

    // Build RichText spans, replacing each range with a blank
    final blankStyle = TextStyle(
      color: scheme.primary,
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.underline,
      decorationColor: scheme.primary,
      decorationThickness: 2,
    );
    final spans = <TextSpan>[];
    var cursor = 0;
    for (final (start, end) in ranges) {
      if (start > cursor) spans.add(TextSpan(text: s.substring(cursor, start)));
      final blankLen = (end - start).clamp(3, 12);
      spans.add(TextSpan(text: '\u{FF3F}' * blankLen, style: blankStyle));
      cursor = end;
    }
    if (cursor < s.length) spans.add(TextSpan(text: s.substring(cursor)));

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: scheme.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PREVIEW',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: scheme.primary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
          ),
          const SizedBox(height: AppSpacing.sm),
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6),
              children: spans,
            ),
          ),
        ],
      ),
    );
  }
}
