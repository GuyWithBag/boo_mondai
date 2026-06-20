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
        DeckSearchFilterCodec,
        DeckSearchResults,
        FsrsCard,
        showViewDeckSingleSheet;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

class ViewDecksLocalController extends Controller {
  static const deckSearchFilterCodec = DeckSearchFilterCodec();
  static const deckSearchResults = DeckSearchResults();

  final DecksLocalDB _deckDB = LocalDB.deck;
  late final Listenable _deckListenable;

  ViewDecksLocalController() {
    _deckListenable = _deckDB.box.listenable();
    _deckListenable.addListener(load);
  }

  @override
  void dispose() {
    _deckListenable.removeListener(load);
    super.dispose();
  }

  // ── private state ────────────────────────────────────────

  List<Deck> _decks = [];

  // ── public getters ───────────────────────────────────────

  List<Deck> get decks => List.unmodifiable(_decks);

  // ── methods ──────────────────────────────────────────────

  void load() {
    setLoading(true);
    setError(null);
    notifyListeners();

    try {
      _decks = _deckDB.filterDecks();
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

  void loadOnNextFrame() {
    SchedulerBinding.instance.addPostFrameCallback((_) => load());
  }

  void submitSearch(BuildContext context, List<Deck> visibleDecks) {
    if (visibleDecks.length != 1) return;
    goToDeck(context, visibleDecks.single);
  }

  Future<void> createDeck(BuildContext context) async {
    setLoading(true);
    setError(null);
    try {
      final deck = Deck.createNow(
        userId: LocalDB.profile.getOrCreate().id,
        title: 'Untitled Deck',
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
      final studyCards = LocalDB.studyCard.getByDeckId(id);
      final studyCardIds = studyCards.map((card) => card.id).toSet();
      final fsrsCards = LocalDB.fsrsCard.selectMany(
        where: (card) => studyCardIds.contains(card.studyCardId),
      );
      final fsrsCardIds = fsrsCards.map((card) => card.id).toSet();
      final reviewLogs = LocalDB.reviewLog.selectMany(
        where: (log) => fsrsCardIds.contains(log.fsrsCardId),
      );

      await LocalDB.reviewLog.deleteManyByPk([
        for (final log in reviewLogs) {'id': log.id},
      ]);
      await LocalDB.fsrsCard.deleteManyByPk([
        for (final FsrsCard card in fsrsCards) {'id': card.id},
      ]);
      await LocalDB.studyCard.deleteByDeckId(id);
      await LocalDB.cardTemplate.deleteByDeckId(id);
      await _deckDB.deleteByPk({'id': id});
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
}
