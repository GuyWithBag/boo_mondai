import 'dart:convert';

import 'package:boo_mondai/lib.barrel.dart'
    show SurveyResponse, SurveyResponseMapper;
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

class SurveyResponsesLocalDB {
  static const String boxName = 'survey_responses';

  late final Box<String> box;

  Future<SurveyResponsesLocalDB> init() async {
    box = await Hive.openBox<String>(boxName);
    return this;
  }

  Future<void> upsert(SurveyResponse response) async {
    await box.put(response.id, response.toJson());
  }

  List<SurveyResponse> selectMany({
    bool Function(SurveyResponse response)? where,
  }) {
    final responses = box.values
        .map((value) => SurveyResponseMapper.fromJson(value))
        .where((response) => where == null || where(response))
        .toList();
    return responses;
  }

  SurveyResponse? selectBySurveyAndProfile({
    required String surveyId,
    required String profileId,
  }) {
    for (final response in selectMany()) {
      if (response.surveyId == surveyId && response.profileId == profileId) {
        return response;
      }
    }
    return null;
  }

  Future<void> clear() => box.clear();

  Map<String, dynamic> debugDump() {
    return {
      for (final entry in box.toMap().entries)
        entry.key.toString(): jsonDecode(entry.value),
    };
  }
}
