import 'package:boo_mondai/lib.barrel.dart' show AppTokens;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

enum TextFieldSize { labelLarge, bodyLarge, normal }

enum TextFieldFrame { none, outline, underline }

enum TextFieldColor { baseline, brand, success, error, transparentBg }

enum TextFieldState { idle, incorrect }

enum TextFieldAlign { start, center }

Set<StylePart<TextFieldStyle>> textFieldPalette({
  required Color textColor,
  required Color cursorColor,
  required Color borderColor,
  Color? fillColor,
}) {
  return {
    TextFieldStylePart.cursorColor(cursorColor),
    TextFieldStylePart.text({TextStylePart.color(textColor)}),
    if (fillColor != null)
      TextFieldStylePart.decoration({InputDecorationPart.fillColor(fillColor)}),
    TextFieldStylePart.decoration(_borderColorDecorationParts(borderColor)),
  };
}

Set<StylePart<InputDecorationThemeData>> _outlineBorderDecorationParts(
  AppTokens tokens,
) {
  final parts = _outlineBorderParts(tokens);
  return {
    InputDecorationPart.borderParts(parts),
    InputDecorationPart.enabledBorderParts(parts),
    InputDecorationPart.focusedBorderParts(parts),
    InputDecorationPart.disabledBorderParts(parts),
    InputDecorationPart.errorBorderParts(parts),
    InputDecorationPart.focusedErrorBorderParts(parts),
  };
}

Set<StylePart<InputBorder>> _outlineBorderParts(AppTokens tokens) {
  return {
    InputBorderPart.width(tokens.borderWidthDefault.w),
    InputBorderPart.borderRadius(
      BorderRadius.circular(tokens.radiusSurfaceXsm.r),
    ),
    InputBorderPart.outline(),
  };
}

Set<StylePart<InputDecorationThemeData>> _underlineBorderDecorationParts(
  AppTokens tokens,
) {
  final parts = _underlineBorderParts(tokens);
  return {
    InputDecorationPart.borderParts(parts),
    InputDecorationPart.enabledBorderParts(parts),
    InputDecorationPart.focusedBorderParts(parts),
    InputDecorationPart.disabledBorderParts(parts),
    InputDecorationPart.errorBorderParts(parts),
    InputDecorationPart.focusedErrorBorderParts(parts),
  };
}

Set<StylePart<InputBorder>> _underlineBorderParts(AppTokens tokens) {
  return {
    InputBorderPart.width(tokens.borderWidthDefault.w),
    InputBorderPart.underline(),
  };
}

Set<StylePart<InputDecorationThemeData>> _noBorderDecorationParts() {
  final parts = {InputBorderPart.none()};
  return {
    InputDecorationPart.borderParts(parts),
    InputDecorationPart.enabledBorderParts(parts),
    InputDecorationPart.focusedBorderParts(parts),
    InputDecorationPart.disabledBorderParts(parts),
    InputDecorationPart.errorBorderParts(parts),
    InputDecorationPart.focusedErrorBorderParts(parts),
  };
}

Set<StylePart<InputDecorationThemeData>> _borderColorDecorationParts(
  Color borderColor,
) {
  final parts = {InputBorderPart.color(borderColor)};
  return {
    InputDecorationPart.borderParts(parts),
    InputDecorationPart.enabledBorderParts(parts),
    InputDecorationPart.focusedBorderParts(parts),
    InputDecorationPart.disabledBorderParts(parts),
    InputDecorationPart.errorBorderParts(parts),
    InputDecorationPart.focusedErrorBorderParts(parts),
  };
}

final textFieldStyle = VariantStyle.textFieldParts<AppTokens>(
  base: (tokens) => {
    TextFieldStylePart.cursorColor(tokens.colorTextBaseline),
    TextFieldStylePart.text({
      TextStylePart.color(tokens.colorTextBaseline),
      TextStylePart.fontWeight(tokens.fontWeightTextStrong),
    }),
  },
  defaultVariants: const [
    TextFieldSize.normal,
    TextFieldFrame.outline,
    TextFieldState.idle,
    TextFieldAlign.start,
    TextFieldColor.baseline,
  ],
  variants: {
    TextFieldAlign.start: (_) => {
      TextFieldStylePart.textAlign(TextAlign.start),
    },
    TextFieldAlign.center: (_) => {
      TextFieldStylePart.textAlign(TextAlign.center),
    },
    TextFieldSize.labelLarge: (tokens) => {
      TextFieldStylePart.text({
        TextStylePart.fontSize(tokens.textSizeLabelLarge.sp),
        TextStylePart.fontWeight(tokens.fontWeightTextHeavy),
        TextStylePart.height(tokens.lineHeightTextTitle),
      }),
    },
    TextFieldSize.bodyLarge: (tokens) => {
      TextFieldStylePart.text({
        TextStylePart.fontSize(tokens.textSizeBodyLarge.sp),
        TextStylePart.fontWeight(tokens.fontWeightTextStrong),
        TextStylePart.height(tokens.lineHeightFieldDisplay),
      }),
    },
    TextFieldSize.normal: (tokens) => {
      TextFieldStylePart.text({
        TextStylePart.fontSize(tokens.textSizeLabel.sp),
      }),
    },
    TextFieldFrame.none: (_) => {
      TextFieldStylePart.decoration({
        ..._noBorderDecorationParts(),
        InputDecorationPart.contentPadding(EdgeInsets.zero),
      }),
    },
    TextFieldFrame.outline: (tokens) => {
      TextFieldStylePart.decoration({
        InputDecorationPart.filled(true),
        InputDecorationPart.fillColor(tokens.colorScaffoldBackground),
        ..._outlineBorderDecorationParts(tokens),
      }),
    },
    TextFieldFrame.underline: (tokens) => {
      TextFieldStylePart.decoration({
        InputDecorationPart.contentPadding(
          EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
        ),
        ..._underlineBorderDecorationParts(tokens),
      }),
    },
    TextFieldColor.baseline: (tokens) => textFieldPalette(
      textColor: tokens.colorTextBaseline,
      cursorColor: tokens.colorTextBaseline,
      borderColor: tokens.colorBorderNeutralSubtle,
    ),
    TextFieldColor.transparentBg: (tokens) => textFieldPalette(
      textColor: tokens.colorTextBaseline,
      cursorColor: tokens.colorTextBaseline,
      borderColor: tokens.colorTextBaseline,
      fillColor: Colors.transparent,
    ),
    TextFieldColor.brand: (tokens) => textFieldPalette(
      textColor: tokens.colorPrimary,
      cursorColor: tokens.colorPrimary,
      borderColor: tokens.colorPrimary,
    ),
    TextFieldColor.success: (tokens) => textFieldPalette(
      textColor: tokens.colorActionSuccess,
      cursorColor: tokens.colorActionSuccess,
      borderColor: tokens.colorActionSuccess,
      fillColor: tokens.colorActionSuccess.withValues(alpha: 0.12),
    ),
    TextFieldColor.error: (tokens) => textFieldPalette(
      textColor: tokens.colorActionError,
      cursorColor: tokens.colorActionError,
      borderColor: tokens.colorActionError,
      fillColor: tokens.colorActionError.withValues(alpha: 0.12),
    ),
    TextFieldState.idle: (_) => const <StylePart<TextFieldStyle>>{},
    TextFieldState.incorrect: (_) => {
      TextFieldStylePart.text({
        TextStylePart.decoration(TextDecoration.lineThrough),
      }),
    },
  },
);
