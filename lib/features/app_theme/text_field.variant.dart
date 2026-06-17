import 'package:boo_mondai/lib.barrel.dart' show AppTokens;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

enum TextFieldSize { labelLarge, bodyLarge, normal }

enum TextFieldFrame { none, outline, underline }

enum TextFieldTone { neutral, brand, success, error }

enum TextFieldState { idle, incorrect }

enum TextFieldAlign { start, center }

// enum TextFieldShape { rounded, sharp }

final appTextFieldStyle = VariantStyle.textFieldParts<AppTokens>(
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
    TextFieldTone.neutral,
    TextFieldState.idle,
    TextFieldAlign.start,
    // TextFieldShape.rounded
  ],
  variants: {
    // TextFieldShape.rounded: (tokens) => {},
    TextFieldAlign.start: (tokens) => {
      TextFieldStylePart.textAlign(TextAlign.start),
    },
    TextFieldAlign.center: (tokens) => {
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
        InputDecorationPart.contentPadding(EdgeInsets.zero),
      }),
    },
    TextFieldFrame.outline: (tokens) => {
      TextFieldStylePart.decoration({
        InputDecorationPart.filled(true),
        InputDecorationPart.fillColor(tokens.colorScaffoldBackground),
        InputDecorationPart.contentPadding(EdgeInsets.all(16.r)),
        InputDecorationPart.enabledBorder(
          OutlineInputBorder(
            borderRadius: BorderRadius.circular(tokens.radiusSurfaceSm.r),
            borderSide: BorderSide(
              color: tokens.colorBorderNeutralSubtle,
              width: tokens.borderWidthDefault.w,
            ),
          ),
        ),
        InputDecorationPart.focusedBorder(
          OutlineInputBorder(
            borderRadius: BorderRadius.circular(tokens.radiusSurfaceSm.r),
            borderSide: BorderSide(
              color: tokens.colorPrimary,
              width: tokens.borderWidthDefault.w,
            ),
          ),
        ),
      }),
    },
    TextFieldFrame.underline: (tokens) => {
      TextFieldStylePart.decoration({
        InputDecorationPart.filled(true),
        InputDecorationPart.fillColor(tokens.colorMuted),
        // InputDecorationPart.contentPadding(
        //   EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
        // ),
        InputDecorationPart.enabledBorder(
          UnderlineInputBorder(
            borderSide: BorderSide(color: tokens.colorPrimary, width: 4.w),
          ),
        ),
        InputDecorationPart.focusedBorder(
          UnderlineInputBorder(
            borderSide: BorderSide(color: tokens.colorPrimary, width: 4.w),
          ),
        ),
      }),
    },
    TextFieldTone.neutral: (tokens) => {
      TextFieldStylePart.text({TextStylePart.color(tokens.colorTextBaseline)}),
    },
    TextFieldTone.brand: (tokens) => {
      TextFieldStylePart.cursorColor(tokens.colorPrimary),
      TextFieldStylePart.text({TextStylePart.color(tokens.colorPrimary)}),
    },
    TextFieldTone.success: (tokens) => {
      TextFieldStylePart.text({TextStylePart.color(tokens.colorActionSuccess)}),
      TextFieldStylePart.decoration({
        InputDecorationPart.fillColor(
          tokens.colorActionSuccess.withValues(alpha: 0.12),
        ),
        InputDecorationPart.enabledBorder(
          UnderlineInputBorder(
            borderSide: BorderSide(
              color: tokens.colorActionSuccess,
              width: 4.w,
            ),
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        InputDecorationPart.focusedBorder(
          UnderlineInputBorder(
            borderSide: BorderSide(
              color: tokens.colorActionSuccess,
              width: 4.w,
            ),
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        (theme) => theme.copyWith(
          disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: tokens.colorActionSuccess,
              width: 4.w,
            ),
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      }),
    },
    TextFieldTone.error: (tokens) => {
      TextFieldStylePart.text({TextStylePart.color(tokens.colorActionError)}),
      TextFieldStylePart.decoration({
        InputDecorationPart.fillColor(
          tokens.colorActionError.withValues(alpha: 0.12),
        ),
        InputDecorationPart.enabledBorder(
          UnderlineInputBorder(
            borderSide: BorderSide(color: tokens.colorActionError, width: 4.w),
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        InputDecorationPart.focusedBorder(
          UnderlineInputBorder(
            borderSide: BorderSide(color: tokens.colorActionError, width: 4.w),
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        (theme) => theme.copyWith(
          disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: tokens.colorActionError, width: 4.w),
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      }),
    },
    TextFieldState.idle: (_) => const <StylePart<TextFieldStyle>>{},
    TextFieldState.incorrect: (_) => {
      TextFieldStylePart.text({
        TextStylePart.decoration(TextDecoration.lineThrough),
      }),
    },
  },
);
