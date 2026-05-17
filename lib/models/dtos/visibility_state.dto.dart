import 'package:dart_mappable/dart_mappable.dart';

part 'visibility_state.dto.mapper.dart';

@MappableEnum(caseStyle: CaseStyle.snakeCase)
enum VisibilityState { public, private, unlisted }
