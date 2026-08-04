import 'package:boo_mondai/lib.barrel.dart'
    show
        AlignedScrollView,
        AppTokens,
        IdentificationTemplate,
        MarkdownText,
        MarkdownTextMode,
        PhysicalCard,
        PhysicalCardController,
        ScaleHelper,
        StudySessionCardStageController,
        TextColor,
        TextField,
        TextFieldFrame,
        TextFieldSize,
        TextSize,
        TextWeight,
        textStyle,
        usePhysicalCardController;
import 'package:flutter/material.dart' hide TextField;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

class IdentificationCard extends HookWidget {
  const IdentificationCard({
    required this.template,
    super.key,
    this.interactionsController,
    this.isRevealed = false,
    this.maxWidth,
    this.contentScale = 1,
    this.controller,
  });

  final IdentificationTemplate template;
  final StudySessionCardStageController? interactionsController;
  final bool isRevealed;
  final double? maxWidth;
  final double contentScale;
  final PhysicalCardController? controller;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final answerController = useTextEditingController();
    final effectiveIsRevealed =
        isRevealed || interactionsController?.isRevealed == true;
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
    final promptStyle = ScaleHelper.getTextStyleWithScaledFontSize(
      textStyle.resolve(tokens, const [
        TextSize.bodyLarge,
        TextWeight.heavy,
        TextColor.baseline,
      ]),
      contentScale,
    );
    final answerStyle = ScaleHelper.getTextStyleWithScaledFontSize(
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
    final gap = ScaleHelper.getScaledValue(
      tokens.spaceLayoutGapMd,
      contentScale,
    );

    useEffect(() {
      answerController.clear();
      interactionsController?.setAnswer(null);
      interactionsController?.setCanReveal(false);
      return null;
    }, [template.id, interactionsController]);

    void updateAnswer(String value) {
      interactionsController?.setAnswer(value.trim().isEmpty ? null : value);
      interactionsController?.setCanReveal(value.trim().isNotEmpty);
    }

    return PhysicalCard(
      controller: physicalCardController,
      padding: EdgeInsets.zero,
      front: AlignedScrollView(
        verticallyCentered: template.verticallyCentered,
        padding: padding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Identification'.toUpperCase(),
              textAlign: TextAlign.center,
              style: eyebrowStyle,
            ),
            SizedBox(height: gap),
            MarkdownText(
              data: template.promptText,
              mode: MarkdownTextMode.preview,
              baseTextStyle: promptStyle,
              contentScale: contentScale,
            ),
            SizedBox(height: gap),
            if (effectiveIsRevealed)
              _AcceptedAnswersPreview(
                template: template,
                textStyle: answerStyle,
                contentScale: contentScale,
              )
            else
              TextField(
                controller: answerController,
                onChanged: updateAnswer,
                placeholder: 'Type your answer...',
                variants: const [
                  TextFieldSize.labelLarge,
                  TextFieldFrame.outline,
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _AcceptedAnswersPreview extends StatelessWidget {
  const _AcceptedAnswersPreview({
    required this.template,
    required this.textStyle,
    required this.contentScale,
  });

  final IdentificationTemplate template;
  final TextStyle textStyle;
  final double contentScale;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final answers = template.acceptedAnswers.toList()
      ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: ScaleHelper.getScaledValue(8.w, contentScale),
      runSpacing: ScaleHelper.getScaledValue(8.h, contentScale),
      children: [
        for (final answer in answers)
          Container(
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
              data: answer.answer,
              mode: MarkdownTextMode.preview,
              baseTextStyle: textStyle,
              contentScale: contentScale,
            ),
          ),
      ],
    );
  }
}
