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
        PhysicalCardSide,
        ScaleHelper,
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
    this.maxWidth,
  }) : previewRevealed = false;

  const MultipleChoiceCard.preview({
    super.key,
    required this.template,
    this.maxWidth,
  }) : interactionsController = null,
       previewRevealed = true;

  final MultipleChoiceTemplate template;
  final StudySessionCardStageController? interactionsController;
  final bool previewRevealed;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final contentScale = ScaleHelper.factor(
      current: maxWidth ?? tokens.studyCardWidth,
      base: tokens.studyCardWidth,
      min: 0.6,
      max: 1.4,
    );
    final eyebrowStyle = ScaleHelper.textStyle(
      textStyle.resolve(tokens, const [
        TextSize.labelSmall,
        TextWeight.heavy,
        TextColor.muted,
      ]),
      contentScale,
    );
    final selectedOption = useState<String?>(null);
    final isRevealed =
        previewRevealed || interactionsController?.isRevealed == true;

    useEffect(() {
      selectedOption.value = null;
      return null;
    }, [template.id, interactionsController]);

    return PhysicalCardSide(
      maxWidth: maxWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(
                'Select Answer'.toUpperCase(),
                textAlign: TextAlign.center,
                style: eyebrowStyle,
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
                      ButtonVariant.flat,
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
