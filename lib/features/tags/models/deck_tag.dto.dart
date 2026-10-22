// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/dtos/deck_tag.dto.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
import 'package:dart_mappable/dart_mappable.dart';
part 'deck_tag.dto.mapper.dart';

@MappableClass()
class DeckTag with DeckTagMappable {
  final String deckId;
  final String tagId;

  const DeckTag({required this.deckId, required this.tagId});
  String get compositeId => '${deckId}_$tagId';
}
