// import 'dart:convert';

// import 'package:boo_mondai/lib.barrel.dart'
//     show
//         CustomThemePreset,
//         LocalDB,
//         RemoteDB,
//         SyncService,
//         ThemeOverride,
//         ThemeOverrideMapper,
//         UserSettings,
//         CustomThemePresetMapper,
//         UserSettingsChangeRecord,
//         UserSettingsChangeType,
//         UserSettingsExportOptions,
//         UserSettingsImportMode,
//         UserSettingsOperationResult,
//         uuid;
// import 'package:flutter/material.dart' show ThemeMode;

// /// Static operations for reading and mutating profile-scoped user settings.
// class UserSettingsService {
//   const UserSettingsService._();

//   /// Returns existing settings for [userId], or creates a default row.
//   static Future<UserSettings> getOrCreateForUser(String userId) async {
//     final existing = LocalDB.userSettings.getByUserId(userId);
//     if (existing != null) return existing;

//     final now = DateTime.now();
//     final created = UserSettings(
//       id: uuid.v7(),
//       userId: userId,
//       themeModeName: ThemeMode.system.name,
//       lightThemePresetId: 'boomondai',
//       darkThemePresetId: 'boomondai',
//       createdAt: now,
//       updatedAt: now,
//     );
//     await LocalDB.userSettings.upsert(created);
//     return created;
//   }

//   /// Loads settings for the active local profile.
//   static Future<UserSettings> getOrCreateForCurrentProfile() async {
//     final profile = LocalDB.profile.getOrCreate();
//     return getOrCreateForUser(profile.id);
//   }

//   /// Updates the selected theme mode for [userId].
//   static Future<UserSettings> updateThemeMode({
//     required String userId,
//     required ThemeMode themeMode,
//   }) async {
//     final current = await getOrCreateForUser(userId);
//     final updated = current.copyWith(
//       themeModeName: themeMode.name,
//       updatedAt: DateTime.now(),
//     );
//     await LocalDB.userSettings.upsert(updated);
//     return updated;
//   }

//   /// Updates selected light/dark preset ids for [userId].
//   static Future<UserSettings> updateThemeSelections({
//     required String userId,
//     String? lightThemePresetId,
//     String? darkThemePresetId,
//   }) async {
//     final current = await getOrCreateForUser(userId);
//     final updated = current.copyWith(
//       lightThemePresetId: lightThemePresetId ?? current.lightThemePresetId,
//       darkThemePresetId: darkThemePresetId ?? current.darkThemePresetId,
//       updatedAt: DateTime.now(),
//     );
//     await LocalDB.userSettings.upsert(updated);
//     return updated;
//   }

//   /// Replaces theme overrides for [userId].
//   static Future<UserSettings> updateThemeOverride({
//     required String userId,
//     ThemeOverride? override,
//   }) async {
//     final current = await getOrCreateForUser(userId);
//     final updated = current.copyWith(
//       themeOverride: override,
//       updatedAt: DateTime.now(),
//     );
//     await LocalDB.userSettings.upsert(updated);
//     return updated;
//   }

//   /// Inserts or updates one custom preset in [userId] settings.
//   static Future<UserSettings> upsertCustomPreset({
//     required String userId,
//     required CustomThemePreset preset,
//   }) async {
//     final current = await getOrCreateForUser(userId);
//     final presets = [...current.customThemePresets];
//     final index = presets.indexWhere((item) => item.id == preset.id);
//     final now = DateTime.now();
//     if (index == -1) {
//       presets.add(preset.copyWith(createdAt: preset.createdAt, updatedAt: now));
//     } else {
//       presets[index] = preset.copyWith(
//         createdAt: presets[index].createdAt,
//         updatedAt: now,
//       );
//     }

//     final updated = current.copyWith(
//       customThemePresets: presets,
//       updatedAt: now,
//     );
//     await LocalDB.userSettings.upsert(updated);
//     return updated;
//   }

//   /// Removes one custom preset from [userId] settings.
//   static Future<UserSettings> removeCustomPreset({
//     required String userId,
//     required String presetId,
//   }) async {
//     final current = await getOrCreateForUser(userId);
//     final remaining = current.customThemePresets
//         .where((item) => item.id != presetId)
//         .toList(growable: false);

