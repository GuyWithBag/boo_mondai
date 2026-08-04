import 'package:dart_mappable/dart_mappable.dart';

part 'casing_type.mapper.dart';

@MappableEnum(caseStyle: CaseStyle.snakeCase)
enum CasingType {
  any,
  exact,
  camel,
  pascal,
  snake,
  kebab,
  title;

  String get label => switch (this) {
    CasingType.any => 'Any',
    CasingType.exact => 'Exact',
    CasingType.camel => 'camel',
    CasingType.pascal => 'Pascal',
    CasingType.snake => 'snake',
    CasingType.kebab => 'kebab',
    CasingType.title => 'Title',
  };
}
