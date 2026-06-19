/// Feature workflow that produced a change-review plan.
enum ChangeSource {
  /// Local/remote database synchronization.
  sync,

  /// Downloading a published deck into the local library.
  deckDownload,

  /// Importing or exporting user data.
  importExport,
}
