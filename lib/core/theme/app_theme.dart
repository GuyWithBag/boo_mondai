import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

import 'app_tokens.dart';

TextStyle _textStyle(
  AppTokens tokens, {
  required Color color,
  required double size,
  required FontWeight weight,
  required double height,
  double? letterSpacing,
}) {
  return TextStyle(
    color: color,
    fontFamily: tokens.fontFamily,
    fontSize: size,
    fontWeight: weight,
    height: height,
    letterSpacing: letterSpacing,
  );
}

TextTheme _textTheme(AppTokens tokens) {
  final displayStyle = _textStyle(
    tokens,
    color: tokens.textPrimary,
    size: tokens.textSizeCardFront,
    weight: tokens.fontWeightTextHeavy,
    height: tokens.lineHeightTextDisplay,
  );
  final headlineStyle = _textStyle(
    tokens,
    color: tokens.textPrimary,
    size: tokens.textSizeBodyLarge,
    weight: tokens.fontWeightTextHeavy,
    height: tokens.lineHeightFieldDisplay,
  );
  final titleStyle = _textStyle(
    tokens,
    color: tokens.textPrimary,
    size: tokens.textSizeHeader,
    weight: tokens.fontWeightTextHeavy,
    height: tokens.lineHeightTextDisplay,
  );
  final bodyLargeStyle = _textStyle(
    tokens,
    color: tokens.textPrimary,
    size: tokens.textSizeLabelLarge,
    weight: tokens.fontWeightTextBody,
    height: tokens.lineHeightTextBody,
  );
  final bodyStyle = _textStyle(
    tokens,
    color: tokens.textPrimary,
    size: tokens.textSizeLabel,
    weight: tokens.fontWeightTextBody,
    height: tokens.lineHeightTextBody,
  );
  final labelStyle = _textStyle(
    tokens,
    color: tokens.textPrimary,
    size: tokens.textSizeLabel,
    weight: tokens.fontWeightTextStrong,
    height: tokens.lineHeightTactile,
  );
  final labelSmallStyle = _textStyle(
    tokens,
    color: tokens.textSecondary,
    size: tokens.textSizeLabelSmall,
    weight: tokens.fontWeightTextStrong,
    height: tokens.lineHeightTactile,
    letterSpacing: tokens.letterSpacingTextEyebrow,
  );

  return TextTheme(
    displayLarge: displayStyle,
    displayMedium: displayStyle.copyWith(
      fontSize: tokens.textSizeCardBackFront,
    ),
    displaySmall: displayStyle.copyWith(
      fontSize: tokens.textSizeCardBackContent,
    ),
    headlineLarge: headlineStyle,
    headlineMedium: headlineStyle.copyWith(fontSize: tokens.textSizeHeader),
    headlineSmall: headlineStyle.copyWith(fontSize: tokens.textSizeLabelLarge),
    titleLarge: titleStyle,
    titleMedium: titleStyle.copyWith(fontSize: tokens.textSizeLabelLarge),
    titleSmall: titleStyle.copyWith(fontSize: tokens.textSizeLabel),
    bodyLarge: bodyLargeStyle,
    bodyMedium: bodyStyle,
    bodySmall: bodyStyle.copyWith(
      color: tokens.textSecondary,
      fontSize: tokens.textSizeLabelSmall,
    ),
    labelLarge: labelStyle,
    labelMedium: labelStyle.copyWith(fontSize: tokens.textSizeLabelSmall),
    labelSmall: labelSmallStyle,
  );
}

/// Builds `ThemeData` from typed app tokens for a given [brightness].
ThemeData buildAppThemeData(AppTokens tokens, Brightness brightness) {
  final scheme = ColorScheme.fromSeed(
    seedColor: tokens.primary,
    brightness: brightness,
    primary: tokens.primary,
    surface: tokens.backgroundSurface,
    error: tokens.actionError,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor: tokens.backgroundPage,
    fontFamily: tokens.fontFamily,
    appBarTheme: AppBarTheme(
      backgroundColor: tokens.backgroundSurface,
      foregroundColor: tokens.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      toolbarHeight: 88,
      titleSpacing: 0,
      shape: Border(
        bottom: BorderSide(
          color: tokens.borderNeutralSubtle,
          width: tokens.borderWidthDefault,
        ),
      ),
    ),
    chipTheme: ChipThemeData(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      labelPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      side: BorderSide(
        color: tokens.borderNeutralSubtle,
        width: tokens.borderWidthDefault,
      ),
      backgroundColor: tokens.backgroundSurface,
      selectedColor: tokens.primarySoft,
      disabledColor: tokens.softGray,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      pressElevation: 0,
      labelStyle: TextStyle(
        color: tokens.textPrimary,
        fontSize: tokens.textSizeLabelSmall,
        fontWeight: tokens.fontWeightTextHeavy,
        letterSpacing: tokens.letterSpacingTextEyebrow,
      ),
      secondaryLabelStyle: TextStyle(
        color: tokens.primary,
        fontSize: tokens.textSizeLabelSmall,
        fontWeight: tokens.fontWeightTextBody,
        letterSpacing: tokens.letterSpacingTextEyebrow,
      ),
      iconTheme: IconThemeData(
        color: tokens.textPrimary,
        size: tokens.sizeIconMd,
      ),
      checkmarkColor: tokens.primary,
      deleteIconColor: tokens.textSecondary,
      showCheckmark: false,
    ),
    textTheme: _textTheme(tokens),
    dividerTheme: DividerThemeData(
      color: tokens.borderNeutralSubtle,
      thickness: tokens.borderWidthDefault,
    ),
    textSelectionTheme: TextSelectionThemeData(
      selectionColor: tokens.primary.withValues(alpha: 0.22),
      cursorColor: tokens.primary,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: InputBorder.none,
      hintStyle: TextStyle(
        color: tokens.textMuted.withValues(alpha: 0.65),
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}

final booMondaiLight = ThemeVariant<AppTokens>(
  themePresetId: 'boomondai',
  brightness: ThemeVariantBrightness.light,
  themeData: buildAppThemeData(defaultLight, Brightness.light),
  tokens: defaultLight,
);

final booMondaiDark = ThemeVariant<AppTokens>(
  themePresetId: 'boomondai',
  brightness: ThemeVariantBrightness.dark,
  themeData: buildAppThemeData(defaultDark, Brightness.dark),
  tokens: defaultDark,
);

final booMondaiPreset = LightDarkThemePreset<AppTokens>(
  id: 'boomondai',
  name: 'BooMondai',
  light: booMondaiLight,
  dark: booMondaiDark,
);

final appThemeRegistry = ThemeVariantRegistry<AppTokens>(
  presets: [booMondaiPreset],
);

ThemeVariantsController<AppTokens> createAppThemeController() {
  return ThemeVariantsController<AppTokens>(
    registry: appThemeRegistry,
    lightThemeId: 'boomondai',
    darkThemeId: 'boomondai',
    themeMode: ThemeMode.dark,
  );
}
