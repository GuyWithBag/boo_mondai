import 'package:boo_mondai/core/helpers/casing.helper.dart';
import 'package:boo_mondai/core/helpers/casing.type.dart';
import 'package:boo_mondai/core/services/uuid.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'identification.answer_key.dto.mapper.dart';

@MappableClass()
class IdentificationAnswerKey with IdentificationAnswerKeyMappable {
  final String id;
  final String templateId;
  final int displayOrder;
  final String value;
  final CasingType casingType;

  const IdentificationAnswerKey({
    required this.id,
    required this.templateId,
    required this.displayOrder,
    required this.value,
    this.casingType = CasingType.any,
  });

  factory IdentificationAnswerKey.createDummy({
    String? id,
    String templateId = '',
    int displayOrder = 0,
  }) {
    return IdentificationAnswerKey(
      id: id ?? uuid.v7(),
      templateId: templateId,
      displayOrder: displayOrder,
      value: '',
    );
  }

  bool accepts(String input) => CasingHelper.matches(input, value, casingType);
}
