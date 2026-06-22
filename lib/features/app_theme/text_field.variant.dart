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
    TextFieldStylePart.decoration({
      InputDecorationPart.enabledBorderParts({
        InputBorderPart.borderSideParts({BorderSidePart.color(borderColor)}),
      }),
      InputDecorationPart.focusedBorderParts({
        InputBorderPart.borderSideParts({BorderSidePart.color(borderColor)}),
      }),
      InputDecorationPart.disabledBorderParts({
        InputBorderPart.borderSideParts({BorderSidePart.color(borderColor)}),
      }),
      InputDecorationPart.errorBorderParts({
        InputBorderPart.borderSideParts({BorderSidePart.color(borderColor)}),
      }),
      InputDecorationPart.focusedErrorBorderParts({
        InputBorderPart.borderSideParts({BorderSidePart.color(borderColor)}),
      }),
    }),
  };
}

final textFieldStyle = VariantStyle.textFieldParts<AppTokens>(
  base: (tokens) => {
    TextFieldStylePart.cursorColor(tokens.colorPrimary),
    TextFieldStylePart.text({
      TextStylePart.color(tokens.colorTextBaseline),
      TextStylePart.fontWeight(tokens.fontWeightTextStrong),
    }),
    TextFieldStylePart.decoration({
      InputDecorationPart.filled(false),
      InputDecorationPart.border(InputBorder.none),
      InputDecorationPart.enabledBorder(InputBorder.none),
      InputDecorationPart.focusedBorder(InputBorder.none),
      InputDecorationPart.contentPadding(EdgeInsets.zero),
    }),
  },
  defaultVariants: const [
    TextFieldSize.normal,
    TextFieldFrame.none,
    TextFieldColor.baseline,
    TextFieldState.idle,
    TextFieldAlign.start,
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
        InputDecorationPart.border(InputBorder.none),
        InputDecorationPart.enabledBorder(InputBorder.none),
        InputDecorationPart.focusedBorder(InputBorder.none),
        InputDecorationPart.disabledBorder(InputBorder.none),
        InputDecorationPart.errorBorder(InputBorder.none),
        InputDecorationPart.focusedErrorBorder(InputBorder.none),
        InputDecorationPart.contentPadding(EdgeInsets.zero),
      }),
    },
    TextFieldFrame.outline: (tokens) => {
      TextFieldStylePart.decoration({
        InputDecorationPart.filled(true),
        InputDecorationPart.fillColor(tokens.colorScaffoldBackground),
        InputDecorationPart.contentPadding(EdgeInsets.all(16.r)),
        InputDecorationPart.borderParts({
          InputBorderPart.borderRadius(
            BorderRadius.circular(tokens.radiusSurfaceXsm.r),
          ),
          InputBorderPart.borderSideParts({
            BorderSidePart.width(tokens.borderWidthDefault.w),
          }),
        }),
      }),
    },
    TextFieldFrame.underline: (tokens) => {
      TextFieldStylePart.decoration({
        InputDecorationPart.contentPadding(
          EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
        ),
        InputDecorationPart.borderParts({
          InputBorderPart.borderRadius(BorderRadius.circular(12.r)),
          InputBorderPart.borderSideParts({BorderSidePart.width(4.w)}),
        }),
      }),
    },
    TextFieldColor.baseline: (tokens) => textFieldPalette(
      textColor: tokens.colorTextBaseline,
      cursorColor: tokens.colorTextBaseline,
      borderColor: tokens.colorTextBaseline,
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
      fillColor: tokens.colorActionSuccess.withValues(alpha: 0.12),
      borderColor: tokens.colorActionSuccess,
    ),
    TextFieldColor.error: (tokens) => textFieldPalette(
      textColor: tokens.colorActionError,
      cursorColor: tokens.colorActionError,
      fillColor: tokens.colorActionError.withValues(alpha: 0.12),
      borderColor: tokens.colorActionError,
    ),
    TextFieldState.idle: (_) => const <StylePart<TextFieldStyle>>{},
    TextFieldState.incorrect: (_) => {
      TextFieldStylePart.text({
        TextStylePart.decoration(TextDecoration.lineThrough),
      }),
    },
  },
);
