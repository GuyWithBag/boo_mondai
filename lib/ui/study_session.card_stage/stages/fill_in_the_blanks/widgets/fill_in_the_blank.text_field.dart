import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        MarkdownText,
        MarkdownTextMode,
        TextFieldFrame,
        TextFieldSize,
        TextFieldColor,
        ScaleHelper,
        TextField,
        surfaceStyle,
        SurfaceColor,
        SurfacePadding,
        SurfaceShadow,
        SurfaceShape;
import 'package:boo_mondai/ui/study_session.card_stage/widgets/scaled_surface_style.dart';
import 'package:flutter/material.dart' hide TextField;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

class FillInTheBlankTextField extends StatelessWidget {
  const FillInTheBlankTextField({
    required this.revealed,
    required this.answered,
    required this.correct,
    required this.value,
    required this.correctAnswer,
    required this.onChanged,
    this.contentScale = 1,
    this.textStyle,
    super.key,
  });

  final bool revealed;
  final bool answered;
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

    final color = !answered
        ? SurfaceColor.baseline
        : correct
        ? SurfaceColor.success
        : SurfaceColor.error;
    final resolvedStyle = surfaceStyle.resolve(tokens, [
      color,
      SurfacePadding.xsm,
      SurfaceShape.roundedXxsm,
      SurfaceShadow.none,
    ]);

    return IntrinsicWidth(
      child: Surface(
        style: scaledSurfaceStyle(resolvedStyle, contentScale),
        child: MarkdownText(
          data: correct && answered ? value : correctAnswer,
          mode: MarkdownTextMode.preview,
          baseTextStyle: textStyle,
          contentScale: contentScale,
        ),
      ),
    );
  }
}
