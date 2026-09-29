import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        MarkdownText,
        MarkdownTextMode,
        TextFieldFrame,
        TextFieldSize,
        TextFieldColor,
        ScaleHelper,
        TextField;
import 'package:flutter/material.dart' hide TextField;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

class FillInTheBlankTextField extends StatelessWidget {
  const FillInTheBlankTextField({
    required this.revealed,
    required this.correct,
    required this.value,
    required this.correctAnswer,
    required this.onChanged,
    this.contentScale = 1,
    this.textStyle,
    super.key,
  });

  final bool revealed;
  final bool correct;
  final String value;
  final String correctAnswer;
  final ValueChanged<String> onChanged;
  final double contentScale;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final width = ScaleHelper.getScaledValue(70.w, contentScale);

    if (!revealed) {
      return SizedBox(
        width: width,
        child: TextField(
          onChanged: onChanged,
          variants: const [
            TextFieldSize.labelLarge,
            TextFieldFrame.underline,
            TextFieldColor.brand,
          ],
        ),
      );
    }

    final color = correct ? tokens.colorActionSuccess : tokens.colorActionError;
    return IntrinsicWidth(
      child: Container(
        padding: ScaleHelper.getScaledEdgeInsets(
          EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          contentScale,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(10.r * contentScale),
        ),
        child: MarkdownText(
          data: correct ? value : correctAnswer,
          mode: MarkdownTextMode.preview,
          baseTextStyle: textStyle,
          contentScale: contentScale,
        ),
      ),
    );
  }
}
