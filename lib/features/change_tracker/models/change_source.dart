/// Feature workflow that produced a change-review plan.
///
/// Entries are filtered by source in feature-specific screens, such as the
/// sync page and the deck download list.
enum ChangeSource {
  /// Local/remote database synchronization.
  sync,

  /// Downloading a published deck into the local library.
  deckDownload,

  /// Importing or exporting user data.
  importExport,
}
