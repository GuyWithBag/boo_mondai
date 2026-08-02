import 'package:dart_mappable/dart_mappable.dart';

part 'survey.status.mapper.dart';

@MappableEnum(caseStyle: CaseStyle.snakeCase)
enum SurveyStatus { draft, published, archived }
