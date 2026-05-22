import 'package:boo_mondai/widgets/animated_widgets/animated_flip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

import 'package:boo_mondai/shared/theme/theme.barrel.dart';
import '../../variant_styles/variant_styles.barrel.dart';
import '../tactile_button.dart';
import 'blank_answer_input.dart';
import 'study_session.models.dart';

class StudySessionCardStage extends StatelessWidget {
  const StudySessionCardStage({
    required this.card,
    required this.revealed,
    required this.onReveal,
    required this.selectedOption,
    required this.onOptionSelected,
    required this.blankInput,
    required this.onBlankInputChanged,
    required this.selectedMatch,
    required this.matchedItems,
    required this.onSelectedMatchChanged,
    required this.onMatchedItemsChanged,
    super.key,
  });

  final StudySessionCard card;
  final bool revealed;
  final VoidCallback onReveal;
  final String? selectedOption;
  final ValueChanged<String> onOptionSelected;
  final String blankInput;
  final ValueChanged<String> onBlankInputChanged;
  final String? selectedMatch;
  final Set<String> matchedItems;
  final ValueChanged<String?> onSelectedMatchChanged;
  final ValueChanged<Set<String>> onMatchedItemsChanged;

  @override
  Widget build(BuildContext context) {
    final child = switch (card) {
      StudyFlashcard() => _FlashcardCard(
        card: card as StudyFlashcard,
        revealed: revealed,
        onReveal: onReveal,
      ),
      StudyMcqCard() => _MultipleChoiceCard(
        card: card as StudyMcqCard,
        revealed: revealed,
        selectedOption: selectedOption,
        onOptionSelected: onOptionSelected,
      ),
      StudyBlanksCard() => _BlanksCard(
        card: card as StudyBlanksCard,
        revealed: revealed,
        blankInput: blankInput,
        onBlankInputChanged: onBlankInputChanged,
      ),
      StudyMatchCard() => _MatchCard(
        card: card as StudyMatchCard,
        selectedMatch: selectedMatch,
        matchedItems: matchedItems,
        onSelectedMatchChanged: onSelectedMatchChanged,
        onMatchedItemsChanged: onMatchedItemsChanged,
        onComplete: onReveal,
      ),
    };

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20.w, 42.h, 20.w, 42.h),
      child: Center(child: child),
    );
  }
}

class _StudyCardFrame extends StatelessWidget {
  const _StudyCardFrame({
    required this.child,
    this.tone = SurfaceTone.surface,
    this.maxWidth = 480,
  });

  final Widget child;
  final SurfaceTone tone;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth.w),
      child: SizedBox(
        width: double.infinity,
        height: 540.h,
        child: Surface(
          style: surfaceStyle.resolve(tokens, [tone]),
          child: child,
        ),
      ),
    );
  }
}

class _FlashcardCard extends StatelessWidget {
  const _FlashcardCard({
    required this.card,
    required this.revealed,
    required this.onReveal,
  });

  final StudyFlashcard card;
  final bool revealed;
  final VoidCallback onReveal;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onReveal,
      child: AnimatedFlip(
        showBack: revealed,
        front: FlashcardFrontSide(card: card, onReveal: onReveal),
        back: FlashcardBackSide(card: card),
      ),
    );
  }
}

class FlashcardFrontSide extends StatelessWidget {
  const FlashcardFrontSide({
    required this.card,
    required this.onReveal,
    super.key,
  });

