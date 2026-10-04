import 'package:boo_mondai/lib.barrel.dart' show StudyRating;

final class ViewStudySessionResultAnswer {
  const ViewStudySessionResultAnswer({
    required this.answerValue,
    required this.type,
  });

  final String answerValue;
  final StudyRating type;
}
