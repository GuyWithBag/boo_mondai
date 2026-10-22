import 'package:boo_mondai/ui/study_session.card_stage/widgets/scaled_surface_style.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        AlignedScrollView,
        AppTokens,
        IdentificationTemplate,
        MarkdownAttachmentUrlResolver,
        MarkdownHelper,
        MarkdownText,
        MarkdownTextMode,
        PhysicalCard,
        PhysicalCardController,
        ScaleHelper,
        StudySessionCardStageController,
        SurfacePadding,
        SurfaceShadow,
        SurfaceShape,
        TextColor,
        TextField,
        TextFieldFrame,
        TextFieldSize,
        TextSize,
        TextWeight,
        surfaceStyle,
        textStyle,
        usePhysicalCardController;
import 'package:boo_mondai/ui/study_session.card_stage/stages/identification/controllers/identification.controller.dart';
import 'package:flutter/material.dart' hide TextField;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:signals_hooks/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class IdentificationCard extends SignalHookWidget {
  const IdentificationCard({
    required this.template,
    super.key,
    this.cardStageController,
    this.isRevealed = false,
    this.maxWidth,
    this.contentScale = 1,
    this.controller,
  });

  final IdentificationTemplate template;
  final StudySessionCardStageController? cardStageController;
  final bool isRevealed;
  final double? maxWidth;
  final double contentScale;
  final PhysicalCardController? controller;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final identificationController = useMemoized(
      () => IdentificationController(
        template: template,
        cardStageController: cardStageController,
        isRevealed: isRevealed,
      ),
      [template.id, cardStageController],
    );
    identificationController.updateIsRevealed(isRevealed);
    final fallbackPhysicalCardController = usePhysicalCardController(
      context,
      width: maxWidth,
    );
    final physicalCardController = controller ?? fallbackPhysicalCardController;
    final resolveAttachmentUrl = MarkdownHelper.resolveTemplateAttachmentUrl(
      template,
    );
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
    final helperStyle = ScaleHelper.getTextStyleWithScaledFontSize(
      textStyle.resolve(tokens, const [
        TextSize.labelSmall,
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

    useEffect(() {
      identificationController.resetAnswer();
      return null;
    }, [identificationController, template.id, cardStageController]);
    useEffect(() => identificationController.dispose, [
      identificationController,
    ]);

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
              resolveAttachmentUrl: resolveAttachmentUrl,
            ),
            SizedBox(height: gap),
            if (identificationController.effectiveIsRevealed)
              _AcceptedAnswersPreview(
                controller: identificationController,
                textStyle: answerStyle,
                contentScale: contentScale,
                resolveAttachmentUrl: resolveAttachmentUrl,
              )
            else ...[
              TextField(
                controller: identificationController.answerTextController,
                onChanged: identificationController.updateAnswer,
                placeholder: 'Type your answer...',
                variants: const [
                  TextFieldSize.labelLarge,
                  TextFieldFrame.outline,
                ],
              ),
              SizedBox(height: ScaleHelper.getScaledValue(8.h, contentScale)),
              Text(
                identificationController.answerCasingGuidance,
                textAlign: TextAlign.center,
                style: helperStyle,
              ),
              if (identificationController.answerCountGuidance
                  case final guidance?)
                Text(guidance, textAlign: TextAlign.center, style: helperStyle),
            ],
          ],
        ),
      ),
    );
  }
}

class _AcceptedAnswersPreview extends StatelessWidget {
  const _AcceptedAnswersPreview({
    required this.controller,
    required this.textStyle,
    required this.contentScale,
    required this.resolveAttachmentUrl,
  });

  final IdentificationController controller;
  final TextStyle textStyle;
  final double contentScale;
  final MarkdownAttachmentUrlResolver resolveAttachmentUrl;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final resolvedAnswerStyle = surfaceStyle.resolve(tokens, [
      controller.answerSurfaceColor,
      SurfacePadding.xsm,
      SurfaceShape.roundedXxsm,
      SurfaceShadow.none,
    ]);
    final scaledAnswerStyle = scaledSurfaceStyle(
      resolvedAnswerStyle,
      contentScale,
    );

    return Column(
      spacing: ScaleHelper.getScaledValue(12.h, contentScale),
      children: [
        if (controller.shouldShowSubmittedAnswer)
          Text(
            controller.visibleSubmittedAnswer!,
            textAlign: TextAlign.center,
            style: textStyle.copyWith(color: tokens.colorActionError),
          ),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: ScaleHelper.getScaledValue(8.w, contentScale),
          runSpacing: ScaleHelper.getScaledValue(8.h, contentScale),
          children: [
            for (final answer in controller.sortedAnswers)
              Surface(
                style: scaledAnswerStyle,
                child: MarkdownText(
                  data: answer.value,
                  mode: MarkdownTextMode.preview,
                  baseTextStyle: textStyle,
                  contentScale: contentScale,
                  resolveAttachmentUrl: resolveAttachmentUrl,
                ),
              ),
          ],
        ),
        if (controller.wrongAnswerInsight case final insight?)
          _WrongAnswerInsight(
            insight: insight,
            textStyle: textStyle,
            contentScale: contentScale,
          ),
      ],
    );
  }
}

class _WrongAnswerInsight extends StatelessWidget {
  const _WrongAnswerInsight({
    required this.insight,
    required this.textStyle,
    required this.contentScale,
  });

  final String insight;
  final TextStyle textStyle;
  final double contentScale;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return Container(
      width: double.infinity,
      padding: ScaleHelper.getScaledEdgeInsets(
        EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        contentScale,
      ),
      decoration: BoxDecoration(
        color: tokens.colorActionError.withValues(alpha: 0.08),
        border: Border.all(color: tokens.colorActionError),
        borderRadius: BorderRadius.circular(10.r * contentScale),
      ),
      child: Text(
        insight,
        textAlign: TextAlign.center,
        style: textStyle.copyWith(color: tokens.colorActionError),
      ),
    );
  }
}
