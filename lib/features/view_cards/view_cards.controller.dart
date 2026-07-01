import 'package:boo_mondai/lib.barrel.dart'
    show
        buildViewCardsInitialSearchText,
        buildViewCardsStudyCardsScope,
        buildViewCardsTemplateScope,
        CardTemplate,
        CardTemplateSearchFilter,
        cleanViewCardsSearchText,
        Controller,
        LocalDB,
        resolveViewCardsInitialScope,
        SearchScopeOption,
        SearchState,
        StudyCard,
        StudyCardSearchFilter,
        ViewCardsLayoutMode,
        ViewCardsSearchScope;
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

class ViewCardsController extends Controller {
  ViewCardsController({Map<String, String> queryParameters = const {}}) {
    final initialScope = resolveViewCardsInitialScope(queryParameters);
    final initialSearchText = cleanViewCardsSearchText(
      buildViewCardsInitialSearchText(queryParameters),
    );

    _activeScope = initialScope;
    _templateSearchState =
        SearchState<
          ViewCardsSearchScope,
          CardTemplate,
          CardTemplateSearchFilter
        >(
          scope: buildViewCardsTemplateScope(const []),
          initialText: initialScope == ViewCardsSearchScope.templates
              ? initialSearchText
              : '',
        );
    _studyCardsSearchState =
        SearchState<ViewCardsSearchScope, StudyCard, StudyCardSearchFilter>(
          scope: buildViewCardsStudyCardsScope(const []),
          initialText: initialScope == ViewCardsSearchScope.studyCards
              ? initialSearchText
              : '',
        );

    _deckListenable = LocalDB.deck.box.listenable();
    _templateListenable = LocalDB.cardTemplate.box.listenable();
    _studyCardListenable = LocalDB.studyCard.box.listenable();

    _deckListenable.addListener(load);
    _templateListenable.addListener(load);
    _studyCardListenable.addListener(load);
    _templateSearchState.controller.addListener(notifyListeners);
    _studyCardsSearchState.controller.addListener(notifyListeners);
  }

  late final Listenable _deckListenable;
  late final Listenable _templateListenable;
  late final Listenable _studyCardListenable;
  late final SearchState<
    ViewCardsSearchScope,
    CardTemplate,
    CardTemplateSearchFilter
  >
  _templateSearchState;
  late final SearchState<ViewCardsSearchScope, StudyCard, StudyCardSearchFilter>
  _studyCardsSearchState;

  List<StudyCard> _cards = [];
  List<CardTemplate> _templates = [];
  late ViewCardsSearchScope _activeScope;
  ViewCardsLayoutMode _layoutMode = ViewCardsLayoutMode.compact;

  List<StudyCard> get cards => List.unmodifiable(_cards);
  List<CardTemplate> get templates => List.unmodifiable(_templates);
  SearchState<ViewCardsSearchScope, CardTemplate, CardTemplateSearchFilter>
  get templateSearchState => _templateSearchState;
  SearchState<ViewCardsSearchScope, StudyCard, StudyCardSearchFilter>
  get studyCardsSearchState => _studyCardsSearchState;
  ViewCardsSearchScope get activeScope => _activeScope;
  ViewCardsLayoutMode get layoutMode => _layoutMode;
  bool get isTemplateScope => activeScope == ViewCardsSearchScope.templates;
  bool get hasSearchQuery => isTemplateScope
      ? _templateSearchState.hasSearchQuery
      : _studyCardsSearchState.hasSearchQuery;
  List<SearchScopeOption<ViewCardsSearchScope>> get scopeOptions => [
    _templateSearchState.scope.option,
    _studyCardsSearchState.scope.option,
  ];

  void setActiveScope(ViewCardsSearchScope value) {
    if (_activeScope == value) return;

    _activeScope = value;
    notifyListeners();
  }

  void setLayoutMode(ViewCardsLayoutMode value) {
    if (_layoutMode == value) return;

    _layoutMode = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _deckListenable.removeListener(load);
    _templateListenable.removeListener(load);
    _studyCardListenable.removeListener(load);
    _templateSearchState.controller.removeListener(notifyListeners);
    _studyCardsSearchState.controller.removeListener(notifyListeners);
    _templateSearchState.dispose();
    _studyCardsSearchState.dispose();
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
      _templateSearchState.setItems(_templates);
      _studyCardsSearchState.setItems(_cards);
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
