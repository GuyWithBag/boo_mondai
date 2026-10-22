// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/dtos/card_template_tag.dto.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
import 'package:dart_mappable/dart_mappable.dart';
part 'card_template_tag.dto.mapper.dart';

@MappableClass()
class CardTemplateTag with CardTemplateTagMappable {
  final String templateId;
  final String tagId;

  const CardTemplateTag({required this.templateId, required this.tagId});
  String get compositeId => '${templateId}_$tagId';
}
