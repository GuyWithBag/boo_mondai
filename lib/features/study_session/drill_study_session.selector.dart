import 'package:boo_mondai/lib.barrel.dart'
    show LocalDB, StudyCard, StudySessionConfig;

abstract final class DrillStudySessionSelector {
  static List<StudyCard> select({
    required String deckId,
    required String profileId,
    StudySessionConfig config = const StudySessionConfig.drill(),
    List<String>? studyCardIds,
    bool shuffle = true,
  }) {
    final eligibleCards = LocalDB.studyCard.getEligibleDrillCards(
      deckId,
      profileId,
    );
    final selected = studyCardIds == null
        ? eligibleCards.toList()
        : _selectRequestedCards(
            eligibleCards: eligibleCards,
            studyCardIds: studyCardIds,
          );

    if (shuffle && studyCardIds == null) {
      selected.shuffle();
    }

    final limit = config.showCardsByBatch;
    return limit == null ? selected : selected.take(limit).toList();
  }

  static List<StudyCard> _selectRequestedCards({
    required List<StudyCard> eligibleCards,
    required List<String> studyCardIds,
  }) {
    final eligibleCardsById = {for (final card in eligibleCards) card.id: card};

    return [
      for (final studyCardId in studyCardIds) ?eligibleCardsById[studyCardId],
    ];
  }
}
