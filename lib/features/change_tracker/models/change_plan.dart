import 'package:boo_mondai/lib.barrel.dart' show ChangedEntity;

/// The result of a dry-run inspection: a typed [payload] paired with the
/// [changes] that would be applied if the operation were confirmed.
///
/// Returned by preview methods such as
/// `DeckDownloadsService.previewDeckDownload()`. The [payload] carries
/// workflow-specific data (e.g. fetched remote records) needed to execute
/// the operation without re-fetching. The [changes] are passed to
/// [ChangeTrackerController.start] for user review.
class ChangePlan<TPayload, TEntity> {
  /// Creates a dry-run preview from workflow-specific [payload] and [changes].
  const ChangePlan({required this.payload, required this.changes});

  /// Workflow-specific data needed to apply the previewed operation.
  final TPayload payload;

  /// User-facing records of what will change when the operation is applied.
  final List<ChangedEntity<TEntity>> changes;
}
