import 'package:boo_mondai/core/helpers/casing.helper.dart';
import 'package:boo_mondai/core/helpers/casing.type.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'fill_in_the_blank.answer_key.dto.mapper.dart';

@MappableClass()
class FillInTheBlankAnswerKey with FillInTheBlankAnswerKeyMappable {
  const FillInTheBlankAnswerKey({
    required this.casingType,
    required this.value,
    required this.order,
  });

  final CasingType casingType;
  final String value;
  final int order;

  bool accepts(String input) => CasingHelper.matches(input, value, casingType);
}
