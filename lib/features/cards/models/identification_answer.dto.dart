import 'package:boo_mondai/core/helpers/casing.helper.dart';
import 'package:boo_mondai/core/helpers/casing_type.dart';
import 'package:boo_mondai/core/services/uuid.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'identification_answer.dto.mapper.dart';

@MappableClass()
class IdentificationAnswer with IdentificationAnswerMappable {
  final String id;
  final String templateId;
  final int displayOrder;
  final String answer;
  final CasingType casingType;

  const IdentificationAnswer({
    required this.id,
    required this.templateId,
    required this.displayOrder,
    required this.answer,
    this.casingType = CasingType.any,
  });

  factory IdentificationAnswer.createDummy({
    String? id,
    String templateId = '',
    int displayOrder = 0,
  }) {
    return IdentificationAnswer(
      id: id ?? uuid.v7(),
      templateId: templateId,
      displayOrder: displayOrder,
      answer: '',
    );
  }

  bool accepts(String input) => CasingHelper.matches(input, answer, casingType);
}
