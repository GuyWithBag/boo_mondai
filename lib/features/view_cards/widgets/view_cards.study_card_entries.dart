import 'package:boo_mondai/lib.barrel.dart' show FlashcardTemplate, StudyCard;

class ViewCardsStudyCardEntry {
  const ViewCardsStudyCardEntry.single(StudyCard this.card)
    : frontCard = null,
      backCard = null;

  const ViewCardsStudyCardEntry.pair({
    required StudyCard this.frontCard,
    required StudyCard this.backCard,
  }) : card = null;

  final StudyCard? card;
  final StudyCard? frontCard;
  final StudyCard? backCard;
}

List<ViewCardsStudyCardEntry> buildPairedStudyCardEntries(
  List<StudyCard> cards,
) {
  final flashcardGroups = <String, List<StudyCard>>{};
  for (final card in cards) {
    if (card.template is FlashcardTemplate) {
      (flashcardGroups[card.templateId] ??= []).add(card);
    }
  }

  final entries = <ViewCardsStudyCardEntry>[];
  final handledTemplateIds = <String>{};

  for (final card in cards) {
    if (card.template is! FlashcardTemplate) {
      entries.add(ViewCardsStudyCardEntry.single(card));
      continue;
    }

    if (!handledTemplateIds.add(card.templateId)) {
      continue;
    }

    final group = flashcardGroups[card.templateId] ?? const <StudyCard>[];
    final frontCard = _firstWhereOrNull(
      group,
      (candidate) => !candidate.isReversed,
    );
    final backCard = _firstWhereOrNull(
      group,
      (candidate) => candidate.isReversed,
    );

    if (frontCard != null && backCard != null) {
      entries.add(
        ViewCardsStudyCardEntry.pair(frontCard: frontCard, backCard: backCard),
      );
    } else {
      entries.addAll(group.map(ViewCardsStudyCardEntry.single));
    }
  }

  return entries;
}

StudyCard? _firstWhereOrNull(
  Iterable<StudyCard> cards,
  bool Function(StudyCard card) test,
) {
  for (final card in cards) {
    if (test(card)) return card;
  }
  return null;
}
