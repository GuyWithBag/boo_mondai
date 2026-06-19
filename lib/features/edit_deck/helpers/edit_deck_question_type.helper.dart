import 'package:boo_mondai/lib.barrel.dart' show CardType, QuestionType;

abstract final class EditDeckQuestionTypeHelper {
  static const visibleQuestionTypes = [
    QuestionType.flashcard,
    QuestionType.multipleChoice,
    QuestionType.fillInTheBlanks,
    QuestionType.matchMadness,
  ];

  static bool isVisible(QuestionType questionType) {
    return visibleQuestionTypes.contains(questionType);
  }

  static int selectedFormatIndex(QuestionType questionType) {
    if (!isVisible(questionType)) return 0;
    return visibleQuestionTypes.indexOf(questionType);
  }

  static QuestionType questionTypeAt(int index) {
    return visibleQuestionTypes[index];
  }

  static CardType cardTypeForQuestionType(
    QuestionType questionType,
    CardType current,
  ) {
    return questionType == QuestionType.flashcard ? current : CardType.normal;
  }
}
