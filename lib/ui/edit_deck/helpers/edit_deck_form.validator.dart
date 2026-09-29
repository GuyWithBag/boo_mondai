import 'package:boo_mondai/features/features.barrel.dart';

abstract final class EditDeckFormValidator {
  static String? prompt(String? value) {
    return _required(value, 'Enter a prompt');
  }

  static String? answer(String? value) {
    return _required(value, 'Enter an answer');
  }

  static String? identificationAnswers(List<IdentificationAnswerKey>? answers) {
    if (answers == null || answers.isEmpty) {
      return 'Add at least one accepted answer';
    }
    if (!answers.any((answer) => answer.value.trim().isNotEmpty)) {
      return 'Add at least one accepted answer';
    }
    return null;
  }

  static String? multipleChoiceOptions(List<MultipleChoiceOption>? options) {
    if (options == null || options.length < 2) {
      return 'Add at least two answer options';
    }
    if (options.any((option) => option.optionText.trim().isEmpty)) {
      return 'Complete every answer option';
    }
    if (!options.any((option) => option.isCorrect)) {
      return 'Select a correct answer';
    }
    return null;
  }

  static String? fillInTheBlankAnswers(List<String>? answers) {
    if (answers == null || answers.isEmpty) {
      return 'Create at least one blank';
    }
    if (!answers.any((answer) => answer.trim().isNotEmpty)) {
      return 'Create at least one blank';
    }
    return null;
  }

  static String? matchingPairs(List<MatchingTypeValue>? values) {
    if (values == null || values.length < 2) {
      return 'Add at least two matching values';
    }
    if (values.length.isOdd) {
      return 'Every matching row needs two values';
    }
    if (values.any((value) => value.text.trim().isEmpty)) {
      return 'Complete every matching pair';
    }
    return null;
  }

  static String? _required(String? value, String message) {
    return value == null || value.trim().isEmpty ? message : null;
  }
}
