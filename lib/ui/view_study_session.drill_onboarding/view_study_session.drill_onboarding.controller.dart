import 'package:boo_mondai/lib.barrel.dart'
    show
        CardTemplate,
        DrillStudySessionSelector,
        LocalDB,
        StudyCard,
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
    selectedStudyCards = DrillStudySessionSelector.select(
      deckId: deckId,
      profileId: profileId,
    );
    final templateIds = selectedStudyCards
        .map((card) => card.templateId)
        .toSet();
    return LocalDB.cardTemplate
        .getByDeckId(deckId)
        .where((template) => templateIds.contains(template.id))
        .toList();
  }
}
