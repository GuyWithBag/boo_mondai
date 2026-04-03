import 'package:boo_mondai/models/models.barrel.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'word_scramble_template.mapper.dart';

@MappableClass(discriminatorValue: 'word_scramble')
class WordScrambleTemplate extends CardTemplate
    with WordScrambleTemplateMappable {
  final String sentenceToScramble;
  final String? imageUrl;
  final String? audioUrl;

  const WordScrambleTemplate({
    required super.id,
    required super.deckId,
    required super.sortOrder,
    required super.createdAt,
    super.sourceTemplateId,
    required this.sentenceToScramble,
    this.imageUrl,
    this.audioUrl,
  });

  @override
  bool checkAnswer(String userAnswer, {bool isReversed = false}) {
    return userAnswer.trim().toLowerCase() ==
        sentenceToScramble.trim().toLowerCase();
  }
}
