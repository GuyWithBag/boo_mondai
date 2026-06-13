import 'package:boo_mondai/lib.barrel.dart'
    show CardTemplate, SyncChangeLog, Deck;

class DeckDownloadPlan {
  const DeckDownloadPlan({
    required this.remoteDeck,
    required this.localDeck,
    required this.remoteTemplates,
    required this.localTemplates,
    required this.changes,
  });

  final Deck remoteDeck;
  final Deck? localDeck;
  final List<CardTemplate> remoteTemplates;
  final List<CardTemplate> localTemplates;
  final List<SyncChangeLog> changes;

  bool get alreadyDownloaded => localDeck != null;
}
