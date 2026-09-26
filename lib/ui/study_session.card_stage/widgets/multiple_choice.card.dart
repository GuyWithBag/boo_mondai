import 'dart:math';

import 'package:boo_mondai/lib.barrel.dart'
    show
        MultipleChoiceTemplate,
        StudySessionCardStageController,
        StudySessionAnswer,
        AppTokens,
        MultipleChoiceOption,
        ButtonColor,
        textStyle,
        TextSize,
        TextWeight,
        TextColor,
        ButtonVariant,
        Button,
        PhysicalCard,
        ScaleHelper,
        AlignedScrollView,
        MarkdownText,
        MarkdownTextMode,
        usePhysicalCardController,
        PhysicalCardController,
        MarkdownHelper;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:signals_hooks/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class MultipleChoiceCard extends SignalHookWidget {
  const MultipleChoiceCard({
    super.key,
    required this.template,
    this.cardStageController,
    this.isRevealed = false,
    this.maxWidth,
    this.contentScale = 1,
    this.controller,
  });

  final MultipleChoiceTemplate template;
  final StudySessionCardStageController? cardStageController;
  final bool isRevealed;
  final double? maxWidth;
  final double contentScale;
  final PhysicalCardController? controller;

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
    final gap = ScaleHelper.getScaledValue(
      tokens.spaceLayoutGapMd,
      contentScale,
    );
    final displayedOptions = useMemoized(() => _orderedOptions(template), [
      template.id,
      template.options,
      template.randomizeOptionsOrdering,
    ]);
    final selectedOptionIds = useState<Set<String>>({});
    final effectiveIsRevealed =
        isRevealed || cardStageController?.isRevealed.value == true;
    final fallbackPhysicalCardController = usePhysicalCardController(
      context,
      width: maxWidth,
    );
    final physicalCardController = controller ?? fallbackPhysicalCardController;

    useEffect(() {
      selectedOptionIds.value = {};
      return null;
    }, [template.id, cardStageController]);

    void updateAnswer(Set<String> nextSelectedIds) {
      selectedOptionIds.value = nextSelectedIds;
      if (nextSelectedIds.isEmpty) {
        cardStageController?.answer.value = null;
        cardStageController?.canReveal.value = false;
        return;
      }

      final selectedOptions = [
        for (final option in template.options)
          if (nextSelectedIds.contains(option.id)) option,
      ];
      cardStageController?.answer.value = StudySessionAnswer(
        id: selectedOptions.map((option) => option.id).join('|'),
        value: selectedOptions.map((option) => option.optionText).join(', '),
      );
      cardStageController?.canReveal.value = true;
    }

    void toggleOption(MultipleChoiceOption option) {
      if (template.multipleAnswers) {
        final nextSelectedIds = {...selectedOptionIds.value};
        if (!nextSelectedIds.remove(option.id)) {
          nextSelectedIds.add(option.id);
        }
        updateAnswer(nextSelectedIds);
        return;
      }

      updateAnswer({option.id});
    }

    return PhysicalCard(
      controller: physicalCardController,
      padding: EdgeInsets.zero,
      front: AlignedScrollView(
        verticallyCentered: template.verticallyCentered,
        padding: padding,
        child: Column(
          spacing: gap,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              spacing: gap,
              children: [
                Text(
                  'Select Answer'.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: eyebrowStyle,
                ),
                MarkdownText(
                  data: template.questionPrompt,
                  mode: MarkdownTextMode.previewSelectable,
                  baseTextStyle: markdownTextStyle,
                  contentScale: contentScale,
                  resolveAttachmentUrl: MarkdownHelper.resolveAttachmentUrl,
                ),
              ],
            ),
            Column(
              children: [
                for (final option in displayedOptions) ...[
                  SizedBox(
                    width: double.infinity,
                    child: Button(
                      elevated: false,
                      contentScale: contentScale,
                      variants: [
                        ..._optionVariants(option, effectiveIsRevealed),
                        ButtonVariant.flat,
                      ],
                      selected:
                          !effectiveIsRevealed &&
                          selectedOptionIds.value.contains(option.id),
                      mainAxisAlignment: MainAxisAlignment.start,
                      onPressed: effectiveIsRevealed
                          ? null
                          : () => toggleOption(option),
                      child: MarkdownText(
                        data: option.optionText,
                        mode: MarkdownTextMode.previewSelectable,
                        baseTextStyle: markdownTextStyle,
                        contentScale: contentScale,
                        resolveAttachmentUrl:
                            MarkdownHelper.resolveAttachmentUrl,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Object> _optionVariants(MultipleChoiceOption option, bool isRevealed) {
    final isSelected = _isSelectedOption(option);
    final isCorrect = option.isCorrect;
    if (isRevealed && isCorrect) {
      return [ButtonColor.success];
    }
    if (isRevealed && isSelected) {
      return [ButtonColor.error];
    }
    return [ButtonColor.baseline];
  }

  bool _isSelectedOption(MultipleChoiceOption option) {
    final answer = cardStageController?.answer.value;
    if (answer == null) return false;
    final answerIds = answer.id?.split('|').map((id) => id.trim()).toSet();
    return answerIds?.contains(option.id) == true ||
        answer.value
            .split(',')
            .map((value) => value.trim().toLowerCase())
            .contains(option.optionText.trim().toLowerCase());
  }

  List<MultipleChoiceOption> _orderedOptions(MultipleChoiceTemplate template) {
    final options = [...template.options]
      ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
    if (!template.randomizeOptionsOrdering) return options;

    return options..shuffle(Random(_stableSeed(template.id)));
  }

  int _stableSeed(String value) {
    return value.codeUnits.fold<int>(0, (seed, unit) => seed * 31 + unit);
  }
}