  final StudyFlashcard card;
  final VoidCallback onReveal;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return _StudyCardFrame(
      maxWidth: 460,
      child: SizedBox.expand(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Center(
              child: Text(
                card.front,
                textAlign: TextAlign.center,
                style: appTextStyle.resolve(tokens, [
                  TextSize.cardFront,
                  TextWeight.heavy,
                  TextTone.primary,
                ]),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: TactileButton(
                tone: TactileTone.text,
                leading: Icon(Icons.touch_app),
                onPressed: onReveal,
                child: const Text('Tap to reveal'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FlashcardBackSide extends StatelessWidget {
  const FlashcardBackSide({required this.card, super.key});

  final StudyFlashcard card;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return _StudyCardFrame(
      maxWidth: 460,
      tone: SurfaceTone.primaryOutline,
      child: Center(
        child: Column(
          key: const ValueKey('flashcard-back'),
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              card.front,
              textAlign: TextAlign.center,
              style: appTextStyle.resolve(tokens, [
                TextSize.cardBackFront,
                TextWeight.heavy,
                TextTone.primary,
              ]),
            ),
            SizedBox(height: 26.h),
            Container(
              width: 64.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: tokens.borderNeutralSubtle,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            SizedBox(height: 32.h),
            Text(
              card.back,
              textAlign: TextAlign.center,
              style: appTextStyle.resolve(tokens, [
                TextSize.cardBackContent,
                TextWeight.heavy,
                TextTone.brand,
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

class _MultipleChoiceCard extends StatelessWidget {
  const _MultipleChoiceCard({
    required this.card,
    required this.revealed,
    required this.selectedOption,
    required this.onOptionSelected,
  });

  final StudyMcqCard card;
  final bool revealed;
  final String? selectedOption;
  final ValueChanged<String> onOptionSelected;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return _StudyCardFrame(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(
                'Select Answer'.toUpperCase(),
                textAlign: TextAlign.center,
                style: appTextStyle.resolve(tokens, [
                  TextSize.labelSmall,
                  TextWeight.heavy,
                  TextTone.muted,
                ]),
              ),
              SizedBox(height: 28.h),
              Text(
                card.prompt,
                textAlign: TextAlign.center,
                style: appTextStyle.resolve(tokens, [
                  TextSize.header,
                  TextWeight.heavy,
                  TextTone.primary,
                ]),
              ),
            ],
          ),
          SizedBox(height: 32.h),
          Column(
            children: [
              for (final option in card.options) ...[
                SizedBox(
                  width: double.infinity,
                  child: TactileButton(
                    tone: _optionTone(option),
                    depth: TactileDepth.flat,
                    selected: !revealed && selectedOption == option,
                    mainAxisAlignment: MainAxisAlignment.start,
                    onPressed: revealed ? null : () => onOptionSelected(option),
                    child: Text(option),
                  ),
                ),
                if (option != card.options.last) SizedBox(height: 14.h),
              ],
            ],
          ),
        ],
      ),
    );
  }

  TactileTone _optionTone(String option) {
    final isSelected = selectedOption == option;
    final isCorrect = card.correctOption == option;
    if (revealed && isCorrect) return TactileTone.success;
    if (revealed && isSelected) return TactileTone.error;
    return TactileTone.ghost;
  }
}

class _BlanksCard extends StatelessWidget {
  const _BlanksCard({
    required this.card,
    required this.revealed,
    required this.blankInput,
    required this.onBlankInputChanged,
  });

  final StudyBlanksCard card;
  final bool revealed;
  final String blankInput;
  final ValueChanged<String> onBlankInputChanged;

  bool get _isCorrect =>
      blankInput.trim().toLowerCase() == card.blankAnswer.toLowerCase();

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return _StudyCardFrame(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Fill in the blank'.toUpperCase(),
            textAlign: TextAlign.center,
            style: appTextStyle.resolve(tokens, [
              TextSize.labelSmall,
              TextWeight.heavy,
              TextTone.muted,
            ]),
          ),
          SizedBox(height: 48.h),
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12.w,
            runSpacing: 16.h,
            children: [
              _SentenceText(card.prefix),
              BlankAnswerInput(
                revealed: revealed,
                correct: _isCorrect,
                correctAnswer: card.blankAnswer,
                onChanged: onBlankInputChanged,
              ),
              _SentenceText(card.suffix),
            ],
          ),
        ],
      ),
    );
  }
}

class _SentenceText extends StatelessWidget {
  const _SentenceText(this.value);

  final String value;

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: appTextStyle.resolve(context.themeTokens<AppTokens>(), [
        TextSize.bodyLarge,
        TextWeight.heavy,
        TextTone.primary,
      ]),
    );
  }
}

class _MatchCard extends StatelessWidget {
  const _MatchCard({
    required this.card,
    required this.selectedMatch,
    required this.matchedItems,
    required this.onSelectedMatchChanged,
    required this.onMatchedItemsChanged,
    required this.onComplete,
  });

  final StudyMatchCard card;
  final String? selectedMatch;
  final Set<String> matchedItems;
  final ValueChanged<String?> onSelectedMatchChanged;
  final ValueChanged<Set<String>> onMatchedItemsChanged;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final terms = card.pairs.map((pair) => pair.term).toList();
    final matches = card.pairs.map((pair) => pair.match).toList();

    return _StudyCardFrame(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Match the pairs'.toUpperCase(),
            textAlign: TextAlign.center,
            style: appTextStyle.resolve(tokens, [
              TextSize.labelSmall,
              TextWeight.heavy,
              TextTone.muted,
            ]),
          ),
          SizedBox(height: 40.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _MatchColumn(
                  items: terms,
                  selectedMatch: selectedMatch,
                  matchedItems: matchedItems,
                  onItemPressed: _handleMatchTap,
                ),
              ),
              SizedBox(width: 18.w),
              Expanded(
                child: _MatchColumn(
                  items: matches,
                  selectedMatch: selectedMatch,
                  matchedItems: matchedItems,
                  onItemPressed: _handleMatchTap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleMatchTap(String item) {
    final selected = selectedMatch;
    if (selected == null) {
      onSelectedMatchChanged(item);
      return;
    }

    final isPair = card.pairs.any(
      (pair) =>
          (pair.term == selected && pair.match == item) ||
          (pair.match == selected && pair.term == item),
    );

    if (isPair) {
      final nextMatched = {...matchedItems, selected, item};
      onMatchedItemsChanged(nextMatched);
      if (nextMatched.length == card.pairs.length * 2) {
        onComplete();
      }
    }

    onSelectedMatchChanged(null);
  }
}

class _MatchColumn extends StatelessWidget {
  const _MatchColumn({
    required this.items,
    required this.selectedMatch,
    required this.matchedItems,
    required this.onItemPressed,
  });

  final List<String> items;
  final String? selectedMatch;
  final Set<String> matchedItems;
  final ValueChanged<String> onItemPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final item in items) ...[
          _MatchButton(
            value: item,
            selected: selectedMatch == item,
            matched: matchedItems.contains(item),
            onPressed: () => onItemPressed(item),
          ),
          if (item != items.last) SizedBox(height: 14.h),
        ],
      ],
    );
  }
}

class _MatchButton extends StatelessWidget {
  const _MatchButton({
    required this.value,
    required this.selected,
    required this.matched,
    required this.onPressed,
  });

  final String value;
  final bool selected;
  final bool matched;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: matched,
      child: Opacity(
        opacity: matched ? 0 : 1,
        child: SizedBox(
          width: double.infinity,
          child: TactileButton(
            selected: selected,
            mainAxisAlignment: MainAxisAlignment.center,
            onPressed: onPressed,
            child: Text(value, textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }
}
