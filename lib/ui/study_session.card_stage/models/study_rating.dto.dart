import 'package:dart_mappable/dart_mappable.dart';

part 'study_rating.dto.mapper.dart';

@MappableEnum()
enum StudyRating { incorrect, again, easy, good, hard }
