// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/providers/research_provider.dart
// PURPOSE: Manages research codes, surveys, vocabulary tests, and researcher dashboard
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/foundation.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/services/services.dart';
import 'package:boo_mondai/services/app_exception.dart';

/// Handles research study flows: codes, surveys, tests, and researcher data viewing.
class ResearchProvider extends ChangeNotifier {
  final _supabaseService = Services.research;

  ResearchProfile? _researchProfile;
  List<ResearchCode> _codes = [];
  final List<String> _unlockedFlows = [];
  List<SurveyResponse> _surveyResponses = [];
  List<VocabularyTestResult> _testResults = [];
  List<ResearchProfile> _researchProfiles = [];
  bool _isLoading = false;
  String? _error;

  ResearchProfile? get researchProfile => _researchProfile;
  List<ResearchCode> get codes => List.unmodifiable(_codes);
  List<String> get unlockedFlows => List.unmodifiable(_unlockedFlows);
  List<SurveyResponse> get surveyResponses =>
      List.unmodifiable(_surveyResponses);
  List<VocabularyTestResult> get testResults => List.unmodifiable(_testResults);
  List<ResearchProfile> get researchProfiles =>
      List.unmodifiable(_researchProfiles);
  bool get isLoading => _isLoading;
  String? get error => _error;

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<String?> redeemCode(String userId, String code) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final codeData = await _supabaseService.redeemResearchCode(code, userId);
      final unlocks = codeData['unlocks'] as String;
      _unlockedFlows.add(unlocks);
      _isLoading = false;
      notifyListeners();
      return unlocks;
    } on AppException catch (e) {
      _error = e.message;
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<ResearchCode?> generateCode(
    String createdBy,
    String targetRole,
    String unlocks,
  ) async {
    _error = null;

    try {
      final code = _generateCodeString();
      final data = {
        'code': code,
        'targetRole': targetRole,
        'unlocks': unlocks,
        'createdBy': createdBy,
      };
      final result = await _supabaseService.insertResearchCode(data);
      final researchCode = ResearchCodeMapper.fromMap(result);
      _codes = [researchCode, ..._codes];
      notifyListeners();
      return researchCode;
    } on AppException catch (e) {
      _error = e.message;
      notifyListeners();
      return null;
    }
  }

  /// Submits a survey response to the single generic survey_responses table.
  /// For SUS surveys, computes the score client-side before submitting.
  Future<void> submitSurvey(
    String userId,
    String surveyType,
    String? timePoint,
    Map<String, int> responses, {
    Map<String, dynamic>? extras,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Merge responses with any extras (e.g. proficiency_level)
      final fullResponses = <String, dynamic>{
        ...responses,
        if (extras != null) ...extras,
      };

      double? computedScore;
      if (surveyType == 'sus') {
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
        computedScore = ((oddSum - 5) + (25 - evenSum)) * 2.5;
      }

      final data = <String, dynamic>{
        'userId': userId,
        'surveyType': surveyType,
        if (timePoint != null) 'timePoint': timePoint,
        'responses': fullResponses,
        if (computedScore != null) 'computedScore': computedScore,
        'submittedAt': DateTime.now().toIso8601String(),
      };

      await _supabaseService.insertSurveyResponse(data);
    } on AppException catch (e) {
      _error = e.message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> submitVocabularyTest(
    String userId,
    String testSet,
    int score,
    Map<String, dynamic> answers,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _supabaseService.insertVocabularyTest({
        'userId': userId,
        'testSet': testSet,
        'score': score,
        'answers': answers,
        'submittedAt': DateTime.now().toIso8601String(),
      });
    } on AppException catch (e) {
      _error = e.message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAllResearchData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final allData = await _supabaseService.fetchAllResearchData();
      final codesData = await _supabaseService.fetchResearchCodes();

      _researchProfiles = (allData['research_profiles'] ?? [])
          .map((d) => ResearchProfileMapper.fromMap(d))
          .toList();
      _codes = codesData.map(ResearchCodeMapper.fromMap).toList();
      _surveyResponses = (allData['survey_responses'] ?? [])
          .map((d) => SurveyResponseMapper.fromMap(d))
          .toList();
      _testResults = (allData['vocabulary_test_results'] ?? [])
          .map((d) => VocabularyTestResultMapper.fromMap(d))
          .toList();
    } on AppException catch (e) {
      _error = e.message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addResearchProfile({
    required String userId,
    required String role,
    required String targetLanguage,
    required String firstName,
    required String lastName,
    required int age,
    String? userName,
  }) async {
    _error = null;

    try {
      await _supabaseService.insertResearchProfile({
        'userId': userId,
        if (userName != null) 'userName': userName,
        'firstName': firstName,
        'lastName': lastName,
        'age': age,
        'role': role,
        'targetLanguage': targetLanguage,
      });
    } on AppException catch (e) {
      _error = e.message;
      notifyListeners();
    }
  }

  String _generateCodeString() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = DateTime.now().microsecondsSinceEpoch;
    return List.generate(
      8,
      (i) => chars[(rand + i * 37) % chars.length],
    ).join();
  }
}
