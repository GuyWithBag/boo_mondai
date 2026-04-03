import 'package:boo_mondai/models/models.barrel.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'flashcard_template.mapper.dart';

@MappableClass(discriminatorValue: 'flashcard')
class FlashcardTemplate extends CardTemplate with FlashcardTemplateMappable {
  final String frontText;
  final String backText;
  final String? frontImageUrl;
  final String? backImageUrl;
  final String? frontAudioUrl;
  final String? backAudioUrl;

  const FlashcardTemplate({
    required super.id,
    required super.deckId,
    required super.sortOrder,
    required super.createdAt,
    super.sourceTemplateId,
    required this.frontText,
    required this.backText,
    this.frontImageUrl,
    this.backImageUrl,
    this.frontAudioUrl,
    this.backAudioUrl,
  });

  String getQuestion({bool isReversed = false}) =>
      isReversed ? backText : frontText;
  String getAnswer({bool isReversed = false}) =>
      isReversed ? frontText : backText;

  @override
  bool checkAnswer(String userAnswer, {bool isReversed = false}) {
    return getAnswer(isReversed: isReversed)
        .split(',')
        .map((a) => a.trim().toLowerCase())
        .where((a) => a.isNotEmpty)
        .contains(userAnswer.trim().toLowerCase());
  }
}
