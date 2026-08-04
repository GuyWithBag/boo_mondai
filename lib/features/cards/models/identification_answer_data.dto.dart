import 'package:boo_mondai/core/helpers/casing_type.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'identification_answer_data.dto.mapper.dart';

const defaultIdentificationAnswers = [
  IdentificationAnswerData(answer: '', casingType: CasingType.any),
];

@MappableClass()
class IdentificationAnswerData with IdentificationAnswerDataMappable {
  final String answer;
  final CasingType casingType;

  const IdentificationAnswerData({
    required this.answer,
    this.casingType = CasingType.any,
  });
}
