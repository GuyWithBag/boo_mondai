import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        MarkdownText,
        MarkdownTextMode,
        TextFieldFrame,
        TextFieldSize,
        TextFieldState,
        TextFieldColor,
        ScaleHelper,
        TextField;
import 'package:flutter/material.dart' hide TextField;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

class FillInTheBlankAnswerInput extends StatelessWidget {
  const FillInTheBlankAnswerInput({
    required this.revealed,
    required this.correct,
    required this.correctAnswer,
    required this.onChanged,
    this.contentScale = 1,
    this.textStyle,
    super.key,
  });

  final bool revealed;
  final bool correct;
  final String correctAnswer;
  final ValueChanged<String> onChanged;
  final double contentScale;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final tone = revealed
        ? correct
              ? TextFieldColor.success
              : TextFieldColor.error
        : TextFieldColor.brand;
    final state = revealed && !correct
        ? TextFieldState.incorrect
        : TextFieldState.idle;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: ScaleHelper.getScaledValue(260.w, contentScale),
          child: TextField(
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
          SizedBox(height: ScaleHelper.getScaledValue(10.h, contentScale)),
          Container(
            padding: ScaleHelper.getScaledEdgeInsets(
              EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              contentScale,
            ),
            decoration: BoxDecoration(
              color: tokens.colorActionSuccess.withValues(alpha: 0.12),
              border: Border.all(color: tokens.colorActionSuccess),
              borderRadius: BorderRadius.circular(10.r * contentScale),
            ),
            child: MarkdownText(
              data: correctAnswer,
              mode: MarkdownTextMode.preview,
              baseTextStyle: textStyle,
              contentScale: contentScale,
            ),
          ),
        ],
      ],
    );
  }
}
