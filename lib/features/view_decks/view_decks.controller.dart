// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/providers/view_decks.local.controller.dart
// PURPOSE: Loads and manages the list of user-created decks for My Decks page
// PROVIDERS: ViewDecksLocalController
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        DecksLocalDB,
        LocalDB,
        Controller,
        Deck,
        DecksService,
        DeckSearchFilter,
        SearchScopeOption,
        SearchState,
        buildViewDecksDeckScope,
        buildViewDecksListingScope,
        DeckListingSheetState,
        ViewDecksSearchScope,
        showViewDeckListingSingleSheet,
        showViewDeckSingleSheet;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

class ViewDecksLocalController extends Controller {
  final DecksLocalDB _deckDB = LocalDB.deck;
  late final Listenable _deckListenable;
  late final Listenable _deckListingListenable;
  late final SearchState<ViewDecksSearchScope, Deck, DeckSearchFilter>
  _deckSearchState;
  late final SearchState<ViewDecksSearchScope, Deck, DeckSearchFilter>
  _listingSearchState;

  ViewDecksLocalController() {
    _deckSearchState =
        SearchState<ViewDecksSearchScope, Deck, DeckSearchFilter>(
          scope: buildViewDecksDeckScope(const []),
          initialText: '',
        );
    _listingSearchState =
        SearchState<ViewDecksSearchScope, Deck, DeckSearchFilter>(
          scope: buildViewDecksListingScope(const []),
          initialText: '',
        );

    _deckListenable = _deckDB.box.listenable();
    _deckListingListenable = LocalDB.deckListing.box.listenable();
    _deckListenable.addListener(load);
    _deckListingListenable.addListener(load);
    _deckSearchState.controller.addListener(notifyListeners);
    _listingSearchState.controller.addListener(notifyListeners);
  }

  @override
  void dispose() {
    _deckListenable.removeListener(load);
    _deckListingListenable.removeListener(load);
    _deckSearchState.controller.removeListener(notifyListeners);
    _listingSearchState.controller.removeListener(notifyListeners);
    _deckSearchState.dispose();
    _listingSearchState.dispose();
    super.dispose();
  }

  // ── private state ────────────────────────────────────────

  List<Deck> _decks = [];
  List<Deck> _listingDecks = [];
  ViewDecksSearchScope _activeScope = ViewDecksSearchScope.decks;

  // ── public getters ───────────────────────────────────────

  List<Deck> get decks => List.unmodifiable(_decks);
  List<Deck> get listingDecks => List.unmodifiable(_listingDecks);
  ViewDecksSearchScope get activeScope => _activeScope;
  bool get isDeckScope => _activeScope == ViewDecksSearchScope.decks;
  SearchState<ViewDecksSearchScope, Deck, DeckSearchFilter>
  get deckSearchState => _deckSearchState;
  SearchState<ViewDecksSearchScope, Deck, DeckSearchFilter>
  get listingSearchState => _listingSearchState;
  SearchState<ViewDecksSearchScope, Deck, DeckSearchFilter>
  get activeSearchState => isDeckScope ? _deckSearchState : _listingSearchState;
  List<Deck> get visibleDecks => _deckSearchState.results;
  List<Deck> get visibleListingDecks => _listingSearchState.results;
  bool get hasSearchQuery => activeSearchState.hasSearchQuery;
  List<SearchScopeOption<ViewDecksSearchScope>> get scopeOptions => [
    _deckSearchState.scope.option,
    _listingSearchState.scope.option,
  ];

  void setActiveScope(ViewDecksSearchScope value) {
    if (_activeScope == value) return;

    _activeScope = value;
    notifyListeners();
  }

  // ── methods ──────────────────────────────────────────────

  void load() {
    setLoading(true);
    setError(null);
    notifyListeners();

    try {
      _decks = _withLocalListings(_deckDB.filterDecks());
      _listingDecks = [
        for (final deck in _decks)
          if (deck.listing != null) deck,
      ];
      _deckSearchState.setItems(_decks);
      _listingSearchState.setItems(_listingDecks);
    } on Exception catch (e) {
      setError(e);
    } finally {
      setLoading(false);
      notifyListeners();
    }
  }

  void goToDeck(BuildContext context, Deck deck) {
    showViewDeckSingleSheet(context, deck);
  }

  void goToListing(BuildContext context, Deck deck) {
    showViewDeckListingSingleSheet(
      context,
      deck,
      initialState: DeckListingSheetState.editor,
    );
  }

  void loadOnNextFrame() {
    SchedulerBinding.instance.addPostFrameCallback((_) => load());
  }

  void submitSearch(BuildContext context, List<Deck> visibleDecks) {
    if (visibleDecks.length != 1) return;
    if (isDeckScope) {
      goToDeck(context, visibleDecks.single);
      return;
    }

    goToListing(context, visibleDecks.single);
  }

  Future<void> createDeck(BuildContext context) async {
    setLoading(true);
    setError(null);
    try {
      final title = await DecksService.nextUntitledDeckTitle();
      final deck = Deck.createNow(
        profileId: LocalDB.profile.getOrCreate().id,
        title: title,
        isPublished: false,
      );

      await _deckDB.upsert(deck);
      load();

      if (context.mounted) {
        showViewDeckSingleSheet(context, deck);
      }
    } on Exception catch (e) {
      setError(e);
      setLoading(false);
      notifyListeners();
    }
  }

  Future<void> deleteDeck(String id) async {
    setLoading(true);
    setError(null);
    try {
      final deck = _deckDB.selectByPk({'id': id});
      if (deck == null) {
        setLoading(false);
        notifyListeners();
        return;
      }

      await DecksService.deleteDeckCascade(deck: deck);
      load();
    } on Exception catch (e) {
      setError(e);
      setLoading(false);
      notifyListeners();
    }
  }

  Future<void> deleteDecks(Iterable<String> ids) async {
    final deckIds = ids.toSet();
    if (deckIds.isEmpty) return;

    setLoading(true);
    setError(null);
    try {
      for (final id in deckIds) {
        final deck = _deckDB.selectByPk({'id': id});
        if (deck == null) continue;

        await DecksService.deleteDeckCascade(deck: deck);
      }
      load();
    } on Exception catch (e) {
      setError(e);
      setLoading(false);
      notifyListeners();
    }
  }

  void clearError() {
    setError(null);
    notifyListeners();
  }

  List<Deck> _withLocalListings(List<Deck> decks) {
    final listingsByDeckId = {
      for (final listing in LocalDB.deckListing.selectMany())
        listing.deckId: listing,
    };

    return [
      for (final deck in decks)
        deck.copyWith(listing: listingsByDeckId[deck.id] ?? deck.listing),
    ];
  }
}