//     final nextLight = current.lightThemePresetId == presetId
//         ? 'boomondai'
//         : current.lightThemePresetId;
//     final nextDark = current.darkThemePresetId == presetId
//         ? 'boomondai'
//         : current.darkThemePresetId;

//     final updated = current.copyWith(
//       customThemePresets: remaining,
//       lightThemePresetId: nextLight,
//       darkThemePresetId: nextDark,
//       updatedAt: DateTime.now(),
//     );
//     await LocalDB.userSettings.upsert(updated);
//     return updated;
//   }

//   /// Exports current settings to JSON-friendly map using [options].
//   static Future<UserSettingsOperationResult<Map<String, dynamic>>>
//   exportSettings({
//     required String userId,
//     UserSettingsExportOptions options = const UserSettingsExportOptions(),
//   }) async {
//     final settings = await getOrCreateForUser(userId);
//     final payload = <String, dynamic>{
//       'format': 'boo_mondai_user_settings_v1',
//       'user_id': userId,
//       'exported_at': DateTime.now().toIso8601String(),
//       'schema_version': 1,
//     };

//     if (options.includeThemeMode) {
//       payload['theme_mode'] = settings.themeModeName;
//     }
//     if (options.includeSelections) {
//       payload['light_theme_preset_id'] = settings.lightThemePresetId;
//       payload['dark_theme_preset_id'] = settings.darkThemePresetId;
//     }
//     if (options.includeOverrides) {
//       payload['theme_override'] = settings.themeOverride?.toMap();
//     }
//     if (options.includeCustomPresets) {
//       payload['custom_theme_presets'] = [
//         for (final preset in settings.customThemePresets) preset.toMap(),
//       ];
//     }

//     return UserSettingsOperationResult(
//       value: payload,
//       changeLogs: [
//         UserSettingsChangeRecord(
//           type: UserSettingsChangeType.created,
//           type: 'user_settings',
//           id: settings.id,
//           message: 'Exported user settings for profile $userId.',
//         ),
//       ],
//     );
//   }

//   /// Exports current settings to JSON string.
//   static Future<UserSettingsOperationResult<String>> exportSettingsJson({
//     required String userId,
//     UserSettingsExportOptions options = const UserSettingsExportOptions(),
//   }) async {
//     final result = await exportSettings(userId: userId, options: options);
//     return UserSettingsOperationResult(
//       value: jsonEncode(result.value),
//       changeLogs: result.changeLogs,
//       failures: result.failures,
//     );
//   }

//   /// Imports settings from decoded [payload] using [mode].
//   static Future<UserSettingsOperationResult<UserSettings>> importSettings({
//     required String userId,
//     required Map<String, dynamic> payload,
//     UserSettingsImportMode mode = UserSettingsImportMode.mergeCurrent,
//   }) async {
//     final current = await getOrCreateForUser(userId);
//     final logs = <UserSettingsChangeRecord>[];
//     final failures = <String>[];
//     final now = DateTime.now();

//     var themeModeName = current.themeModeName;
//     var lightThemePresetId = current.lightThemePresetId;
//     var darkThemePresetId = current.darkThemePresetId;
//     ThemeOverride? themeOverride = current.themeOverride;
//     var customThemePresets = <CustomThemePreset>[...current.customThemePresets];

//     if (mode == UserSettingsImportMode.replaceCurrent) {
//       themeOverride = null;
//       customThemePresets = [];
//     }

//     final rawThemeMode = payload['theme_mode'];
//     if (rawThemeMode is String &&
//         (rawThemeMode == 'system' ||
//             rawThemeMode == 'light' ||
//             rawThemeMode == 'dark')) {
//       themeModeName = rawThemeMode;
//       logs.add(
//         UserSettingsChangeRecord(
//           type: UserSettingsChangeType.updated,
//           type: 'user_settings',
//           id: current.id,
//           message: 'Updated theme mode to $rawThemeMode.',
//         ),
//       );
//     }

//     final rawLightPreset = payload['light_theme_preset_id'];
//     if (rawLightPreset is String && rawLightPreset.trim().isNotEmpty) {
//       lightThemePresetId = rawLightPreset.trim();
//       logs.add(
//         UserSettingsChangeRecord(
//           type: UserSettingsChangeType.updated,
//           type: 'user_settings',
//           id: current.id,
//           message: 'Updated light preset to $lightThemePresetId.',
//         ),
//       );
//     }

