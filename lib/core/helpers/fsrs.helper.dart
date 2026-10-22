import 'package:boo_mondai/lib.barrel.dart' show StudyRating;
import 'package:fsrs/fsrs.dart' as fsrs show Rating;

abstract final class FsrsHelper {
  static fsrs.Rating studyRatingToFSRSRating(StudyRating type) {
    return switch (type) {
      StudyRating.again => fsrs.Rating.again,
      StudyRating.hard => fsrs.Rating.hard,
      StudyRating.good => fsrs.Rating.good,
      StudyRating.easy => fsrs.Rating.easy,
      StudyRating.incorrect => fsrs.Rating.again,
    };
  }

  static StudyRating fromFSRSRatingToStudyRating(fsrs.Rating rating) {
    switch (rating) {
      case fsrs.Rating.again:
        return StudyRating.again;
      case fsrs.Rating.hard:
        return StudyRating.hard;
      case fsrs.Rating.good:
        return StudyRating.good;
      case fsrs.Rating.easy:
        return StudyRating.easy;
    }
  }
}
