import 'package:boo_mondai/lib.barrel.dart'
    show FirstDrillSurvey, LocalDB, SurveyDefinition;

abstract final class SurveyRegistry {
  static List<SurveyDefinition> getAll() {
    final profileId = LocalDB.profile.getOrCreate().id;
    return [FirstDrillSurvey.build(profileId: profileId)];
  }

  static SurveyDefinition? getById(String surveyId) {
    for (final definition in getAll()) {
      if (definition.id == surveyId) return definition;
    }
    return null;
  }
}
