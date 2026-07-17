import 'package:boo_mondai/lib.barrel.dart'
    show AppTokens, StudyRating, StudyRatingColorSet;
import 'package:flutter/material.dart' show Color;

abstract class ThemeHelper {
  static StudyRatingColorSet getStudyRatingColorSet(
    AppTokens tokens,
    StudyRating rating,
  ) {
    return switch (rating) {
      StudyRating.incorrect => (
        name: 'Incorrect',
        colorText: tokens.colorRatingAgainText,
        colorBackground: tokens.colorRatingAgainBackground,
        colorBorder: tokens.colorRatingAgainBorder,
      ),
      StudyRating.again => (
        name: 'Again',
        colorText: tokens.colorRatingAgainText,
        colorBackground: tokens.colorRatingAgainBackground,
        colorBorder: tokens.colorRatingAgainBorder,
      ),
      StudyRating.hard => (
        name: 'Hard',
        colorText: tokens.colorRatingHardText,
        colorBackground: tokens.colorRatingHardBackground,
        colorBorder: tokens.colorRatingHardBorder,
      ),
      StudyRating.good => (
        name: 'Good',
        colorText: tokens.colorRatingGoodText,
        colorBackground: tokens.colorRatingGoodBackground,
        colorBorder: tokens.colorRatingGoodBorder,
      ),
      StudyRating.easy => (
        name: 'Easy',
        colorText: tokens.colorRatingEasyText,
        colorBackground: tokens.colorRatingEasyBackground,
        colorBorder: tokens.colorRatingEasyBorder,
      ),
    };
  }

  static Color getColorTextByStudyRating(AppTokens tokens, StudyRating rating) {
    return getStudyRatingColorSet(tokens, rating).colorText;
  }

  static Color getColorBackgroundByStudyRating(
    AppTokens tokens,
    StudyRating rating,
  ) {
    return getStudyRatingColorSet(tokens, rating).colorBackground;
  }

  static Color getColorBorderByStudyRating(
    AppTokens tokens,
    StudyRating rating,
  ) {
    return getStudyRatingColorSet(tokens, rating).colorBorder;
  }
}
