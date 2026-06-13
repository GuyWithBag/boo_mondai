import 'package:boo_mondai/lib.barrel.dart'
    show DeckDownloadPlan, Deck, SyncChangeLog;

class DeckDownloadResult {
  const DeckDownloadResult({
    required this.deck,
    required this.plan,
    required this.alreadyDownloaded,
  });

  final Deck deck;
  final DeckDownloadPlan plan;
  final bool alreadyDownloaded;

  List<SyncChangeLog> get changes => plan.changes;
}
