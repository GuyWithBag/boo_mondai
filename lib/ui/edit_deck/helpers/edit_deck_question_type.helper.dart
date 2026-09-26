import 'package:boo_mondai/lib.barrel.dart'
    show CardTemplateDirection, CardTemplateType;
import 'package:flutter/material.dart';

abstract final class EditDeckQuestionTypeHelper {
  static const visibleQuestionTypes = [
    CardTemplateType.flashcard,
    CardTemplateType.identification,
    CardTemplateType.multipleChoice,
    CardTemplateType.fillInTheBlanks,
    CardTemplateType.wordScramble,
    CardTemplateType.matchMadness,
  ];

  static String labelFor(CardTemplateType questionType) {
    return switch (questionType) {
      CardTemplateType.flashcard => 'Flashcard',
      CardTemplateType.identification => 'Identification',
      CardTemplateType.multipleChoice => 'Multiple Choice',
      CardTemplateType.fillInTheBlanks => 'Fill in Blanks',
      CardTemplateType.wordScramble => 'Word Scramble',
      CardTemplateType.matchMadness => 'Match Madness',
    };
  }

  static IconData iconFor(CardTemplateType questionType) {
    return switch (questionType) {
      CardTemplateType.flashcard => Icons.slideshow_outlined,
      CardTemplateType.identification => Icons.border_color_outlined,
      CardTemplateType.multipleChoice => Icons.list,
      CardTemplateType.fillInTheBlanks => Icons.draw,
      CardTemplateType.wordScramble => Icons.sort_by_alpha,
      CardTemplateType.matchMadness => Icons.shuffle,
    };
  }

  static bool isVisible(CardTemplateType questionType) {
    return visibleQuestionTypes.contains(questionType);
  }

  static CardTemplateDirection cardTypeForQuestionType(
    CardTemplateType questionType,
    CardTemplateDirection current,
  ) {
    return questionType == CardTemplateType.flashcard
        ? current
        : CardTemplateDirection.normal;
  }
}
