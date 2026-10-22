import 'package:boo_mondai/lib.barrel.dart' show SettingPath, SettingsStore;

class SyncDeletionPolicy {
  const SyncDeletionPolicy({
    required this.retention,
    required this.activeClientWindow,
  });

  static const defaultRetention = Duration(days: 90);
  static const defaultActiveClientWindow = Duration(days: 90);

  final Duration retention;
  final Duration activeClientWindow;

  bool get purgeImmediatelyAfterSyncSafety => retention == Duration.zero;

  DateTime purgeAfter(DateTime deletedAt) => deletedAt.add(retention);

  static SyncDeletionPolicy current() {
    final settingsStore = SettingsStore.instance;
    final retentionDays = settingsStore.get<int>(
      SettingPath.syncDeletionRetentionDays,
    );
    final activeClientWindowDays = settingsStore.get<int>(
      SettingPath.syncActiveClientWindowDays,
    );

    return SyncDeletionPolicy(
      retention: Duration(days: retentionDays),
      activeClientWindow: Duration(days: activeClientWindowDays),
    );
  }
}
