import 'package:boo_mondai/features/cards/models/card_media_attachment.dto.dart';
import 'package:boo_mondai/features/cards/models/card_template.dto.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:boo_mondai/features/tags/models/tag.dto.dart';

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
    required super.updatedAt,
    super.sourceTemplateId,
    super.tags,
    super.attachments,
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
