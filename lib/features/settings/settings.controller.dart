import 'package:boo_mondai/lib.barrel.dart'
    show LocalDB, Controller, UserSettings, AppSetting;

class SettingsController extends Controller {
  UserSettings? _settings;

  UserSettings get settings {
    assert(
      _settings != null,
      'SettingsController.init() must be called before accessing settings',
    );
    return _settings!;
  }

  /// Reads or creates the UserSettings row for the current user.
  /// Call once at app start before the router is built.
  Future<void> init() async {
    final userId = LocalDB.profile.getOrCreate().id;
    _settings = LocalDB.userSettings.getOrCreateByUserId(userId);
    notifyListeners();
  }

  /// Returns the current value of [setting], falling back to its default.
  T get<T>(AppSetting<T> setting) => settings.get(setting);

  /// Persists [value] for [setting] and notifies listeners.
  /// No loading guard — Hive writes are synchronous/fast.
  Future<void> set<T>(AppSetting<T> setting, T value) async {
    final updated = settings
        .set(setting, value)
        .copyWith(updatedAt: DateTime.now());
    await LocalDB.userSettings.upsert(updated);
    _settings = updated;
    notifyListeners();
  }
}
