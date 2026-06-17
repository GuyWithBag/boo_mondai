import 'package:boo_mondai/lib.barrel.dart'
    show
        MultipleChoiceTemplate,
        StudySessionCardStageController,
        AppTokens,
        MultipleChoiceOption,
        ButtonVariant,
        ButtonColor,
        textStyle,
        TextSize,
        TextWeight,
        TextColor,
        ButtonDepth,
        Button,
        PhysicalCardSide,
        MarkdownText;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

class MultipleChoiceCard extends HookWidget {
  const MultipleChoiceCard({
    super.key,
    required this.template,
    required this.interactionsController,
  }) : previewRevealed = false;

  const MultipleChoiceCard.preview({super.key, required this.template})
    : interactionsController = null,
      previewRevealed = true;

  final MultipleChoiceTemplate template;
  final StudySessionCardStageController? interactionsController;
  final bool previewRevealed;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final selectedOption = useState<String?>(null);
    final isRevealed =
        previewRevealed || interactionsController?.isRevealed == true;

    useEffect(() {
      selectedOption.value = null;
      return null;
    }, [template.id, interactionsController]);

    return PhysicalCardSide(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(
                'Select Answer'.toUpperCase(),
                textAlign: TextAlign.center,
                style: textStyle.resolve(tokens, [
                  TextSize.labelSmall,
                  TextWeight.heavy,
                  TextColor.muted,
                ]),
              ),
              SizedBox(height: 28.h),
              MarkdownText(data: template.questionPrompt),
            ],
          ),
          SizedBox(height: 32.h),
          Column(
            children: [
              for (final entry in template.options.asMap().entries) ...[
                SizedBox(
                  width: double.infinity,
                  child: Button(
                    variants: [
                      ..._optionVariants(entry.value),
                      ButtonDepth.flat,
                    ],
                    selected:
                        !isRevealed && selectedOption.value == entry.value.id,
                    mainAxisAlignment: MainAxisAlignment.start,
                    onPressed: isRevealed
                        ? null
                        : () {
                            selectedOption.value = entry.value.id;
                            interactionsController?.setAnswer(entry.value.id);
                            interactionsController?.setCanReveal(true);
                          },
                    child: MarkdownText(
                      data: _optionLabel(entry.value, entry.key),
                    ),
                  ),
                ),
                if (entry.key != template.options.length - 1)
                  SizedBox(height: 14.h),
              ],
            ],
          ),
        ],
      ),
    );
  }

  List<Object> _optionVariants(MultipleChoiceOption option) {
    final isSelected = interactionsController?.answer == option.id;
    final isCorrect = option.isCorrect;
    final isRevealed =
        previewRevealed || interactionsController?.isRevealed == true;
    if (isRevealed && isCorrect) {
      return [ButtonVariant.soft, ButtonColor.success];
    }
    if (isRevealed && isSelected) {
      return [ButtonVariant.soft, ButtonColor.error];
    }
    return [ButtonVariant.ghost, ButtonColor.neutral];
  }

  String _optionLabel(MultipleChoiceOption option, int index) {
    final label = option.optionText.trim();
    return label.isEmpty ? 'Option ${index + 1}' : label;
  }
}
