import 'package:boo_mondai/core/theme/app_tokens.model.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        ScaleHelper,
        SurfaceColor,
        SurfacePadding,
        SurfaceShadow,
        SurfaceShape,
        TextColor,
        TextSize,
        TextWeight,
        surfaceStyle,
        textStyle;
import 'package:boo_mondai/ui/study_session.card_stage/stages/word_scramble/controllers/word_scramble.controller.dart';
import 'package:boo_mondai/ui/study_session.card_stage/widgets/scaled_surface_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

class WordScrambleChip extends StatelessWidget {
  const WordScrambleChip({
    required this.value,
    super.key,
    this.onPressed,
    this.dragPayload,
    this.selected = false,
    this.correct,
    this.contentScale = 1,
  });

  final String value;
  final VoidCallback? onPressed;
  final WordScrambleDragPayload? dragPayload;
  final bool selected;
  final bool? correct;
  final double contentScale;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final color = switch (correct) {
      true => SurfaceColor.success,
      false => SurfaceColor.error,
      null => selected ? SurfaceColor.primarySoft : SurfaceColor.baseline,
    };
    final textColor = correct == null && !selected
        ? tokens.colorTextBaseline
        : switch (color) {
            SurfaceColor.success => tokens.colorActionSuccess,
            SurfaceColor.error => tokens.colorActionError,
            SurfaceColor.primarySoft => tokens.colorPrimary,
            _ => tokens.colorTextBaseline,
          };

    Widget buildChip({
      required SurfaceColor color,
      required Color textColor,
      Offset feedbackOffset = Offset.zero,
    }) {
      final resolvedStyle = surfaceStyle.resolve(tokens, [
        color,
        SurfacePadding.xsm,
        SurfaceShape.roundedXxsm,
        SurfaceShadow.none,
      ]);
      final scaledStyle = scaledSurfaceStyle(resolvedStyle, contentScale)
          .copyWith(
            transform: feedbackOffset == Offset.zero
                ? null
                : Matrix4.translationValues(
                    ScaleHelper.getScaledValue(feedbackOffset.dx, contentScale),
                    ScaleHelper.getScaledValue(feedbackOffset.dy, contentScale),
                    0,
                  ),
          );

      return Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: onPressed,
          child: Surface(
            style: scaledStyle,
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
              ],
            ),
          ),
        ),
      );
    }

    final chip = buildChip(color: color, textColor: textColor);
    final feedback = buildChip(
      color: SurfaceColor.primarySoft,
      textColor: tokens.colorPrimary,
      feedbackOffset: Offset(-35.w, 25.h),
    );

    final dragPayload = this.dragPayload;
    if (dragPayload == null) return chip;

    return LongPressDraggable<WordScrambleDragPayload>(
      delay: const Duration(milliseconds: 100),
      data: dragPayload,
      feedback: feedback,
      childWhenDragging: chip,
      child: chip,
    );
  }
}
