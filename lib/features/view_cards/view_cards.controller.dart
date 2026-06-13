import 'package:boo_mondai/lib.barrel.dart'
    show CardTemplate, Controller, LocalDB, StudyCard;
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

class ViewCardsController extends Controller {
  ViewCardsController() {
    _deckListenable = LocalDB.deck.box.listenable();
    _templateListenable = LocalDB.cardTemplate.box.listenable();
    _studyCardListenable = LocalDB.studyCard.box.listenable();

    _deckListenable.addListener(load);
    _templateListenable.addListener(load);
    _studyCardListenable.addListener(load);
  }

  late final Listenable _deckListenable;
  late final Listenable _templateListenable;
  late final Listenable _studyCardListenable;

  List<StudyCard> _cards = [];
  List<CardTemplate> _templates = [];

  List<StudyCard> get cards => List.unmodifiable(_cards);
  List<CardTemplate> get templates => List.unmodifiable(_templates);

  @override
  void dispose() {
    _deckListenable.removeListener(load);
    _templateListenable.removeListener(load);
    _studyCardListenable.removeListener(load);
    super.dispose();
  }

  void load() {
    setLoading(true);

    Exception? failure;
    try {
      final decksById = {
        for (final deck in LocalDB.deck.selectMany()) deck.id: deck,
      };
      final templatesById = {
        for (final template in LocalDB.cardTemplate.box.values)
          template.id: template,
      };

      final cards =
          LocalDB.studyCard
              .selectMany()
              .map(
                (card) => card.copyWith(
                  deck: decksById[card.deckId],
                  template: templatesById[card.templateId],
                ),
              )
              .toList()
            ..sort(_compareCards);

      _templates = templatesById.values.toList()..sort(_compareTemplates);
      _cards = cards;
    } on Exception catch (e) {
      failure = e;
    } finally {
      setLoading(false);
      if (failure != null) {
        setError(failure);
      } else {
        notifyListeners();
      }
    }
  }

  int _compareTemplates(CardTemplate left, CardTemplate right) {
    if (left.deckId != right.deckId) {
      return left.deckId.compareTo(right.deckId);
    }

    if (left.sortOrder != right.sortOrder) {
      return left.sortOrder.compareTo(right.sortOrder);
    }

    return left.id.compareTo(right.id);
  }

  int _compareCards(StudyCard left, StudyCard right) {
    final leftOrder = left.template?.sortOrder ?? 0;
    final rightOrder = right.template?.sortOrder ?? 0;
    if (leftOrder != rightOrder) {
      return leftOrder.compareTo(rightOrder);
    }

    if (left.templateId != right.templateId) {
      return left.templateId.compareTo(right.templateId);
    }

    if (left.isReversed != right.isReversed) {
      return left.isReversed ? 1 : -1;
    }

    return left.id.compareTo(right.id);
  }
}
