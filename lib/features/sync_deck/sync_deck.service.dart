import 'package:boo_mondai/lib.barrel.dart' show SyncTable;
import 'package:boo_mondai/features/sync_deck/sync_tables/sync_tables.barrel.dart';

abstract final class SyncDeckService {
  static List<SyncTable<dynamic>> getTables({String? deckId}) {
    return <SyncTable<dynamic>>[
      DeckSyncTable(deckId: deckId),
      DeckListingSyncTable(deckId: deckId),
      CardTemplateSyncTable(deckId: deckId),
      StudyCardSyncTable(deckId: deckId),
      FsrsCardSyncTable(deckId: deckId),
      ReviewLogSyncTable(deckId: deckId),
    ];
  }
}
