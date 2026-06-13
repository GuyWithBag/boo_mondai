import 'package:boo_mondai/lib.barrel.dart' show CardTemplate, Deck;

class DeckDownloadPayload {
  const DeckDownloadPayload({
    required this.remoteDeck,
    required this.localDeck,
    required this.remoteTemplates,
    required this.localTemplates,
    this.downloadedDeck,
  });

  final Deck remoteDeck;
  final Deck? localDeck;
  final List<CardTemplate> remoteTemplates;
  final List<CardTemplate> localTemplates;
  final Deck? downloadedDeck;

  bool get alreadyDownloaded => localDeck != null;
  Deck? get deck => downloadedDeck ?? localDeck;

  DeckDownloadPayload copyWith({Deck? downloadedDeck}) {
    return DeckDownloadPayload(
      remoteDeck: remoteDeck,
      localDeck: localDeck,
      remoteTemplates: remoteTemplates,
      localTemplates: localTemplates,
      downloadedDeck: downloadedDeck ?? this.downloadedDeck,
    );
  }
}
