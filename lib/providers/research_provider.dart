// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/providers/research_provider.dart
// PURPOSE: Manages research codes, surveys, vocabulary tests, and researcher dashboard
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/foundation.dart';
import 'package:boo_mondai/models/models.dart';
import 'package:boo_mondai/services/services.dart';

/// Handles research study flows: codes, surveys, tests, and researcher data viewing.
class ResearchProvider extends ChangeNotifier {
  final SupabaseService _supabaseService;

  ResearchProvider({required SupabaseService supabaseService})
      : _supabaseService = supabaseService;

  ResearchUser? _researchUser;
  List<ResearchCode> _codes = [];
  final List<String> _unlockedFlows = [];
  final List<SurveyResponse> _surveyResponses = [];
  List<VocabularyTestResult> _testResults = [];
  List<ResearchUser> _researchUsers = [];
  List<Map<String, dynamic>> _proficiencyData = [];
  List<Map<String, dynamic>> _languageInterestData = [];
  List<Map<String, dynamic>> _experienceSurveyData = [];
  List<Map<String, dynamic>> _previewUsefulnessData = [];
  List<Map<String, dynamic>> _fsrsUsefulnessData = [];
  List<Map<String, dynamic>> _ugcData = [];
  List<Map<String, dynamic>> _susData = [];
  bool _isLoading = false;
  String? _error;

  ResearchUser? get researchUser => _researchUser;
  List<ResearchCode> get codes => List.unmodifiable(_codes);
  List<String> get unlockedFlows => List.unmodifiable(_unlockedFlows);
  List<SurveyResponse> get surveyResponses =>
      List.unmodifiable(_surveyResponses);
  List<VocabularyTestResult> get testResults =>
      List.unmodifiable(_testResults);
  List<ResearchUser> get researchUsers => List.unmodifiable(_researchUsers);
  List<Map<String, dynamic>> get proficiencyData =>
      List.unmodifiable(_proficiencyData);
  List<Map<String, dynamic>> get languageInterestData =>
      List.unmodifiable(_languageInterestData);
  List<Map<String, dynamic>> get experienceSurveyData =>
      List.unmodifiable(_experienceSurveyData);
  List<Map<String, dynamic>> get previewUsefulnessData =>
      List.unmodifiable(_previewUsefulnessData);
  List<Map<String, dynamic>> get fsrsUsefulnessData =>
      List.unmodifiable(_fsrsUsefulnessData);
  List<Map<String, dynamic>> get ugcData => List.unmodifiable(_ugcData);
  List<Map<String, dynamic>> get susData => List.unmodifiable(_susData);
  bool get isLoading => _isLoading;
  String? get error => _error;

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
      String createdBy, String targetRole, String unlocks) async {
    _error = null;

    try {
      final code = _generateCodeString();
      final data = {
        'code': code,
        'target_role': targetRole,
        'unlocks': unlocks,
        'created_by': createdBy,
      };
      final result = await _supabaseService.insertResearchCode(data);
      final researchCode = ResearchCode.fromJson(result);
      _codes = [researchCode, ..._codes];
      notifyListeners();
      return researchCode;
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
    Map<String, int> responses,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final table = _surveyTypeToTable(surveyType);
      final data = <String, dynamic>{
        'user_id': userId,
        ...responses.map((k, v) => MapEntry(k, v)),
      };

      if (timePoint != null) {
        data['time_point'] = timePoint;
      }

      // Compute SUS score if applicable
      if (surveyType == 'sus') {
        final oddSum = (responses['item_1'] ?? 0) +
            (responses['item_3'] ?? 0) +
            (responses['item_5'] ?? 0) +
            (responses['item_7'] ?? 0) +
            (responses['item_9'] ?? 0);
        final evenSum = (responses['item_2'] ?? 0) +
            (responses['item_4'] ?? 0) +
            (responses['item_6'] ?? 0) +
            (responses['item_8'] ?? 0) +
            (responses['item_10'] ?? 0);
        data['sus_score'] = ((oddSum - 5) + (25 - evenSum)) * 2.5;
      }

      // Proficiency screener needs the proficiency_level field
      // It should be included in the responses map already

      await _supabaseService.insertSurveyResponse(table, data);
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
        'user_id': userId,
        'test_set': testSet,
        'score': score,
        'answers': answers,
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
      _researchUsers = (allData['research_users'] ?? [])
          .map((d) => ResearchUser.fromJson(d))
          .toList();
      final codesData = await _supabaseService.fetchResearchCodes();
      _codes = codesData.map(ResearchCode.fromJson).toList();

      _testResults = (allData['vocabulary_test'] ?? [])
          .map((d) => VocabularyTestResult.fromJson(d))
          .toList();
      _proficiencyData =
          List<Map<String, dynamic>>.from(allData['proficiency_screener'] ?? []);
      _languageInterestData =
          List<Map<String, dynamic>>.from(allData['language_interest'] ?? []);
      _experienceSurveyData =
          List<Map<String, dynamic>>.from(allData['experience_survey'] ?? []);
      _previewUsefulnessData =
          List<Map<String, dynamic>>.from(allData['preview_usefulness'] ?? []);
      _fsrsUsefulnessData =
          List<Map<String, dynamic>>.from(allData['fsrs_usefulness'] ?? []);
      _ugcData =
          List<Map<String, dynamic>>.from(allData['ugc_perception'] ?? []);
      _susData = List<Map<String, dynamic>>.from(allData['sus'] ?? []);
    } on AppException catch (e) {
      _error = e.message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addResearchUser(
      String userId, String role, String targetLanguage) async {
    _error = null;

    try {
      await _supabaseService.insertResearchUser({
        'user_id': userId,
        'role': role,
        'target_language': targetLanguage,
      });
    } on AppException catch (e) {
      _error = e.message;
      notifyListeners();
    }
  }

  String _surveyTypeToTable(String surveyType) {
    switch (surveyType) {
      case 'proficiency_screener':
        return 'research_proficiency_screener';
      case 'language_interest':
        return 'research_language_interest';
      case 'experience_survey':
        return 'research_experience_survey';
      case 'preview_usefulness':
        return 'research_preview_usefulness';
      case 'fsrs_usefulness':
        return 'research_fsrs_usefulness';
      case 'ugc_perception':
        return 'research_ugc_perception';
      case 'sus':
        return 'research_sus';
      default:
        throw AppException('Unknown survey type: $surveyType');
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
