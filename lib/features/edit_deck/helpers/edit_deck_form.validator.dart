import 'package:boo_mondai/features/cards/models/identification_answer_data.dto.dart';
import 'package:boo_mondai/features/cards/models/match_pair_data.dto.dart';
import 'package:boo_mondai/features/cards/models/multiple_choice_option.dto.dart';

abstract final class EditDeckFormValidator {
  static String? prompt(String? value) {
    return _required(value, 'Enter a prompt');
  }

  static String? answer(String? value) {
    return _required(value, 'Enter an answer');
  }

  static String? identificationAnswers(
    List<IdentificationAnswerData>? answers,
  ) {
    if (answers == null || answers.isEmpty) {
      return 'Add at least one accepted answer';
    }
    if (!answers.any((answer) => answer.answer.trim().isNotEmpty)) {
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
    return null;
  }

  static String? matchingPairs(List<MatchPairData>? pairs) {
    if (pairs == null || pairs.length < 2) {
      return 'Add at least two matching pairs';
    }
    if (pairs.any((pair) {
      return pair.term.trim().isEmpty || pair.match.trim().isEmpty;
    })) {
      return 'Complete every matching pair';
    }
    return null;
  }

  static String? _required(String? value, String message) {
    return value == null || value.trim().isEmpty ? message : null;
  }
}
