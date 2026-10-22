
import 'package:boo_mondai/lib.barrel.dart' show StudyRating, StudyRatingColorSet, AppTokens, AppMediaPack, MediaSelector;

abstract class StudyRatingHelper {
  static StudyRatingColorSet getColorSet(AppTokens tokens, StudyRating rating) {
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

  static MediaSelector<AppMediaPack> getSound(StudyRating rating) {
    return switch (rating) {
      StudyRating.incorrect => (media) => media.studySessionIncorrectSound,
      StudyRating.again => (media) => media.studySessionAgainSound,
      StudyRating.hard => (media) => media.studySessionHardSound,
      StudyRating.good => (media) => media.studySessionGoodSound,
      StudyRating.easy => (media) => media.studySessionEasySound,
    };
  }
}
