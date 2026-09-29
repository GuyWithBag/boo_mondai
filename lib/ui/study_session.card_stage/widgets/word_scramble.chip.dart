import 'package:boo_mondai/lib.barrel.dart'
    show AppTokens, ScaleHelper, TextColor, TextSize, TextWeight, textStyle;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

class WordScrambleChip extends StatelessWidget {
  const WordScrambleChip({
    required this.value,
    super.key,
    this.onPressed,
    this.onDeleted,
    this.selected = false,
    this.correct,
    this.contentScale = 1,
  });

  final String value;
  final VoidCallback? onPressed;
  final VoidCallback? onDeleted;
  final bool selected;
  final bool? correct;
  final double contentScale;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final color = switch (correct) {
      true => tokens.colorActionSuccess,
      false => tokens.colorActionError,
      null => selected ? tokens.colorPrimary : tokens.colorBorderNeutralSubtle,
    };
    final textColor = correct == null && !selected
        ? tokens.colorTextBaseline
        : color;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10.r * contentScale),
        onTap: onPressed,
        child: Container(
          padding: ScaleHelper.getScaledEdgeInsets(
            EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            contentScale,
          ),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            border: Border.all(color: color),
            borderRadius: BorderRadius.circular(10.r * contentScale),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: ScaleHelper.getTextStyleWithScaledFontSize(
                  textStyle
                      .resolve(tokens, const [
                        TextSize.label,
                        TextWeight.heavy,
                        TextColor.baseline,
                      ])
                      .copyWith(color: textColor),
                  contentScale,
                ),
              ),
              if (onDeleted != null) ...[
                SizedBox(width: ScaleHelper.getScaledValue(6.w, contentScale)),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onDeleted,
                  child: Icon(
                    Icons.close_rounded,
                    size: ScaleHelper.getScaledValue(18.sp, contentScale),
                    color: textColor,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
