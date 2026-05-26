import 'package:boo_mondai/lib.barrel.dart'
    show
        MultipleChoiceTemplate,
        StudySessionCardStageController,
        AppTokens,
        MultipleChoiceOption,
        ButtonTone,
        appTextStyle,
        TextSize,
        TextWeight,
        TextTone,
        ButtonDepth,
        Button,
        PhysicalCardSide;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

class MultipleChoiceCard extends HookWidget {
  const MultipleChoiceCard({
    super.key,
    required this.template,
    required this.interactionsController,
  });

  final MultipleChoiceTemplate template;
  final StudySessionCardStageController interactionsController;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final selectedOption = useState<String?>(null);

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
                style: appTextStyle.resolve(tokens, [
                  TextSize.labelSmall,
                  TextWeight.heavy,
                  TextTone.muted,
                ]),
              ),
              SizedBox(height: 28.h),
              Text(
                template.questionPrompt,
                textAlign: TextAlign.center,
                style: appTextStyle.resolve(tokens, [
                  TextSize.header,
                  TextWeight.heavy,
                  TextTone.primary,
                ]),
              ),
            ],
          ),
          SizedBox(height: 32.h),
          Column(
            children: [
              for (final entry in template.options.asMap().entries) ...[
                SizedBox(
                  width: double.infinity,
                  child: Button(
                    tone: _optionTone(entry.value),
                    depth: ButtonDepth.flat,
                    selected:
                        !interactionsController.isRevealed &&
                        selectedOption.value == entry.value.id,
                    mainAxisAlignment: MainAxisAlignment.start,
                    onPressed: interactionsController.isRevealed
                        ? null
                        : () {
                            selectedOption.value = entry.value.id;
                            interactionsController.setAnswer(entry.value.id);
                            interactionsController.setCanReveal(true);
                          },
                    child: Text(
                      _optionLabel(entry.value, entry.key),
                      style: appTextStyle.resolve(tokens, [
                        TextSize.labelLarge,
                        TextWeight.heavy,
                        TextTone.primary,
                      ]),
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

  ButtonTone _optionTone(MultipleChoiceOption option) {
    final isSelected = interactionsController.answer == option.id;
    final isCorrect = option.isCorrect;
    if (interactionsController.isRevealed && isCorrect) {
      return ButtonTone.success;
    }
    if (interactionsController.isRevealed && isSelected) {
      return ButtonTone.error;
    }
    return ButtonTone.ghost;
  }

  String _optionLabel(MultipleChoiceOption option, int index) {
    final label = option.optionText.trim();
    return label.isEmpty ? 'Option ${index + 1}' : label;
  }
}
