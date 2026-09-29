import 'package:boo_mondai/lib.barrel.dart'
    show LocalDB, SettingPath, SettingsRegistry, UserSettings;
import 'package:signals/signals_flutter.dart';

class SettingsStore {
  static final instance = SettingsStore();

  SettingsStore()
    : userSettings = signal(
        UserSettings.defaults(
          profileId: LocalDB.currentProfile.getOrCreate().id,
        ),
      );

  final Signal<UserSettings> userSettings;

  final registry = SettingsRegistry.instance;

  Future<void> init() async {
    final profileId = LocalDB.currentProfile.getOrCreate().id;
    final stored = LocalDB.userSettings.getOrCreateByProfileId(profileId);
    final values = registry.importValues(stored.preferences);
    final complete = stored.copyWith(
      preferences: registry.exportValues(values),
    );
    if (complete.preferences.toString() != stored.preferences.toString()) {
      await LocalDB.userSettings.upsert(complete);
    }
    userSettings.value = complete;
  }

  T get<T>(SettingPath path) {
    final setting = registry.get<T>(path);
    final preferences = userSettings.value.preferences;
    final raw = preferences[path.value];
    return (preferences.containsKey(path.value) ? raw : setting.defaultValue)
        as T;
  }

  Future<void> set<T>(SettingPath path, T value) async {
    final current = userSettings.value;
    final preferences = <String, dynamic>{
      ...current.preferences,
      path.value: value,
    };
    final updated = current.copyWith(
      preferences: preferences,
      updatedAt: DateTime.now(),
    );
    await LocalDB.userSettings.upsert(updated);
    userSettings.value = updated;
  }

  bool isVisible(SettingPath path) {
    final setting = registry.get<dynamic>(path);
    return setting.visibleWhen.every(
      (condition) =>
          get(registry.pathFor(condition.setting)) == condition.visibleOn,
    );
  }

  bool hasAccess(SettingPath path) {
    final setting = registry.get<dynamic>(path);
    if (setting.rolesWithAccess.isEmpty) return true;
    final role = LocalDB.currentProfile.getOrCreate().profileRole;
    return setting.rolesWithAccess.contains(role);
  }

  List<SettingPath> get paths => registry.settingsByPath.keys.toList();

  List<SettingPath> pathsForPage(String pagePath) =>
      paths.where((path) => path.pagePath == pagePath).toList();

  List<String> get pagePaths =>
      paths.map((path) => path.pagePath).toSet().toList()..sort();
}
