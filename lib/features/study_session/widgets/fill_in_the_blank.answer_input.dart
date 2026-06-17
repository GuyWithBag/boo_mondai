import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        MarkdownText,
        TextFieldFrame,
        TextFieldSize,
        TextFieldState,
        TextFieldTone,
        VariantTextField;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

class FillInTheBlankAnswerInput extends StatelessWidget {
  const FillInTheBlankAnswerInput({
    required this.revealed,
    required this.correct,
    required this.correctAnswer,
    required this.onChanged,
    super.key,
  });

  final bool revealed;
  final bool correct;
  final String correctAnswer;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final tone = revealed
        ? correct
              ? TextFieldTone.success
              : TextFieldTone.error
        : TextFieldTone.brand;
    final state = revealed && !correct
        ? TextFieldState.incorrect
        : TextFieldState.idle;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 260.w,
          child: VariantTextField(
            enabled: !revealed,
            onChanged: onChanged,
            variants: [
              TextFieldSize.labelLarge,
              TextFieldFrame.underline,
              tone,
              state,
            ],
          ),
        ),
        if (revealed && !correct) ...[
          SizedBox(height: 10.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: tokens.colorActionSuccess.withValues(alpha: 0.12),
              border: Border.all(color: tokens.colorActionSuccess),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: MarkdownText(data: correctAnswer),
          ),
        ],
      ],
    );
  }
}
