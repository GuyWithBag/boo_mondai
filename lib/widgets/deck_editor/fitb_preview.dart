// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/deck_editor/fitb_preview.dart
// PURPOSE: Live preview of fill-in-the-blank sentence with blanks highlighted
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/models/models.barrel.dart';

/// Shows a live preview of how a "Fill in the Blank" sentence will look to the user.
class FitbPreview extends StatelessWidget {
  const FitbPreview({
    super.key,
    required this.sentence,
    required this.answersRaw,
  });

  /// The full sentence containing the words to be blanked.
  final String sentence;

  /// The raw comma-separated list of answers that should be blanked.
  final String answersRaw;

  @override
  Widget build(BuildContext context) {
    final themeColorScheme = Theme.of(context).colorScheme;
    final answers = splitFillInTheBlankAnswers(answersRaw);
    final trimmedSentence = sentence.trim();
    final lowerSentence = trimmedSentence.toLowerCase();

    // Identify the start and end indices of each answer within the sentence.
    final blankRanges = <(int, int)>[];
    for (final answer in answers) {
      final startIndex = lowerSentence.indexOf(answer.toLowerCase());
      if (startIndex >= 0) {
        blankRanges.add((startIndex, startIndex + answer.length));
      }
    }

    // Sort ranges by their starting position to ensure we process the sentence linearly.
    blankRanges.sort((a, b) => a.$1.compareTo(b.$1));

    // Handle the case where no answers are found in the sentence.
    if (blankRanges.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.incorrect.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppRadii.card),
          border: Border.all(
            color: AppColors.incorrect.withValues(alpha: 0.25),
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              size: 16,
              color: AppColors.incorrect,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'No answers found in sentence',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.incorrect),
            ),
          ],
        ),
      );
    }

    // Build the RichText content by replacing the answer ranges with underscores.
    final blankTextStyle = TextStyle(
      color: themeColorScheme.primary,
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.underline,
      decorationColor: themeColorScheme.primary,
      decorationThickness: 2,
    );

    final textSpans = <TextSpan>[];
    var cursorPosition = 0;

    for (final (rangeStart, rangeEnd) in blankRanges) {
      // Add the plain text before the blank.
      if (rangeStart > cursorPosition) {
        textSpans.add(
          TextSpan(text: trimmedSentence.substring(cursorPosition, rangeStart)),
        );
      }

      // Add the blank (underscores).
      final blankLength = (rangeEnd - rangeStart).clamp(3, 12);
      textSpans.add(
        TextSpan(text: '\u{FF3F}' * blankLength, style: blankTextStyle),
      );

      cursorPosition = rangeEnd;
    }

    // Add any remaining text after the last blank.
    if (cursorPosition < trimmedSentence.length) {
      textSpans.add(TextSpan(text: trimmedSentence.substring(cursorPosition)));
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: themeColorScheme.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(
          color: themeColorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PREVIEW',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: themeColorScheme.primary,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          RichText(
            text: TextSpan(
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(height: 1.6),
              children: textSpans,
            ),
          ),
        ],
      ),
    );
  }
}
