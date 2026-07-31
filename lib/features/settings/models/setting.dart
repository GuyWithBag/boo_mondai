/// Typed key for a single user preference stored in [UserSettings.preferences].
///
/// UI-visible keys use `<page-path>/<section>.<feature>`.
/// Add new settings here as a single line — no model changes required.
class Setting<T> {
  const Setting(this.key, this.defaultValue);

  /// Namespaced storage key, e.g. `'notifications/review.reminders_enabled'`.
  final String key;

  /// Value used when the key is absent from [UserSettings.preferences].
  final T defaultValue;
}
