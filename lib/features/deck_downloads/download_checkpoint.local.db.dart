// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/features/deck_downloads/database/download_checkpoint.local.db.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/features/deck_downloads/models/download_checkpoint.dto.dart';
import 'package:boo_mondai/lib.barrel.dart' show HiveLocalDB;

class DownloadCheckpointLocalDB extends HiveLocalDB<DownloadCheckpoint> {
  @override
  String get boxName => 'download_checkpoints';

  @override
  Map<String, Object?> primaryKeyFromItem(DownloadCheckpoint item) => {
    'deck_id': item.deckId,
  };

  DownloadCheckpoint? getByDeckId(String deckId) =>
      selectByPk({'deck_id': deckId});

  List<DownloadCheckpoint> getPaused() => selectMany(
    where: (c) => c.status == DownloadCheckpointStatus.paused && !c.isComplete,
  );

  List<DownloadCheckpoint> getDownloading() => selectMany(
    where: (c) =>
        c.status == DownloadCheckpointStatus.downloading && !c.isComplete,
  );
}
