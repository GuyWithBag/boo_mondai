import 'package:boo_mondai/lib.barrel.dart' show CardType, QuestionType;
import 'package:flutter/material.dart';

abstract final class EditDeckQuestionTypeHelper {
  static const visibleQuestionTypes = [
    QuestionType.flashcard,
    QuestionType.identification,
    QuestionType.multipleChoice,
    QuestionType.fillInTheBlanks,
    QuestionType.wordScramble,
    QuestionType.matchMadness,
  ];

  static String labelFor(QuestionType questionType) {
    return switch (questionType) {
      QuestionType.flashcard => 'Flashcard',
      QuestionType.identification => 'Identification',
      QuestionType.multipleChoice => 'Multiple Choice',
      QuestionType.fillInTheBlanks => 'Fill in Blanks',
      QuestionType.wordScramble => 'Word Scramble',
      QuestionType.matchMadness => 'Match Madness',
    };
  }

  static IconData iconFor(QuestionType questionType) {
    return switch (questionType) {
      QuestionType.flashcard => Icons.slideshow_outlined,
      QuestionType.identification => Icons.border_color_outlined,
      QuestionType.multipleChoice => Icons.list,
      QuestionType.fillInTheBlanks => Icons.draw,
      QuestionType.wordScramble => Icons.sort_by_alpha,
      QuestionType.matchMadness => Icons.shuffle,
    };
  }

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
