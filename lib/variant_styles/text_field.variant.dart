import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:theme_variants/theme_variants.dart';

enum AppTextFieldSize { labelLarge, bodyLarge }

enum AppTextFieldFrame { none, outline, underline }

enum AppTextFieldTone { neutral, brand, success, error }

enum AppTextFieldState { idle, incorrect }

final appTextFieldStyle = VariantStyle.textFieldParts<AppTokens>(
  base: (tokens) => {
    TextFieldStylePart.textAlign(TextAlign.start),
    (style) => style.copyWith(cursorColor: tokens.primary),
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
    AppTextFieldSize.labelLarge,
    AppTextFieldFrame.none,
    AppTextFieldTone.neutral,
    AppTextFieldState.idle,
  ],
  variants: {
    AppTextFieldSize.labelLarge: (tokens) => {
      TextFieldStylePart.text({
        TextStylePart.fontSize(tokens.textSizeLabelLarge.sp),
        TextStylePart.fontWeight(tokens.fontWeightTextHeavy),
        TextStylePart.height(tokens.lineHeightTextTitle),
      }),
    },
    AppTextFieldSize.bodyLarge: (tokens) => {
      TextFieldStylePart.text({
        TextStylePart.fontSize(tokens.textSizeBodyLarge.sp),
        TextStylePart.fontWeight(tokens.fontWeightTextStrong),
        TextStylePart.height(tokens.lineHeightFieldDisplay),
      }),
    },
    AppTextFieldFrame.none: (_) => {
      TextFieldStylePart.decoration({
        InputDecorationPart.border(InputBorder.none),
        InputDecorationPart.enabledBorder(InputBorder.none),
        InputDecorationPart.focusedBorder(InputBorder.none),
        InputDecorationPart.contentPadding(EdgeInsets.zero),
      }),
    },
    AppTextFieldFrame.outline: (tokens) => {
      TextFieldStylePart.decoration({
        InputDecorationPart.filled(true),
        InputDecorationPart.fillColor(tokens.backgroundPage),
        InputDecorationPart.contentPadding(const EdgeInsets.all(16)),
        InputDecorationPart.enabledBorder(
          OutlineInputBorder(
            borderRadius: BorderRadius.circular(tokens.radius2xl),
            borderSide: BorderSide(
              color: tokens.borderNeutralSubtle,
              width: tokens.borderWidthDefault,
            ),
          ),
        ),
        InputDecorationPart.focusedBorder(
          OutlineInputBorder(
            borderRadius: BorderRadius.circular(tokens.radius2xl),
            borderSide: BorderSide(
              color: tokens.primary,
              width: tokens.borderWidthDefault,
            ),
          ),
        ),
      }),
    },
    AppTextFieldFrame.underline: (tokens) => {
      TextFieldStylePart.textAlign(TextAlign.center),
      TextFieldStylePart.decoration({
        InputDecorationPart.filled(true),
        InputDecorationPart.fillColor(tokens.softGray),
        InputDecorationPart.contentPadding(
          EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
        ),
        InputDecorationPart.enabledBorder(
          UnderlineInputBorder(
            borderSide: BorderSide(color: tokens.primary, width: 4),
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        InputDecorationPart.focusedBorder(
          UnderlineInputBorder(
            borderSide: BorderSide(color: tokens.primary, width: 4),
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      }),
    },
    AppTextFieldTone.neutral: (tokens) => {
      TextFieldStylePart.text({TextStylePart.color(tokens.textPrimary)}),
    },
    AppTextFieldTone.brand: (tokens) => {
      (style) => style.copyWith(cursorColor: tokens.primary),
      TextFieldStylePart.text({TextStylePart.color(tokens.primary)}),
    },
    AppTextFieldTone.success: (tokens) => {
      TextFieldStylePart.text({TextStylePart.color(tokens.actionSuccess)}),
      TextFieldStylePart.decoration({
        InputDecorationPart.fillColor(
          tokens.actionSuccess.withValues(alpha: 0.12),
        ),
        InputDecorationPart.enabledBorder(
          UnderlineInputBorder(
            borderSide: BorderSide(color: tokens.actionSuccess, width: 4),
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        InputDecorationPart.focusedBorder(
          UnderlineInputBorder(
            borderSide: BorderSide(color: tokens.actionSuccess, width: 4),
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        (theme) => theme.copyWith(
          disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: tokens.actionSuccess, width: 4),
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      }),
    },
    AppTextFieldTone.error: (tokens) => {
      TextFieldStylePart.text({TextStylePart.color(tokens.actionError)}),
      TextFieldStylePart.decoration({
        InputDecorationPart.fillColor(
          tokens.actionError.withValues(alpha: 0.12),
        ),
        InputDecorationPart.enabledBorder(
          UnderlineInputBorder(
            borderSide: BorderSide(color: tokens.actionError, width: 4),
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        InputDecorationPart.focusedBorder(
          UnderlineInputBorder(
            borderSide: BorderSide(color: tokens.actionError, width: 4),
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        (theme) => theme.copyWith(
          disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: tokens.actionError, width: 4),
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      }),
    },
    AppTextFieldState.idle: (_) => const <StylePart<TextFieldStyle>>{},
    AppTextFieldState.incorrect: (_) => {
      TextFieldStylePart.text({
        TextStylePart.decoration(TextDecoration.lineThrough),
      }),
    },
  },
);
