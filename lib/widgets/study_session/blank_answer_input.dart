import 'package:boo_mondai/shared/theme/theme.barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

import '../../variant_styles/variant_styles.barrel.dart';
import '../variant_text_field.dart';

class BlankAnswerInput extends StatelessWidget {
  const BlankAnswerInput({
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
              ? AppTextFieldTone.success
              : AppTextFieldTone.error
        : AppTextFieldTone.brand;
    final state = revealed && !correct
        ? AppTextFieldState.incorrect
        : AppTextFieldState.idle;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 260.w,
          child: VariantTextField(
            enabled: !revealed,
            onChanged: onChanged,
            variants: [
              AppTextFieldSize.labelLarge,
              AppTextFieldFrame.underline,
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
              color: tokens.actionSuccess.withValues(alpha: 0.12),
              border: Border.all(color: tokens.actionSuccess),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Text(
              correctAnswer,
              style: appTextStyle
                  .resolve(tokens, [
                    TextSize.label,
                    TextWeight.heavy,
                    TextTone.primary,
                  ])
                  .copyWith(color: tokens.actionSuccess),
            ),
          ),
        ],
      ],
    );
  }
}
