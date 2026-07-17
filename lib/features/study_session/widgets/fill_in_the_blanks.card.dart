import 'package:boo_mondai/lib.barrel.dart'
    show
        FillInTheBlanksTemplate,
        StudySessionCardStageController,
        AppTokens,
        textStyle,
        TextSize,
        TextWeight,
        TextColor,
        FillInTheBlankAnswerInput,
        MarkdownText,
        MarkdownTextMode,
        ScaleHelper,
        PhysicalCard,
        AlignedScrollView,
        usePhysicalCardController,
        PhysicalCardController;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

class FillInTheBlanksCard extends HookWidget {
  const FillInTheBlanksCard({
    super.key,
    required this.template,
    this.interactionsController,
    this.isRevealed = false,
    this.maxWidth,
    this.contentScale = 1,
    this.controller,
  });

  final FillInTheBlanksTemplate template;
  final StudySessionCardStageController? interactionsController;
  final bool isRevealed;
  final double? maxWidth;
  final double contentScale;
  final PhysicalCardController? controller;

  bool _isCorrect(int index, List<String> blankInputs) {
    final answer = index < blankInputs.length ? blankInputs[index] : '';
    return template.segments[index].checkAnswer(answer);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final eyebrowStyle = ScaleHelper.getTextStyleWithScaledFontSize(
      textStyle.resolve(tokens, const [
        TextSize.labelSmall,
        TextWeight.heavy,
        TextColor.muted,
      ]),
      contentScale,
    );
    final blankTextStyle = ScaleHelper.getTextStyleWithScaledFontSize(
      textStyle.resolve(tokens, const [TextSize.bodyLarge, TextWeight.heavy]),
      contentScale,
    );
    final markdownTextStyle = ScaleHelper.getTextStyleWithScaledFontSize(
      textStyle.resolve(tokens, const [
        TextSize.label,
        TextWeight.body,
        TextColor.baseline,
      ]),
      contentScale,
    );
    final padding = ScaleHelper.getScaledEdgeInsets(
      EdgeInsets.all(tokens.spaceLayoutPaddingSm),
      contentScale,
    );
    final promptGap = ScaleHelper.getScaledValue(48.h, contentScale);
    final segmentSpacing = ScaleHelper.getScaledValue(12.w, contentScale);
    final segmentRunSpacing = ScaleHelper.getScaledValue(16.h, contentScale);
    final blankInputs = useState<List<String>>(
      List.filled(template.segments.length, ''),
    );
    final effectiveIsRevealed =
        isRevealed || interactionsController?.isRevealed == true;
    final fallbackPhysicalCardController = usePhysicalCardController(
      context,
      width: maxWidth,
    );
    final physicalCardController = controller ?? fallbackPhysicalCardController;

    useEffect(() {
      blankInputs.value = List.filled(template.segments.length, '');
      return null;
    }, [template.id, interactionsController]);

    void updateBlankInput(int index, String value) {
      final inputs = [...blankInputs.value];
      if (index >= inputs.length) return;
      inputs[index] = value;
      blankInputs.value = inputs;

      interactionsController?.setAnswer(inputs.join('|'));
      interactionsController?.setCanReveal(
        template.segments.isNotEmpty &&
            inputs.length == template.segments.length &&
            inputs.every((answer) => answer.trim().isNotEmpty),
      );
    }

    return PhysicalCard(
      controller: physicalCardController,
      padding: EdgeInsets.zero,
      front: AlignedScrollView(
        verticallyCentered: template.verticallyCentered,
        padding: padding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Fill in the blank'.toUpperCase(),
              textAlign: TextAlign.center,
              style: eyebrowStyle,
            ),
            SizedBox(height: promptGap),
            for (final entry in template.segments.asMap().entries) ...[
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: segmentSpacing,
                runSpacing: segmentRunSpacing,
                children: [
                  Text(entry.value.prefix, style: blankTextStyle),
                  effectiveIsRevealed
                      ? _PreviewAnswer(
                          label: entry.value.correctAnswer,
                          contentScale: contentScale,
                          textStyle: markdownTextStyle,
                        )
                      : FillInTheBlankAnswerInput(
                          revealed: interactionsController?.isRevealed ?? false,
                          correct: _isCorrect(entry.key, blankInputs.value),
                          correctAnswer: entry.value.correctAnswer,
                          contentScale: contentScale,
                          textStyle: markdownTextStyle,
                          onChanged: (value) =>
                              updateBlankInput(entry.key, value),
                        ),
                  Text(entry.value.suffix, style: blankTextStyle),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PreviewAnswer extends StatelessWidget {
  const _PreviewAnswer({
    required this.label,
    required this.contentScale,
    required this.textStyle,
  });

  final String label;
  final double contentScale;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return Container(
      padding: ScaleHelper.getScaledEdgeInsets(
        EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        contentScale,
      ),
      decoration: BoxDecoration(
        color: tokens.colorActionSuccess.withValues(alpha: 0.12),
        border: Border.all(color: tokens.colorActionSuccess),
        borderRadius: BorderRadius.circular(10.r * contentScale),
      ),
      child: MarkdownText(
        data: label,
        mode: MarkdownTextMode.preview,
        baseTextStyle: textStyle,
        contentScale: contentScale,
      ),
    );
  }
}
