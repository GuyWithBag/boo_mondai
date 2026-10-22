import 'package:boo_mondai/core/helpers/casing.helper.dart';
import 'package:boo_mondai/core/helpers/casing.type.dart';
import 'package:boo_mondai/features/cards/models/identification.answer_key.dto.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        IdentificationTemplate,
        StudyRating,
        StudySessionAnswer,
        StudySessionCardStageController,
        SurfaceColor;
import 'package:boo_mondai/ui/study_session.card_stage/widgets/card_template.controller.dart';
import 'package:flutter/material.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';

class IdentificationController implements CardTemplateController {
  IdentificationController({
    required this.template,
    this.cardStageController,
    bool isRevealed = false,
  }) : answerTextController = TextEditingController(),
       isRevealedOverride = isRevealed {
    resetAnswer();
  }

  final IdentificationTemplate template;
  final StudySessionCardStageController? cardStageController;
  final TextEditingController answerTextController;
  bool isRevealedOverride;

  bool get effectiveIsRevealed =>
      isRevealedOverride || cardStageController?.isRevealed.value == true;

  bool get wasIncorrect =>
      cardStageController?.pendingRating.value == StudyRating.incorrect;

  String? get submittedAnswer =>
      cardStageController?.answer.value?.value.trim();

  String? get visibleSubmittedAnswer {
    final value = submittedAnswer;
    if (value == null || value.isEmpty) return null;
    return value;
  }

  bool get hasSubmittedAnswer => visibleSubmittedAnswer != null;

  bool get shouldShowSubmittedAnswer => wasIncorrect && hasSubmittedAnswer;

  SurfaceColor get answerSurfaceColor {
    if (!hasSubmittedAnswer) return SurfaceColor.baseline;
    return wasIncorrect ? SurfaceColor.error : SurfaceColor.success;
  }

  List<IdentificationAnswerKey> get sortedAnswers {
    return template.answers.toList()
      ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
  }

  String get answerCasingGuidance {
    final casingLabels = template.answers
        .map((answer) => _casingInstruction(answer.casingType))
        .toSet()
        .toList();
    final casingText = casingLabels.length == 1
        ? casingLabels.single
        : casingLabels.join(' or ');

    return 'Expected casing: $casingText';
  }

  String? get answerCountGuidance {
    final answers = template.answers;
    if (answers.length <= 1) return null;

    return 'There are ${answers.length} possible answers.';
  }

  String? get wrongAnswerInsight {
    final submitted = visibleSubmittedAnswer;
    if (!wasIncorrect || submitted == null) return null;

    return _wrongAnswerInsight(sortedAnswers, submitted);
  }

  void updateIsRevealed(bool value) {
    isRevealedOverride = value;
  }

  void resetAnswer() {
    answerTextController.clear();
    cardStageController?.answer.value = null;
    cardStageController?.canReveal.value = false;
  }

  void updateAnswer(String value) {
    cardStageController?.answer.value = value.trim().isEmpty
        ? null
        : StudySessionAnswer(value: value);
    cardStageController?.canReveal.value = value.trim().isNotEmpty;
  }

  @override
  void dispose() {
    answerTextController.dispose();
  }
}

String? _wrongAnswerInsight(
  List<IdentificationAnswerKey> answers,
  String submittedAnswer,
) {
  final normalizedSubmitted = CasingHelper.normalizedWords(submittedAnswer);
  if (normalizedSubmitted.isEmpty) return null;

  for (final answer in answers) {
    if (CasingHelper.normalizedWords(answer.value) != normalizedSubmitted) {
      continue;
    }

    return 'The wording matches "${answer.value}", but the casing should be ${_casingRequirement(answer.casingType)}.';
  }

  final closest = _closestAnswer(answers, submittedAnswer);
  if (closest == null) return null;

  return 'Closest accepted answer: "${closest.value}".';
}

String _casingRequirement(CasingType casingType) {
  return switch (casingType) {
    CasingType.any => 'any casing',
    CasingType.exact => 'exact',
    CasingType.camel => 'camelCase',
    CasingType.pascal => 'PascalCase',
    CasingType.snake => 'snake_case',
    CasingType.kebab => 'kebab-case',
    CasingType.title => 'Title Case',
  };
}

IdentificationAnswerKey? _closestAnswer(
  List<IdentificationAnswerKey> answers,
  String submittedAnswer,
) {
  const cutoff = 70;
  IdentificationAnswerKey? closest;
  var bestScore = 0;

  for (final answer in answers) {
    final score = ratio(
      CasingHelper.normalizedWords(submittedAnswer),
      CasingHelper.normalizedWords(answer.value),
    );
    if (score > bestScore) {
      closest = answer;
      bestScore = score;
    }
  }

  return bestScore >= cutoff ? closest : null;
}

String _casingInstruction(CasingType casingType) {
  return switch (casingType) {
    CasingType.any => 'Any casing',
    CasingType.exact => 'Exact casing',
    CasingType.camel => 'camelCase',
    CasingType.pascal => 'PascalCase',
    CasingType.snake => 'snake_case',
    CasingType.kebab => 'kebab-case',
    CasingType.title => 'Title Case',
  };
}
