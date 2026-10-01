import 'package:boo_mondai/core/helpers/casing.helper.dart';
import 'package:boo_mondai/core/helpers/casing.type.dart';
import 'package:boo_mondai/features/cards/models/identification.answer_key.dto.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        AlignedScrollView,
        AppTokens,
        CardTemplateController,
        IdentificationTemplate,
        MarkdownText,
        MarkdownTextMode,
        PhysicalCard,
        PhysicalCardController,
        ScaleHelper,
        StudyRating,
        StudySessionCardStageController,
        StudySessionAnswer,
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
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
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
  final StudySessionCardStageController<CardTemplateController>?
  cardStageController;
  final bool isRevealed;
  final double? maxWidth;
  final double contentScale;
  final PhysicalCardController? controller;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final answerController = useTextEditingController();
    final effectiveIsRevealed =
        isRevealed || cardStageController?.isRevealed.value == true;
    final wasIncorrect =
        cardStageController?.pendingRating.value == StudyRating.incorrect;
    final submittedAnswer = cardStageController?.answer.value?.value.trim();
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
      answerController.clear();
      cardStageController?.answer.value = null;
      cardStageController?.canReveal.value = false;
      return null;
    }, [template.id, cardStageController]);

    void updateAnswer(String value) {
      cardStageController?.answer.value = value.trim().isEmpty
          ? null
          : StudySessionAnswer(value: value);
      cardStageController?.canReveal.value = value.trim().isNotEmpty;
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
                wasIncorrect: wasIncorrect,
                submittedAnswer: submittedAnswer,
              )
            else ...[
              TextField(
                controller: answerController,
                onChanged: updateAnswer,
                placeholder: 'Type your answer...',
                variants: const [
                  TextFieldSize.labelLarge,
                  TextFieldFrame.outline,
                ],
              ),
              SizedBox(height: ScaleHelper.getScaledValue(8.h, contentScale)),
              Text(
                _answerGuidance(template),
                textAlign: TextAlign.center,
                style: helperStyle,
              ),
            ],
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
    required this.wasIncorrect,
    this.submittedAnswer,
  });

  final IdentificationTemplate template;
  final TextStyle textStyle;
  final double contentScale;
  final bool wasIncorrect;
  final String? submittedAnswer;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final answers = template.answers.toList()
      ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));

    final visibleSubmittedAnswer = submittedAnswer?.trim();

    return Column(
      spacing: ScaleHelper.getScaledValue(12.h, contentScale),
      children: [
        if (wasIncorrect &&
            visibleSubmittedAnswer != null &&
            visibleSubmittedAnswer.isNotEmpty)
          Text(
            visibleSubmittedAnswer,
            textAlign: TextAlign.center,
            style: textStyle.copyWith(color: tokens.colorActionError),
          ),
        Wrap(
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
                  color:
                      (wasIncorrect
                              ? tokens.colorActionError
                              : tokens.colorActionSuccess)
                          .withValues(alpha: 0.12),
                  border: Border.all(
                    color: wasIncorrect
                        ? tokens.colorActionError
                        : tokens.colorActionSuccess,
                  ),
                  borderRadius: BorderRadius.circular(10.r * contentScale),
                ),
                child: MarkdownText(
                  data: answer.value,
                  mode: MarkdownTextMode.preview,
                  baseTextStyle: textStyle,
                  contentScale: contentScale,
                ),
              ),
          ],
        ),
        if (wasIncorrect &&
            visibleSubmittedAnswer != null &&
            visibleSubmittedAnswer.isNotEmpty)
          _WrongAnswerInsight(
            answers: answers,
            submittedAnswer: visibleSubmittedAnswer,
            textStyle: textStyle,
            contentScale: contentScale,
          ),
      ],
    );
  }
}

class _WrongAnswerInsight extends StatelessWidget {
  const _WrongAnswerInsight({
    required this.answers,
    required this.submittedAnswer,
    required this.textStyle,
    required this.contentScale,
  });

  final List<IdentificationAnswerKey> answers;
  final String submittedAnswer;
  final TextStyle textStyle;
  final double contentScale;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final insight = _wrongAnswerInsight(answers, submittedAnswer);
    if (insight == null) return const SizedBox.shrink();

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

String _answerGuidance(IdentificationTemplate template) {
  final answers = template.answers;
  final casingLabels = answers
      .map((answer) => _casingInstruction(answer.casingType))
      .toSet()
      .toList();
  final casingText = casingLabels.length == 1
      ? casingLabels.single
      : casingLabels.join(' or ');
  final answerText = answers.length == 1
      ? 'There is 1 accepted answer.'
      : 'There are ${answers.length} accepted answers.';

  return 'Expected casing: $casingText $answerText';
}

String? _wrongAnswerInsight(
  List<IdentificationAnswerKey> answers,
  String submittedAnswer,
) {
  final normalizedSubmitted = CasingHelper.normalizedWords(submittedAnswer);
  if (normalizedSubmitted.isEmpty) return null;

  for (final answer in answers) {
    if (CasingHelper.normalizedWords(answer.value) != normalizedSubmitted) {
      continue;
    }

    return 'The wording matches "${answer.value}", but the casing should be ${_casingRequirement(answer.casingType)}.';
  }

  final closest = _closestAnswer(answers, submittedAnswer);
  if (closest == null) return null;

  return 'Closest accepted answer: "${closest.value}".';
}

String _casingRequirement(CasingType casingType) {
  return switch (casingType) {
    CasingType.any => 'any casing',
    CasingType.exact => 'exact',
    CasingType.camel => 'camelCase',
    CasingType.pascal => 'PascalCase',
    CasingType.snake => 'snake_case',
    CasingType.kebab => 'kebab-case',
    CasingType.title => 'Title Case',
  };
}

IdentificationAnswerKey? _closestAnswer(
  List<IdentificationAnswerKey> answers,
  String submittedAnswer,
) {
  const cutoff = 70;
  IdentificationAnswerKey? closest;
  var bestScore = 0;

  for (final answer in answers) {
    final score = ratio(
      CasingHelper.normalizedWords(submittedAnswer),
      CasingHelper.normalizedWords(answer.value),
    );
    if (score > bestScore) {
      closest = answer;
      bestScore = score;
    }
  }

  return bestScore >= cutoff ? closest : null;
}

String _casingInstruction(CasingType casingType) {
  return switch (casingType) {
    CasingType.any => 'Any casing is accepted.',
    CasingType.exact => 'Use exact casing.',
    CasingType.camel => 'Use camelCase.',
    CasingType.pascal => 'Use PascalCase.',
    CasingType.snake => 'Use snake_case.',
    CasingType.kebab => 'Use kebab-case.',
    CasingType.title => 'Use Title Case.',
  };
}
