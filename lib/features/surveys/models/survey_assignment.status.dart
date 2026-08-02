import 'package:dart_mappable/dart_mappable.dart';

part 'survey_assignment.status.mapper.dart';

@MappableEnum(caseStyle: CaseStyle.snakeCase)
enum SurveyAssignmentStatus { pending, completed, expired, cancelled }
