// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/research_service.dart
// PURPOSE: Business logic for research codes, SUS scoring, and survey construction
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/services/uuid_service.dart';
import 'package:boo_mondai/shared/uuid.dart';

class ResearchService {
  String generateCode() {
    return UuidService.uuid
        .v4()
        .replaceAll('-', '')
        .substring(0, 8)
        .toUpperCase();
  }

  double computeSusScore(Map<String, int> responses) {
    final oddSum =
        (responses['item_1'] ?? 0) +
        (responses['item_3'] ?? 0) +
        (responses['item_5'] ?? 0) +
        (responses['item_7'] ?? 0) +
        (responses['item_9'] ?? 0);
    final evenSum =
        (responses['item_2'] ?? 0) +
        (responses['item_4'] ?? 0) +
        (responses['item_6'] ?? 0) +
        (responses['item_8'] ?? 0) +
        (responses['item_10'] ?? 0);
    return ((oddSum - 5) + (25 - evenSum)) * 2.5;
  }

  SurveyResponse buildSurveyResponse({
    required String userId,
    required String surveyType,
    String? timePoint,
    required Map<String, int> responses,
    Map<String, dynamic>? extras,
  }) {
    final fullResponses = <String, dynamic>{
      ...responses,
      if (extras != null) ...extras,
    };

    double? computedScore;
    if (surveyType == 'sus') {
      computedScore = computeSusScore(responses);
    }

    return SurveyResponse(
      id: uuid.v7(),
      userId: userId,
      surveyType: surveyType,
      timePoint: timePoint,
      responses: fullResponses,
      computedScore: computedScore,
      submittedAt: DateTime.now(),
    );
  }

  VocabularyTestResult buildVocabularyTestResult({
    required String userId,
    required String testSet,
    required int score,
    required Map<String, dynamic> answers,
  }) {
    return VocabularyTestResult(
      id: uuid.v7(),
      userId: userId,
      testSet: testSet,
      score: score,
      answers: answers,
      submittedAt: DateTime.now(),
    );
  }

  ResearchCode buildResearchCode({
    required String createdBy,
    required String targetRole,
    required String unlocks,
  }) {
    return ResearchCode(
      id: uuid.v7(),
      code: generateCode(),
      targetRole: targetRole,
      unlocks: unlocks,
      createdBy: createdBy,
      createdAt: DateTime.now(),
    );
  }

  ResearchProfile buildResearchProfile({
    required String userId,
    required String role,
    required String goal,
    required String firstName,
    required String lastName,
    required int age,
  }) {
    return ResearchProfile(
      id: uuid.v7(),
      userId: userId,
      role: role,
      goal: goal,
      firstName: firstName,
      lastName: lastName,
      age: age,
      createdAt: DateTime.now(),
    );
  }
}
