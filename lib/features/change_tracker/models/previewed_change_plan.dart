import 'package:boo_mondai/lib.barrel.dart' show ChangedEntity;

/// The result of a dry-run inspection: workflow-specific [payload] paired with
/// the [changes] that would be applied if the operation were confirmed.
///
/// Returned by preview methods such as
/// `DeckDownloadsService.previewDeckDownload()`. The [payload] carries
/// workflow-specific data (e.g. fetched remote records) needed to execute
/// the operation without re-fetching. The [changes] are passed to
/// [ChangeTrackerController.start] for user review.
class PreviewedChangePlan<TPayload, TEntity> {
  /// Creates a dry-run preview from workflow-specific [payload] and [changes].
  const PreviewedChangePlan({required this.payload, required this.changes});

  /// Workflow-specific data needed to apply the previewed operation.
  ///
  /// For example, deck sync stores a `DeckSyncPlanPayload` containing the
  /// sync steps that were already previewed. Deck download stores fetched
  /// remote deck records so applying the download does not need to fetch them
  /// again. The change tracker displays [changes]; the owning service uses
  /// [payload] when the user confirms the operation.
  final TPayload payload;

  /// User-facing records of what will change when the operation is applied.
  final List<ChangedEntity<TEntity>> changes;
}
