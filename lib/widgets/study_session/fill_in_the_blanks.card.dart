import 'package:boo_mondai/controllers/controllers.barrel.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/shared/theme/theme.barrel.dart';
import 'package:boo_mondai/variant_styles/variant_styles.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

class FillInTheBlanksCard extends HookWidget {
  const FillInTheBlanksCard({
    super.key,
    required this.template,
    required this.interactionsController,
  });

  final FillInTheBlanksTemplate template;
  final StudySessionCardStageController interactionsController;

  bool _isCorrect(int index, List<String> blankInputs) {
    final answer = index < blankInputs.length ? blankInputs[index] : '';
    return template.segments[index].checkAnswer(answer);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final blankInputs = useState<List<String>>(
      List.filled(template.segments.length, ''),
    );

    useEffect(() {
      blankInputs.value = List.filled(template.segments.length, '');
      return null;
    }, [template.id, interactionsController]);

    void updateBlankInput(int index, String value) {
      final inputs = [...blankInputs.value];
      if (index >= inputs.length) return;
      inputs[index] = value;
      blankInputs.value = inputs;

      interactionsController.setAnswer(inputs.join('|'));
      interactionsController.setCanReveal(
        template.segments.isNotEmpty &&
            inputs.length == template.segments.length &&
            inputs.every((answer) => answer.trim().isNotEmpty),
      );
    }

    return PhysicalCardSide(
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 480.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Fill in the blank'.toUpperCase(),
                textAlign: TextAlign.center,
                style: appTextStyle.resolve(tokens, [
                  TextSize.labelSmall,
                  TextWeight.heavy,
                  TextTone.muted,
                ]),
              ),
              SizedBox(height: 48.h),
              for (final entry in template.segments.asMap().entries) ...[
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 12.w,
                  runSpacing: 16.h,
                  children: [
                    Text(
                      entry.value.prefix,
                      style: appTextStyle.resolve(
                        context.themeTokens<AppTokens>(),
                        [
                          TextSize.bodyLarge,
                          TextWeight.heavy,
                          TextTone.primary,
                        ],
                      ),
                    ),
                    FillInTheBlankAnswerInput(
                      revealed: interactionsController.isRevealed,
                      correct: _isCorrect(entry.key, blankInputs.value),
                      correctAnswer: entry.value.correctAnswer,
                      onChanged: (value) => updateBlankInput(entry.key, value),
                    ),
                    Text(
                      entry.value.suffix,
                      style: appTextStyle.resolve(
                        context.themeTokens<AppTokens>(),
                        [
                          TextSize.bodyLarge,
                          TextWeight.heavy,
                          TextTone.primary,
                        ],
                      ),
                    ),
                  ],
                ),
                if (entry.key != template.segments.length - 1)
                  SizedBox(height: 24.h),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
