import 'package:boo_mondai/lib.barrel.dart'
    show
        Controller,
        CustomThemePreset,
        ThemeOverride,
        UserSettings,
        UserSettingsChangeLog,
        UserSettingsExportOptions,
        UserSettingsImportMode,
        UserSettingsService;
import 'package:flutter/material.dart' show ThemeMode;

/// UI-facing state holder for profile-scoped user settings workflows.
class UserSettingsController extends Controller {
  UserSettings? settings;
  List<UserSettingsChangeLog> latestChangeLogs = const [];
  List<String> latestFailures = const [];

  /// Loads settings for the active local profile.
  Future<void> loadCurrentProfile() async {
    setLoading(true);
    try {
      settings = await UserSettingsService.getOrCreateForCurrentProfile();
      latestChangeLogs = const [];
      latestFailures = const [];
    } on Exception catch (e) {
      setError(e);
    } finally {
      setLoading(false);
    }
  }

  /// Updates active profile theme mode.
  Future<void> updateThemeMode(ThemeMode mode) async {
    final current = settings;
    if (current == null) return;
    setLoading(true);
    try {
      settings = await UserSettingsService.updateThemeMode(
        userId: current.userId,
        themeMode: mode,
      );
      latestFailures = const [];
    } on Exception catch (e) {
      setError(e);
    } finally {
      setLoading(false);
    }
  }

  /// Updates active profile selected theme preset ids.
  Future<void> updateThemeSelections({
    String? lightThemePresetId,
    String? darkThemePresetId,
  }) async {
    final current = settings;
    if (current == null) return;
    setLoading(true);
    try {
      settings = await UserSettingsService.updateThemeSelections(
        userId: current.userId,
        lightThemePresetId: lightThemePresetId,
        darkThemePresetId: darkThemePresetId,
      );
      latestFailures = const [];
    } on Exception catch (e) {
      setError(e);
    } finally {
      setLoading(false);
    }
  }

  /// Replaces theme override payload.
  Future<void> updateThemeOverride(ThemeOverride? override) async {
    final current = settings;
    if (current == null) return;
    setLoading(true);
    try {
      settings = await UserSettingsService.updateThemeOverride(
        userId: current.userId,
        override: override,
      );
      latestFailures = const [];
    } on Exception catch (e) {
      setError(e);
    } finally {
      setLoading(false);
    }
  }

  /// Upserts one custom preset for the active profile.
  Future<void> upsertCustomPreset(CustomThemePreset preset) async {
    final current = settings;
    if (current == null) return;
    setLoading(true);
    try {
      settings = await UserSettingsService.upsertCustomPreset(
        userId: current.userId,
        preset: preset,
      );
      latestFailures = const [];
    } on Exception catch (e) {
      setError(e);
    } finally {
      setLoading(false);
    }
  }

  /// Removes one custom preset for the active profile.
  Future<void> removeCustomPreset(String presetId) async {
    final current = settings;
    if (current == null) return;
    setLoading(true);
    try {
      settings = await UserSettingsService.removeCustomPreset(
        userId: current.userId,
        presetId: presetId,
      );
      latestFailures = const [];
    } on Exception catch (e) {
      setError(e);
    } finally {
      setLoading(false);
    }
  }

  /// Exports settings as decoded JSON-friendly map.
  Future<Map<String, dynamic>?> exportSettings({
    UserSettingsExportOptions options = const UserSettingsExportOptions(),
  }) async {
    final current = settings;
    if (current == null) return null;
    setLoading(true);
    try {
      final result = await UserSettingsService.exportSettings(
        userId: current.userId,
        options: options,
      );
      latestChangeLogs = result.changeLogs;
      latestFailures = result.failures;
      return result.value;
    } on Exception catch (e) {
      setError(e);
      return null;
    } finally {
      setLoading(false);
    }
  }

  /// Exports settings as raw JSON string.
  Future<String?> exportSettingsJson({
    UserSettingsExportOptions options = const UserSettingsExportOptions(),
  }) async {
    final current = settings;
    if (current == null) return null;
    setLoading(true);
    try {
      final result = await UserSettingsService.exportSettingsJson(
        userId: current.userId,
        options: options,
      );
      latestChangeLogs = result.changeLogs;
      latestFailures = result.failures;
      return result.value;
    } on Exception catch (e) {
      setError(e);
      return null;
    } finally {
      setLoading(false);
    }
  }

  /// Imports settings from decoded payload.
  Future<void> importSettings({
    required Map<String, dynamic> payload,
    UserSettingsImportMode mode = UserSettingsImportMode.mergeCurrent,
  }) async {
    final current = settings;
    if (current == null) return;
    setLoading(true);
    try {
      final result = await UserSettingsService.importSettings(
        userId: current.userId,
        payload: payload,
        mode: mode,
      );
      settings = result.value;
      latestChangeLogs = result.changeLogs;
      latestFailures = result.failures;
    } on Exception catch (e) {
      setError(e);
    } finally {
      setLoading(false);
    }
  }

  /// Imports settings from raw JSON string.
  Future<void> importSettingsJson({
    required String rawJson,
    UserSettingsImportMode mode = UserSettingsImportMode.mergeCurrent,
  }) async {
    final current = settings;
    if (current == null) return;
    setLoading(true);
    try {
      final result = await UserSettingsService.importSettingsJson(
        userId: current.userId,
        rawJson: rawJson,
        mode: mode,
      );
      settings = result.value;
      latestChangeLogs = result.changeLogs;
      latestFailures = result.failures;
    } on Exception catch (e) {
      setError(e);
    } finally {
      setLoading(false);
    }
  }

  /// Runs local-to-remote sync for the active profile settings row.
  Future<void> syncNow() async {
    final current = settings;
    if (current == null) return;
    setLoading(true);
    try {
      settings = await UserSettingsService.syncForUser(current.userId);
      latestFailures = const [];
    } on Exception catch (e) {
      setError(e);
    } finally {
      setLoading(false);
    }
  }
}
