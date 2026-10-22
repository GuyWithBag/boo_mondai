
import 'package:boo_mondai/lib.barrel.dart' show StudyRating, AppTokens, StudyRatingColorSet, StudyRatingHelper;
import 'package:flutter/material.dart' show Color;

abstract class ThemeHelper {
  static StudyRatingColorSet getStudyRatingColorSet(
    AppTokens tokens,
    StudyRating rating,
  ) {
    return StudyRatingHelper.getColorSet(tokens, rating);
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
