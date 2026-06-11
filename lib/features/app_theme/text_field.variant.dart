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
    TextFieldStylePart.cursorColor(tokens.primary),
    TextFieldStylePart.text({
      TextStylePart.color(tokens.textPrimary),
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
        InputDecorationPart.fillColor(tokens.backgroundPage),
        InputDecorationPart.contentPadding(EdgeInsets.all(16.r)),
        InputDecorationPart.enabledBorder(
          OutlineInputBorder(
            borderRadius: BorderRadius.circular(tokens.radiusSurfaceSm.r),
            borderSide: BorderSide(
              color: tokens.borderNeutralSubtle,
              width: tokens.borderWidthDefault.w,
            ),
          ),
        ),
        InputDecorationPart.focusedBorder(
          OutlineInputBorder(
            borderRadius: BorderRadius.circular(tokens.radiusSurfaceSm.r),
            borderSide: BorderSide(
              color: tokens.primary,
              width: tokens.borderWidthDefault.w,
            ),
          ),
        ),
      }),
    },
    TextFieldFrame.underline: (tokens) => {
      TextFieldStylePart.decoration({
        InputDecorationPart.filled(true),
        InputDecorationPart.fillColor(tokens.softGray),
        // InputDecorationPart.contentPadding(
        //   EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
        // ),
        InputDecorationPart.enabledBorder(
          UnderlineInputBorder(
            borderSide: BorderSide(color: tokens.primary, width: 4.w),
          ),
        ),
        InputDecorationPart.focusedBorder(
          UnderlineInputBorder(
            borderSide: BorderSide(color: tokens.primary, width: 4.w),
          ),
        ),
      }),
    },
    TextFieldTone.neutral: (tokens) => {
      TextFieldStylePart.text({TextStylePart.color(tokens.textPrimary)}),
    },
    TextFieldTone.brand: (tokens) => {
      TextFieldStylePart.cursorColor(tokens.primary),
      TextFieldStylePart.text({TextStylePart.color(tokens.primary)}),
    },
    TextFieldTone.success: (tokens) => {
      TextFieldStylePart.text({TextStylePart.color(tokens.actionSuccess)}),
      TextFieldStylePart.decoration({
        InputDecorationPart.fillColor(
          tokens.actionSuccess.withValues(alpha: 0.12),
        ),
        InputDecorationPart.enabledBorder(
          UnderlineInputBorder(
            borderSide: BorderSide(color: tokens.actionSuccess, width: 4.w),
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        InputDecorationPart.focusedBorder(
          UnderlineInputBorder(
            borderSide: BorderSide(color: tokens.actionSuccess, width: 4.w),
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        (theme) => theme.copyWith(
          disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: tokens.actionSuccess, width: 4.w),
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      }),
    },
    TextFieldTone.error: (tokens) => {
      TextFieldStylePart.text({TextStylePart.color(tokens.actionError)}),
      TextFieldStylePart.decoration({
        InputDecorationPart.fillColor(
          tokens.actionError.withValues(alpha: 0.12),
        ),
        InputDecorationPart.enabledBorder(
          UnderlineInputBorder(
            borderSide: BorderSide(color: tokens.actionError, width: 4.w),
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        InputDecorationPart.focusedBorder(
          UnderlineInputBorder(
            borderSide: BorderSide(color: tokens.actionError, width: 4.w),
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        (theme) => theme.copyWith(
          disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: tokens.actionError, width: 4.w),
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
