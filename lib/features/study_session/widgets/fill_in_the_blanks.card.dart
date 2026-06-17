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
        PhysicalCardSide;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

class FillInTheBlanksCard extends HookWidget {
  const FillInTheBlanksCard({
    super.key,
    required this.template,
    required this.interactionsController,
  }) : previewRevealed = false;

  const FillInTheBlanksCard.preview({super.key, required this.template})
    : interactionsController = null,
      previewRevealed = true;

  final FillInTheBlanksTemplate template;
  final StudySessionCardStageController? interactionsController;
  final bool previewRevealed;

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
    final isRevealed =
        previewRevealed || interactionsController?.isRevealed == true;

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
                style: textStyle.resolve(tokens, [
                  TextSize.labelSmall,
                  TextWeight.heavy,
                  TextColor.muted,
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
                      style: textStyle.resolve(
                        context.themeTokens<AppTokens>(),
                        [TextSize.bodyLarge, TextWeight.heavy],
                      ),
                    ),
                    isRevealed
                        ? _PreviewAnswer(label: entry.value.correctAnswer)
                        : FillInTheBlankAnswerInput(
                            revealed:
                                interactionsController?.isRevealed ?? false,
                            correct: _isCorrect(entry.key, blankInputs.value),
                            correctAnswer: entry.value.correctAnswer,
                            onChanged: (value) =>
                                updateBlankInput(entry.key, value),
                          ),
                    Text(
                      entry.value.suffix,
                      style: textStyle.resolve(
                        context.themeTokens<AppTokens>(),
                        [TextSize.bodyLarge, TextWeight.heavy],
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

class _PreviewAnswer extends StatelessWidget {
  const _PreviewAnswer({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: tokens.colorActionSuccess.withValues(alpha: 0.12),
        border: Border.all(color: tokens.colorActionSuccess),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: MarkdownText(data: label),
    );
  }
}
