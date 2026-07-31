import 'package:boo_mondai/core/helpers/study_rating.helper.dart';
import 'package:boo_mondai/core/models/study_rating_color_set.dart';
import 'package:boo_mondai/core/theme/app_tokens.model.dart';
import 'package:boo_mondai/features/study_session/models/study_rating.dto.dart';
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
