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
import 'package:boo_mondai/ui/study_session.card_stage/stages/word_scramble/word_scramble.barrel.dart';
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
    final chipGap = ScaleHelper.getScaledValue(
      tokens.spaceLayoutGapXsm,
      contentScale,
    );
    final selectedWords = wordScrambleController.selectedWords.value;
    final answered = selectedWords.isNotEmpty;
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
                              spacing: chipGap,
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
                                    spacing: chipGap,
                                    runSpacing: chipGap,
                                    children: [
                                      for (final entry in selectedWords.indexed)
                                        WordScrambleChip(
                                          value: entry.$2.text,
                                          correct: wordScrambleController
                                              .isCorrectWordAt(entry.$1),
                                          contentScale: contentScale,
                                        ),
                                    ],
                                  ),
                              ],
                            ),
                            Column(
                              spacing: chipGap,
                              children: [
                                Text(
                                  'Correct answer',
                                  style: eyebrowStyle,
                                  textAlign: TextAlign.center,
                                ),
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: chipGap,
                                  runSpacing: chipGap,
                                  children: [
                                    for (final word in correctWords)
                                      WordScrambleChip(
                                        value: word,
                                        correct: answered ? true : null,
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
                          spacing: chipGap,
                          runSpacing: chipGap,
                          children: [
                            WordInsertTarget(
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
                              WordScrambleChip(
                                value: entry.$2.text,
                                correct: effectiveIsRevealed
                                    ? wordScrambleController.isCorrectWordAt(
                                        entry.$1,
                                      )
                                    : null,
                                dragPayload: wordScrambleController.isLocked
                                    ? null
                                    : WordScrambleSelectedWordDragPayload(
                                        entry.$1,
                                      ),
                                contentScale: contentScale,
                                onPressed: wordScrambleController.isLocked
                                    ? null
                                    : () => wordScrambleController
                                          .removeSelectedWordAt(entry.$1),
                              ),
                              WordInsertTarget(
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
