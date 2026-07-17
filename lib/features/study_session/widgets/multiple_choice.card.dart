import 'package:boo_mondai/lib.barrel.dart'
    show
        MultipleChoiceTemplate,
        StudySessionCardStageController,
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
        PhysicalCardController;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class MultipleChoiceCard extends HookWidget {
  const MultipleChoiceCard({
    super.key,
    required this.template,
    this.interactionsController,
    this.isRevealed = false,
    this.maxWidth,
    this.controller,
  });

  final MultipleChoiceTemplate template;
  final StudySessionCardStageController? interactionsController;
  final bool isRevealed;
  final double? maxWidth;
  final PhysicalCardController? controller;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final contentScale = ScaleHelper.getClampedSizeRatio(
      current: maxWidth ?? tokens.studyCardWidth,
      base: tokens.studyCardWidth,
      min: 0.6,
      max: 1.4,
    );
    final eyebrowStyle = ScaleHelper.getTextStyleWithScaledFontSize(
      textStyle.resolve(tokens, const [
        TextSize.labelSmall,
        TextWeight.heavy,
        TextColor.muted,
      ]),
      contentScale,
    );
    final selectedOption = useState<String?>(null);
    final effectiveIsRevealed =
        isRevealed || interactionsController?.isRevealed == true;
    final fallbackPhysicalCardController = usePhysicalCardController(
      context,
      width: maxWidth,
    );
    final physicalCardController = controller ?? fallbackPhysicalCardController;

    useEffect(() {
      selectedOption.value = null;
      return null;
    }, [template.id, interactionsController]);

    return PhysicalCard(
      controller: physicalCardController,
      front: AlignedScrollView(
        verticallyCentered: template.verticallyCentered,
        padding: EdgeInsets.all(tokens.spaceLayoutPaddingSm),
        child: Column(
          spacing: tokens.spaceLayoutGapMd,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              spacing: tokens.spaceLayoutGapMd,
              children: [
                Text(
                  'Select Answer'.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: eyebrowStyle,
                ),
                MarkdownText(
                  data: template.questionPrompt,
                  mode: MarkdownTextMode.previewSelectable,
                  resolveAttachmentUrl: template.resolveAttachmentUrl,
                ),
              ],
            ),
            Column(
              children: [
                for (final entry in template.options.asMap().entries) ...[
                  SizedBox(
                    width: double.infinity,
                    child: Button(
                      variants: [
                        ..._optionVariants(entry.value, effectiveIsRevealed),
                        ButtonVariant.flat,
                      ],
                      selected:
                          !effectiveIsRevealed &&
                          selectedOption.value == entry.value.id,
                      mainAxisAlignment: MainAxisAlignment.start,
                      onPressed: effectiveIsRevealed
                          ? null
                          : () {
                              selectedOption.value = entry.value.id;
                              interactionsController?.setAnswer(entry.value.id);
                              interactionsController?.setCanReveal(true);
                            },
                      child: MarkdownText(
                        data: _optionLabel(entry.value, entry.key),
                        mode: MarkdownTextMode.previewSelectable,
                        resolveAttachmentUrl: template.resolveAttachmentUrl,
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
    final isSelected = interactionsController?.answer == option.id;
    final isCorrect = option.isCorrect;
    if (isRevealed && isCorrect) {
      return [ButtonColor.success];
    }
    if (isRevealed && isSelected) {
      return [ButtonColor.error];
    }
    return [ButtonColor.baseline];
  }

  String _optionLabel(MultipleChoiceOption option, int index) {
    final label = option.optionText.trim();
    return label.isEmpty ? 'Option ${index + 1}' : label;
  }
}
