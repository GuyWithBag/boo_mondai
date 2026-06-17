import 'package:boo_mondai/lib.barrel.dart' show AppTokens;
import 'package:flutter/material.dart'
    show
        InputDecorationTheme,
        InputBorder,
        TextStyle,
        Color,
        FontWeight,
        TextTheme,
        ThemeData,
        Brightness,
        EdgeInsets,
        ColorScheme,
        Colors,
        BorderSide,
        Border,
        AppBarTheme,
        BorderRadius,
        RoundedRectangleBorder,
        IconThemeData,
        ChipThemeData,
        DividerThemeData,
        TextSelectionThemeData;

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
    color: tokens.colorTextBaseline,
    size: tokens.studyCardTextSizeFront,
    weight: tokens.fontWeightTextHeavy,
    height: tokens.lineHeightTextDisplay,
  );
  final headlineStyle = _textStyle(
    tokens,
    color: tokens.colorTextBaseline,
    size: tokens.textSizeBodyLarge,
    weight: tokens.fontWeightTextHeavy,
    height: tokens.lineHeightFieldDisplay,
  );
  final titleStyle = _textStyle(
    tokens,
    color: tokens.colorTextBaseline,
    size: tokens.textSizeHeader,
    weight: tokens.fontWeightTextHeavy,
    height: tokens.lineHeightTextDisplay,
  );
  final bodyLargeStyle = _textStyle(
    tokens,
    color: tokens.colorTextBaseline,
    size: tokens.textSizeLabelLarge,
    weight: tokens.fontWeightTextBody,
    height: tokens.lineHeightTextBody,
  );
  final bodyStyle = _textStyle(
    tokens,
    color: tokens.colorTextBaseline,
    size: tokens.textSizeLabel,
    weight: tokens.fontWeightTextBody,
    height: tokens.lineHeightTextBody,
  );
  final labelStyle = _textStyle(
    tokens,
    color: tokens.colorTextBaseline,
    size: tokens.textSizeLabel,
    weight: tokens.fontWeightTextStrong,
    height: tokens.lineHeightButton,
  );
  final labelSmallStyle = _textStyle(
    tokens,
    color: tokens.colorTextSecondary,
    size: tokens.textSizeLabelSmall,
    weight: tokens.fontWeightTextStrong,
    height: tokens.lineHeightButton,
    letterSpacing: tokens.letterSpacingTextEyebrow,
  );

  return TextTheme(
    displayLarge: displayStyle,
    displayMedium: displayStyle.copyWith(
      fontSize: tokens.studyCardTextSizeBack,
    ),
    displaySmall: displayStyle.copyWith(
      fontSize: tokens.studyCardTextSizeBackContent,
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
      color: tokens.colorTextSecondary,
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
    seedColor: tokens.colorPrimary,
    brightness: brightness,
    primary: tokens.colorPrimary,
    surface: tokens.colorSurfaceBackground,
    error: tokens.colorActionError,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor: tokens.colorScaffoldBackground,
    fontFamily: tokens.fontFamily,
    appBarTheme: AppBarTheme(
      backgroundColor: tokens.colorSurfaceBackground,
      foregroundColor: tokens.colorTextBaseline,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      toolbarHeight: 88,
      titleSpacing: 0,
      shape: Border(
        bottom: BorderSide(
          color: tokens.colorBorderNeutralSubtle,
          width: tokens.borderWidthDefault,
        ),
      ),
    ),
    chipTheme: ChipThemeData(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      labelPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      side: BorderSide(
        color: tokens.colorBorderNeutralSubtle,
        width: tokens.borderWidthDefault,
      ),
      backgroundColor: tokens.colorSurfaceBackground,
      selectedColor: tokens.colorPrimarySoft,
      disabledColor: tokens.colorMuted,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      pressElevation: 0,
      labelStyle: TextStyle(
        color: tokens.colorTextBaseline,
        fontSize: tokens.textSizeLabelSmall,
        fontWeight: tokens.fontWeightTextHeavy,
        letterSpacing: tokens.letterSpacingTextEyebrow,
      ),
      secondaryLabelStyle: TextStyle(
        color: tokens.colorPrimary,
        fontSize: tokens.textSizeLabelSmall,
        fontWeight: tokens.fontWeightTextBody,
        letterSpacing: tokens.letterSpacingTextEyebrow,
      ),
      iconTheme: IconThemeData(
        color: tokens.colorTextBaseline,
        size: tokens.sizeIconMd,
      ),
      checkmarkColor: tokens.colorPrimary,
      deleteIconColor: tokens.colorTextSecondary,
      showCheckmark: false,
    ),
    textTheme: _textTheme(tokens),
    dividerTheme: DividerThemeData(
      color: tokens.colorBorderNeutralSubtle,
      thickness: tokens.borderWidthDefault,
    ),
    textSelectionTheme: TextSelectionThemeData(
      selectionColor: tokens.colorPrimary.withValues(alpha: 0.22),
      cursorColor: tokens.colorPrimary,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: InputBorder.none,
      hintStyle: TextStyle(
        color: tokens.colorTextMuted.withValues(alpha: 0.65),
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}
