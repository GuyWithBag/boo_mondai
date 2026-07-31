import 'package:boo_mondai/lib.barrel.dart' show SettingsService, LocalDB;

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
    final userId = LocalDB.profile.getOrCreate().id;
    final settings = LocalDB.userSettings.getOrCreateByUserId(userId);
    final retentionDays = settings.get(
      SettingsService.syncDeletionRetentionDays,
    );
    final activeClientWindowDays = settings.get(
      SettingsService.syncActiveClientWindowDays,
    );

    return SyncDeletionPolicy(
      retention: Duration(days: retentionDays),
      activeClientWindow: Duration(days: activeClientWindowDays),
    );
  }
}
