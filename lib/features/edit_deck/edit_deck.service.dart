import 'package:boo_mondai/features/cards/models/card_template.dto.dart';
import 'package:boo_mondai/features/decks/models/deck.dto.dart';
import 'package:boo_mondai/features/study_session/study_card.service.dart';
import 'package:boo_mondai/lib.barrel.dart' show LocalDB;

abstract final class EditDeckService {
  static Future<Deck> saveDeck({
    required Deck deck,
    required List<CardTemplate> templateDrafts,
    String? title,
  }) async {
    var updatedDeck = deck;

    if (title != null) {
      final trimmedTitle = title.trim();
      if (trimmedTitle != updatedDeck.title) {
        updatedDeck = updatedDeck.copyWith(title: trimmedTitle);
      }
    }

    updatedDeck = updatedDeck.copyWith(
      cardCount: templateDrafts.length,
      updatedAt: DateTime.now(),
    );

    await LocalDB.deck.upsert(updatedDeck);
    await LocalDB.cardTemplate.upsertMany(templateDrafts);
    await StudyCardService.syncDeckStudyCards(
      deckId: updatedDeck.id,
      templates: templateDrafts,
    );

    return updatedDeck;
  }
}
