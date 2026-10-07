import 'package:boo_mondai/lib.barrel.dart'
    show
        AlignedScrollView,
        AppTokens,
        PhysicalCard,
        PhysicalCardController,
        ScaleHelper,
        StudySessionCardStageController,
        TextColor,
        TextSize,
        TextWeight,
        WordScrambleTemplate,
        textStyle,
        usePhysicalCardController;
import 'package:boo_mondai/ui/study_session.card_stage/widgets/word_scramble.chip.dart';
import 'package:boo_mondai/ui/study_session.card_stage/widgets/word_scramble.controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:signals_hooks/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class WordScrambleCard extends SignalHookWidget {
  const WordScrambleCard({
    super.key,
    required this.template,
    this.cardStageController,
    this.isRevealed = false,
    this.maxWidth,
    this.contentScale = 1,
    this.controller,
  });

  final WordScrambleTemplate template;
  final StudySessionCardStageController? cardStageController;
  final bool isRevealed;
  final double? maxWidth;
  final double contentScale;
  final PhysicalCardController? controller;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final fallbackCardStageController = useMemoized(
      () => StudySessionCardStageController(
        template: template,
        canReveal: true,
        createCardController: (stage) => WordScrambleController(
          template: template,
          answer: stage.answer,
          canReveal: stage.canReveal,
          isRevealed: stage.isRevealed,
        ),
      ),
      [template.id],
    );
    final effectiveCardStageController =
        cardStageController ?? fallbackCardStageController;
    final wordScrambleController =
        effectiveCardStageController.cardController! as WordScrambleController;
    final effectiveIsRevealed =
        isRevealed || effectiveCardStageController.isRevealed.value == true;
    final fallbackPhysicalCardController = usePhysicalCardController(
      context,
      width: maxWidth,
    );
    final physicalCardController = controller ?? fallbackPhysicalCardController;
    final eyebrowStyle = ScaleHelper.getTextStyleWithScaledFontSize(
      textStyle.resolve(tokens, const [
        TextSize.labelSmall,
        TextWeight.heavy,
        TextColor.muted,
      ]),
      contentScale,
    );
    final placeholderStyle = ScaleHelper.getTextStyleWithScaledFontSize(
      textStyle.resolve(tokens, const [
        TextSize.label,
        TextWeight.body,
        TextColor.muted,
      ]),
      contentScale,
    );
    final padding = ScaleHelper.getScaledEdgeInsets(
      EdgeInsets.all(tokens.spaceLayoutPaddingSm),
      contentScale,
    );
    final gap = ScaleHelper.getScaledValue(
      tokens.spaceLayoutGapMd,
      contentScale,
    );
    final sectionGap = ScaleHelper.getScaledValue(
      tokens.spaceLayoutGapXsm,
      contentScale,
    );
    final selectedWords = wordScrambleController.selectedWords.value;
    final correctWords = template.sentenceToScramble
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty);

    useEffect(() {
      fallbackCardStageController.isRevealed.value = isRevealed;
      return null;
    }, [fallbackCardStageController, isRevealed]);

    useEffect(() => fallbackCardStageController.dispose, [
      fallbackCardStageController,
    ]);

    return PhysicalCard(
      controller: physicalCardController,
      padding: EdgeInsets.zero,
      front: AlignedScrollView(
        verticallyCentered: template.verticallyCentered,
        padding: padding,
        child: Column(
          spacing: gap,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Unscramble the sentence'.toUpperCase(),
              textAlign: TextAlign.center,
              style: eyebrowStyle,
            ),
            DragTarget<WordScrambleDragPayload>(
              onWillAcceptWithDetails: (_) => !wordScrambleController.isLocked,
              onAcceptWithDetails: (details) => _acceptDropAt(
                wordScrambleController,
                details.data,
                selectedWords.length,
              ),
              builder: (context, candidateData, rejectedData) {
                // final isHovering = candidateData.isNotEmpty;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  width: double.infinity,
                  constraints: BoxConstraints(
                    minHeight: ScaleHelper.getScaledValue(140.h, contentScale),
                  ),
                  padding: ScaleHelper.getScaledEdgeInsets(
                    EdgeInsets.all(tokens.spaceLayoutPaddingSm),
                    contentScale,
                  ),

                  child: effectiveIsRevealed
                      ? Column(
                          spacing: gap,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Column(
                              spacing: sectionGap,
                              children: [
                                if (selectedWords.isNotEmpty)
                                  Text(
                                    'Your answer',
                                    style: eyebrowStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                if (selectedWords.isNotEmpty)
                                  Wrap(
                                    alignment: WrapAlignment.center,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    spacing: sectionGap,
                                    runSpacing: sectionGap,
                                    children: [
                                      for (final entry in selectedWords.indexed)
                                        WordScrambleChip(
                                          value: entry.$2.text,
                                          selected: true,
                                          correct: wordScrambleController
                                              .isCorrectWordAt(entry.$1),
                                          contentScale: contentScale,
                                        ),
                                    ],
                                  ),
                              ],
                            ),
                            Column(
                              spacing: sectionGap,
                              children: [
                                Text(
                                  'Correct answer',
                                  style: eyebrowStyle,
                                  textAlign: TextAlign.center,
                                ),
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: sectionGap,
                                  runSpacing: sectionGap,
                                  children: [
                                    for (final word in correctWords)
                                      WordScrambleChip(
                                        value: word,
                                        selected: true,
                                        correct: true,
                                        contentScale: contentScale,
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        )
                      : selectedWords.isEmpty
                      ? Center(
                          child: Text(
                            'Tap or drag words here',
                            style: placeholderStyle,
                            textAlign: TextAlign.center,
                          ),
                        )
                      : Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: ScaleHelper.getScaledValue(
                            tokens.spaceLayoutGapSm,
                            contentScale,
                          ),
                          runSpacing: ScaleHelper.getScaledValue(
                            tokens.spaceLayoutGapSm,
                            contentScale,
                          ),
                          children: [
                            _WordInsertionTarget(
                              index: 0,
                              locked: wordScrambleController.isLocked,
                              contentScale: contentScale,
                              onAccept: (payload) => _acceptDropAt(
                                wordScrambleController,
                                payload,
                                0,
                              ),
                            ),
                            for (final entry in selectedWords.indexed) ...[
                              _SelectedWordChip(
                                index: entry.$1,
                                value: entry.$2.text,
                                correct: effectiveIsRevealed
                                    ? wordScrambleController.isCorrectWordAt(
                                        entry.$1,
                                      )
                                    : null,
                                locked: wordScrambleController.isLocked,
                                contentScale: contentScale,
                                onDeleted: () => wordScrambleController
                                    .removeSelectedWordAt(entry.$1),
                              ),
                              _WordInsertionTarget(
                                index: entry.$1 + 1,
                                locked: wordScrambleController.isLocked,
                                contentScale: contentScale,
                                onAccept: (payload) => _acceptDropAt(
                                  wordScrambleController,
                                  payload,
                                  entry.$1 + 1,
                                ),
                              ),
                            ],
                          ],
                        ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _acceptDropAt(
    WordScrambleController controller,
    WordScrambleDragPayload payload,
    int index,
  ) {
    switch (payload) {
      case WordScrambleBankWordDragPayload(:final word):
        controller.insertWordAt(word, index);
      case WordScrambleSelectedWordDragPayload(index: final from):
        controller.moveSelectedWord(from, index);
    }
  }
}

class _SelectedWordChip extends StatelessWidget {
  const _SelectedWordChip({
    required this.index,
    required this.value,
    required this.locked,
    required this.contentScale,
    required this.onDeleted,
    this.correct,
  });

  final int index;
  final String value;
  final bool locked;
  final double contentScale;
  final bool? correct;
  final VoidCallback onDeleted;

  @override
  Widget build(BuildContext context) {
    final chip = WordScrambleChip(
      value: value,
      selected: true,
      correct: correct,
      contentScale: contentScale,
      onDeleted: locked ? null : onDeleted,
    );

    if (locked) return chip;

    return LongPressDraggable<WordScrambleDragPayload>(
      data: WordScrambleSelectedWordDragPayload(index),
      feedback: Material(color: Colors.transparent, child: chip),
      childWhenDragging: Opacity(opacity: 0.35, child: chip),
      child: chip,
    );
  }
}

class _WordInsertionTarget extends StatelessWidget {
  const _WordInsertionTarget({
    required this.index,
    required this.locked,
    required this.contentScale,
    required this.onAccept,
  });

  final int index;
  final bool locked;
  final double contentScale;
  final ValueChanged<WordScrambleDragPayload> onAccept;

  @override
  Widget build(BuildContext context) {
    return DragTarget<WordScrambleDragPayload>(
      onWillAcceptWithDetails: (_) => !locked,
      onAcceptWithDetails: (details) => onAccept(details.data),
      builder: (context, candidateData, rejectedData) {
        final active = candidateData.isNotEmpty;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: ScaleHelper.getScaledValue(active ? 28.w : 10.w, contentScale),
          height: ScaleHelper.getScaledValue(42.h, contentScale),
          decoration: BoxDecoration(
            color: active
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.18)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
            border: active
                ? Border.all(color: Theme.of(context).colorScheme.primary)
                : null,
          ),
        );
      },
    );
  }
}
