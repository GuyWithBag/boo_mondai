// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/features/deck_downloads/models/download_checkpoint.dto.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:dart_mappable/dart_mappable.dart';

part 'download_checkpoint.dto.mapper.dart';

enum DownloadCheckpointStatus { downloading, paused }

@MappableClass()
class DownloadCheckpoint with DownloadCheckpointMappable {
  final String deckId; // remote deck id — the stable identity
  final String deckTitle;
  final int totalTemplates; // known after first page fetch
  final List<String> fetchedTemplateIds; // ids already written to Hive
  final List<String> downloadedAttachmentIds;
  final DownloadCheckpointStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DownloadCheckpoint({
    required this.deckId,
    required this.deckTitle,
    required this.totalTemplates,
    required this.fetchedTemplateIds,
    this.downloadedAttachmentIds = const [],
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  int get fetchedCount => fetchedTemplateIds.length;
  bool get isComplete => fetchedCount >= totalTemplates && totalTemplates > 0;
  double get progress =>
      totalTemplates == 0 ? 0 : (fetchedCount / totalTemplates).clamp(0.0, 1.0);
}
