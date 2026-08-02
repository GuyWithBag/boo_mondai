import 'package:boo_mondai/features/surveys/models/survey.status.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'survey.dto.mapper.dart';

@MappableClass()
class Survey with SurveyMappable {
  final String id;
  final String profileId;
  final String title;
  final String description;
  final SurveyStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Survey({
    required this.id,
    required this.profileId,
    required this.title,
    this.description = '',
    this.status = SurveyStatus.draft,
    required this.createdAt,
    required this.updatedAt,
  });
}
