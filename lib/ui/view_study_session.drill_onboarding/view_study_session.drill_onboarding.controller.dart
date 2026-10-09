import 'package:boo_mondai/lib.barrel.dart'
    show
        CardTemplate,
        DrillStudySessionSelector,
        LocalDB,
        StudyCard,
        StudySessionConfig,
        ViewCardsController;
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

final class ViewStudySessionDrillOnboardingController {
  ViewStudySessionDrillOnboardingController({required this.deckId}) {
    cardsController = ViewCardsController(
      loadTemplates: _loadTemplates,
      additionalListenables: [
        LocalDB.studyCard.box.listenable(),
        LocalDB.fsrsCard.box.listenable(),
      ],
    )..load();
  }

  final String deckId;

  late final ViewCardsController cardsController;
  List<StudyCard> selectedStudyCards = const [];
  int remainingCardsAfterBatch = 0;

  String get batchMessage {
    final batchSize = const StudySessionConfig.drill().showCardsByBatch ?? 0;
    final selectedCount = selectedStudyCards.length;
    final cardLabel = selectedCount == 1 ? 'card' : 'cards';
    final remainingLabel = remainingCardsAfterBatch == 1 ? 'card' : 'cards';

    if (remainingCardsAfterBatch <= 0) {
      return 'You are studying by batches of $batchSize cards. This drill has $selectedCount $cardLabel and is the final batch for this deck.';
    }

    return 'You are studying by batches of $batchSize cards. This drill has $selectedCount $cardLabel; after it, $remainingCardsAfterBatch $remainingLabel will still be waiting for the next batch.';
  }

  String get sessionPath {
    return Uri(
      path: '/drill/$deckId/session',
      queryParameters: {
        'studyCardIds': selectedStudyCards.map((card) => card.id).join(','),
      },
    ).toString();
  }

  void dispose() {
    cardsController.dispose();
  }

  List<CardTemplate> _loadTemplates() {
    final profileId = LocalDB.currentProfile.getOrCreate().id;
    final eligibleCards = LocalDB.studyCard.getEligibleDrillCards(
      deckId,
      profileId,
    );
    selectedStudyCards = DrillStudySessionSelector.select(
      deckId: deckId,
      profileId: profileId,
    );
    remainingCardsAfterBatch = eligibleCards.length - selectedStudyCards.length;
    final templateIds = selectedStudyCards
        .map((card) => card.templateId)
        .toSet();
    return LocalDB.cardTemplate
        .getByDeckId(deckId)
        .where((template) => templateIds.contains(template.id))
        .toList();
  }
}
