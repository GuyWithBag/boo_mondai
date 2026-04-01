import 'package:boo_mondai/services/services.barrel.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:fsrs/fsrs.dart';

part 'fsrs_card.mapper.dart';

@MappableClass()
class FsrsCard with FsrsCardMappable {
  final String id;
  final String deckCardId;
  final Card state;

  FsrsCard({required this.deckCardId, required this.state, required this.id});

  static Future<FsrsCard> create(String deckCardId) async {
    return FsrsCard(
      id: UuidService.uuid.v4(),
      deckCardId: deckCardId,
      state: await Card.create(),
    );
  }
}
