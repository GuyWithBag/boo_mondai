import 'package:boo_mondai/features/cards/models/card_template.dto.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:boo_mondai/features/tags/models/tag.dto.dart';
import 'package:boo_mondai/features/card_attachments/models/card_media_attachment.dto.dart';

part 'identification_template.dto.mapper.dart';

@MappableClass(discriminatorValue: 'identification')
class IdentificationTemplate extends CardTemplate
    with IdentificationTemplateMappable {
  final String promptText;
  final String acceptedAnswers; // Comma-separated
  final String? imageUrl;
  final String? audioUrl;

  const IdentificationTemplate({
    required super.id,
    required super.deckId,
    required super.sortOrder,
    required super.createdAt,
    required super.updatedAt,
    super.sourceTemplateId,
    super.tags,
    super.attachments,
    required this.promptText,
    required this.acceptedAnswers,
    this.imageUrl,
    this.audioUrl,
  });

  @override
  bool checkAnswer(String userAnswer, {bool isReversed = false}) {
    return acceptedAnswers
        .split(',')
        .map((a) => a.trim().toLowerCase())
        .where((a) => a.isNotEmpty)
        .contains(userAnswer.trim().toLowerCase());
  }
}