//     final rawDarkPreset = payload['dark_theme_preset_id'];
//     if (rawDarkPreset is String && rawDarkPreset.trim().isNotEmpty) {
//       darkThemePresetId = rawDarkPreset.trim();
//       logs.add(
//         UserSettingsChangeRecord(
//           type: UserSettingsChangeType.updated,
//           type: 'user_settings',
//           id: current.id,
//           message: 'Updated dark preset to $darkThemePresetId.',
//         ),
//       );
//     }

//     final rawOverride = payload['theme_override'];
//     if (rawOverride is Map<String, dynamic>) {
//       themeOverride = ThemeOverrideMapper.fromMap(rawOverride);
//       logs.add(
//         UserSettingsChangeRecord(
//           type: UserSettingsChangeType.updated,
//           type: 'theme_override',
//           id: current.id,
//           message: 'Updated theme override payload.',
//         ),
//       );
//     } else if (rawOverride is Map) {
//       themeOverride = ThemeOverrideMapper.fromMap(
//         Map<String, dynamic>.from(rawOverride),
//       );
//       logs.add(
//         UserSettingsChangeRecord(
//           type: UserSettingsChangeType.updated,
//           type: 'theme_override',
//           id: current.id,
//           message: 'Updated theme override payload.',
//         ),
//       );
//     }

//     final rawPresets = payload['custom_theme_presets'];
//     if (rawPresets is List) {
//       final imported = <CustomThemePreset>[];
//       for (var i = 0; i < rawPresets.length; i++) {
//         final row = rawPresets[i];
//         try {
//           final rowMap = row is Map<String, dynamic>
//               ? row
//               : Map<String, dynamic>.from(row as Map);
//           final preset = CustomThemePresetMapper.fromMap(rowMap);
//           imported.add(
//             preset.copyWith(createdAt: preset.createdAt, updatedAt: now),
//           );
//         } on Exception catch (e) {
//           failures.add('custom_theme_presets[$i]: $e');
//         }
//       }

//       if (mode == UserSettingsImportMode.replaceCurrent) {
//         customThemePresets = imported;
//       } else {
//         final byId = {
//           for (final preset in customThemePresets) preset.id: preset,
//         };
//         for (final preset in imported) {
//           byId[preset.id] = preset;
//         }
//         customThemePresets = byId.values.toList(growable: false);
//       }

//       logs.add(
//         UserSettingsChangeRecord(
//           type: UserSettingsChangeType.updated,
//           type: 'custom_theme_preset',
//           id: current.id,
//           message: 'Imported ${imported.length} custom theme presets.',
//         ),
//       );
//     }

//     final updated = current.copyWith(
//       themeModeName: themeModeName,
//       lightThemePresetId: lightThemePresetId,
//       darkThemePresetId: darkThemePresetId,
//       themeOverride: themeOverride,
//       customThemePresets: customThemePresets,
//       updatedAt: now,
//     );
//     await LocalDB.userSettings.upsert(updated);

//     return UserSettingsOperationResult(
//       value: updated,
//       changeLogs: logs,
//       failures: failures,
//     );
//   }

//   /// Imports settings from raw JSON string.
//   static Future<UserSettingsOperationResult<UserSettings>> importSettingsJson({
//     required String userId,
//     required String rawJson,
//     UserSettingsImportMode mode = UserSettingsImportMode.mergeCurrent,
//   }) async {
//     final decoded = jsonDecode(rawJson);
//     if (decoded is! Map) {
//       throw Exception('Settings import payload must decode to a JSON object.');
//     }
//     return importSettings(
//       userId: userId,
//       payload: Map<String, dynamic>.from(decoded),
//       mode: mode,
//     );
//   }

//   /// Syncs local settings row for [userId] with remote settings table.
//   static Future<UserSettings> syncForUser(String userId) async {
//     await getOrCreateForUser(userId);
//     await SyncService.syncImmediately<UserSettings>(
//       localDb: LocalDB.userSettings,
//       remoteDb: RemoteDB.userSettings,
//       userId: userId,
//       localWhere: (item) => item.userId == userId,
//     );
//     return getOrCreateForUser(userId);
//   }
// }
