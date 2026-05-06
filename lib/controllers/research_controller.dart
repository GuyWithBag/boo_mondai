// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/controllers/research_controller.dart
// PURPOSE: UI state for research codes, surveys, vocabulary tests, and researcher dashboard
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/foundation.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/database/database.barrel.dart';
import 'package:boo_mondai/services/services.barrel.dart';

class ResearchController extends ChangeNotifier {
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
    if (_error != null) {
      _error = null;
      notifyListeners();
    }
  }

  Future<String?> redeemCode(String userId, String code) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final researchCode = await RemoteDB.research.redeemResearchCode(
        code,
        userId,
      );
      _unlockedFlows.add(researchCode.unlocks);
      _isLoading = false;
      notifyListeners();
      return researchCode.unlocks;
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
      final researchCode = Services.research.buildResearchCode(
        createdBy: createdBy,
        targetRole: targetRole,
        unlocks: unlocks,
      );

      final result = await RemoteDB.research.insertOne(researchCode);
      _codes = [result, ..._codes];
      notifyListeners();
      return result;
    } on AppException catch (e) {
      _error = e.message;
      notifyListeners();
      return null;
    }
  }

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
      final surveyResponse = Services.research.buildSurveyResponse(
        userId: userId,
        surveyType: surveyType,
        timePoint: timePoint,
        responses: responses,
        extras: extras,
      );

      await RemoteDB.research.client
          .from('survey_responses')
          .insert(surveyResponse.toMap());
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
      final testResult = Services.research.buildVocabularyTestResult(
        userId: userId,
        testSet: testSet,
        score: score,
        answers: answers,
      );

      await RemoteDB.research.client
          .from('research_vocabulary_test')
          .insert(testResult.toMap());
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
      final allData = await RemoteDB.research.fetchAllResearchData();

      _researchProfiles = allData.profiles;
      _codes = allData.codes;
      _surveyResponses = allData.responses;
      _testResults = allData.testResults;
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
    required String goal,
    required String firstName,
    required String lastName,
    required int age,
  }) async {
    _error = null;

    try {
      final profile = Services.research.buildResearchProfile(
        userId: userId,
        role: role,
        goal: goal,
        firstName: firstName,
        lastName: lastName,
        age: age,
      );

      await RemoteDB.research.client
          .from('research_profiles')
          .insert(profile.toMap());
    } on AppException catch (e) {
      _error = e.message;
      notifyListeners();
    }
  }
}
