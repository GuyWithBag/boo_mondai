import 'package:boo_mondai/lib.barrel.dart'
    show
        FillInTheBlanksTemplate,
        FillInTheBlanksController,
        StudySessionCardStageController,
        AppTokens,
        textStyle,
        TextSize,
        TextWeight,
        TextColor,
        FillInTheBlankTextField,
        ScaleHelper,
        PhysicalCard,
        AlignedScrollView,
        usePhysicalCardController,
        PhysicalCardController;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:signals_hooks/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class FillInTheBlanksCard extends SignalHookWidget {
  const FillInTheBlanksCard({
    super.key,
    required this.template,
    this.cardStageController,
    this.isRevealed = false,
    this.maxWidth,
    this.contentScale = 1,
    this.controller,
  });

  final FillInTheBlanksTemplate template;
  final StudySessionCardStageController? cardStageController;
  final bool isRevealed;
  final double? maxWidth;
  final double contentScale;
  final PhysicalCardController? controller;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final fillInTheBlanksController = useMemoized(
      () => FillInTheBlanksController(
        template: template,
        cardStageController: cardStageController,
      ),
      [
        template.id,
        template.promptText,
        template.answerKeys,
        cardStageController,
      ],
    );
    useEffect(() => fillInTheBlanksController.dispose, [
      fillInTheBlanksController,
    ]);

    final eyebrowStyle = ScaleHelper.getTextStyleWithScaledFontSize(
      textStyle.resolve(tokens, const [
        TextSize.labelSmall,
        TextWeight.heavy,
        TextColor.muted,
      ]),
      contentScale,
    );
    final promptTextStyle = ScaleHelper.getTextStyleWithScaledFontSize(
      textStyle.resolve(tokens, const [TextSize.body, TextWeight.heavy]),
      contentScale,
    );
    final answerTextStyle = ScaleHelper.getTextStyleWithScaledFontSize(
      textStyle.resolve(tokens, const [
        TextSize.body,
        TextWeight.body,
        TextColor.baseline,
      ]),
      contentScale,
    );
    final padding = ScaleHelper.getScaledEdgeInsets(
      EdgeInsets.all(tokens.spaceLayoutPaddingSm),
      contentScale,
    );
    final effectiveIsRevealed =
        isRevealed || cardStageController?.isRevealed.value == true;
    final fallbackPhysicalCardController = usePhysicalCardController(
      context,
      width: maxWidth,
    );
    final physicalCardController = controller ?? fallbackPhysicalCardController;
    return PhysicalCard(
      controller: physicalCardController,
      padding: EdgeInsets.zero,
      front: AlignedScrollView(
        verticallyCentered: template.verticallyCentered,
        padding: padding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Fill in the blank'.toUpperCase(), style: eyebrowStyle),
            SizedBox(height: ScaleHelper.getScaledValue(48.h, contentScale)),
            Wrap(
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: ScaleHelper.getScaledValue(8.w, contentScale),
              runSpacing: ScaleHelper.getScaledValue(16.h, contentScale),
              children: [
                for (final entry
                    in fillInTheBlanksController.segments.value.indexed)
                  if (entry.$2.key case final key?)
                    FillInTheBlankTextField(
                      revealed: effectiveIsRevealed,
                      correct: fillInTheBlanksController.isCorrect(
                        fillInTheBlanksController.blankIndexForSegment(
                          entry.$1,
                        ),
                      ),
                      value:
                          fillInTheBlanksController
                              .answers
                              .value[fillInTheBlanksController
                              .blankIndexForSegment(entry.$1)],
                      correctAnswer: key.value,
                      onChanged: (value) =>
                          fillInTheBlanksController.updateAnswer(
                            fillInTheBlanksController.blankIndexForSegment(
                              entry.$1,
                            ),
                            value,
                          ),
                      contentScale: contentScale,
                      textStyle: answerTextStyle,
                    )
                  else
                    Text(entry.$2.text!, style: promptTextStyle),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
