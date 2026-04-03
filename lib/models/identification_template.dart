import 'package:boo_mondai/models/models.barrel.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'identification_template.mapper.dart';

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
    super.sourceTemplateId,
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
