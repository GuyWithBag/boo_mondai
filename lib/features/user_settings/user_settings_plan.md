# User Settings Feature Plan

## Note:
Use dart_mappable for app_tokens and whatever you need.

## Feature Name

Use `user_settings`.

This feature should own persisted user preferences and app-level customization choices. It should not replace `core/theme`, which defines built-in theme tokens and presets, or `features/app_theme`, which defines reusable themed UI components.

If imported custom themes grow into a larger product area later, split that into `theme_library`, but start with `user_settings` so theme choices live beside the rest of the user's preferences.

## Goals

- Store settings locally first.
- Scope settings per local profile.
- Provide sync methods later, without adding UI yet.
- Persist selected light theme, selected dark theme, `ThemeMode`, user overrides, and imported custom theme presets.
- Support theme import/export through JSON.
- Keep settings as latest-state only, without edit logs or backup history.
- Make imported themes selectable presets.
- Avoid mutating built-in theme presets directly.

## Proposed Directory

```text
lib/features/user_settings/
  user_settings.barrel.dart
  user_settings.controller.dart
  user_settings.local.db.dart
  user_settings.remote.db.dart
  user_settings.service.dart
  user_settings_plan.md
  models/
    models.barrel.dart
    user_settings.dto.dart
    user_settings.dto.mapper.dart
    theme_override.dto.dart
    theme_override.dto.mapper.dart
    custom_theme_preset.dto.dart
    custom_theme_preset.dto.mapper.dart
```

`user_settings.remote.db.dart` can be added when the Supabase schema exists. Until then, the service can expose a sync method placeholder or keep sync support planned but unimplemented.

## Data Shape

`UserSettings` should be one row per profile.

Recommended fields:

- `id`: stable settings row ID, probably profile ID or `settings:<profileId>`.
- `profileId`: owner profile.
- `themeMode`: `system`, `light`, or `dark`.
- `lightThemePresetId`: selected light preset.
- `darkThemePresetId`: selected dark preset.
- `themeOverrides`: nullable user override object.
- `customThemePresets`: imported custom presets.
- `createdAt`.
- `updatedAt`.

Use latest-state only. Do not add local setting edit logs unless settings changes later become auditable or collaborative.

## Theme Overrides

Editable override fields means: which parts of the active theme can the user customize without importing a whole new theme.

Recommended first version:

- `primaryColor`
- `fontFamily`
- `radiusScale`
- `spacingScale`
- `textScale`
- `highContrast`
- `reducedMotion`

These should be optional. If a field is null, use the selected preset's original token value.

The override should be applied through `ThemeVariantsController.transform`, not by changing the registered built-in `ThemeVariant` objects. Built-in presets should remain immutable.

## Custom Theme Presets

Imported themes should become selectable presets.

Because `ThemeData` is too large and unstable to serialize directly, custom themes should store app-level token JSON, not raw Flutter `ThemeData`.

Recommended custom preset fields:

- `id`
- `name`
- `lightTokens`
- `darkTokens`
- `createdAt`
- `updatedAt`
- `source`: `imported`, `created`, or `synced`
- `schemaVersion`

At runtime, convert token DTOs into `AppTokens`, then build `ThemeData` using the same theme builder pattern as `core/theme/app_theme.dart`.

## Import And Export

Theme/settings import/export should accept both decoded JSON maps and raw JSON strings.

Export options should be configurable:

- Include selected theme IDs.
- Include user overrides.
- Include custom theme presets.
- Include all settings.

Import options should support:

- Replace current settings.
- Merge into current settings.
- Import custom themes only.
- Import overrides only.
- Skip invalid custom presets while returning per-item errors.

The service should return change logs, similar to `import_export`, but not persist those logs.

## Unknown Theme Tokens

Unknown token fields are fields present in imported JSON that the current app version does not recognize.

This can happen when:

- A newer app exports a theme and an older app imports it.
- A theme file was edited manually.
- A future token schema adds fields that this version does not know yet.

Recommended behavior: preserve unknown fields inside an `extraTokens` map on custom theme token DTOs.

Why preserve them:

- The app can round-trip a theme file without silently deleting newer fields.
- Future app versions may understand those fields.
- It makes imports more forgiving while still validating the fields the current app actually uses.

Known invalid values should still be rejected or ignored with a warning. Example: an invalid color string for `primaryColor` should not be applied.

## Sync

Local-first is the initial behavior.

Later, a sync button can call a user settings sync method. The current generic `SyncService` may work if `UserSettings` extends `DTO` and has `id`, `createdAt`, and `updatedAt`, but there are concerns:

- `SyncService` filters remote records by `user_id`; the settings DTO/table must use that column name or the generic service needs a filter override.
- Settings are single-row-per-profile data, while the generic service is list-oriented. It can still work, but a settings-specific wrapper should enforce one settings row per profile.
- Conflict resolution is newest `updatedAt` wins. That is acceptable for first sync, but it may overwrite one device's theme edits if another device updated later.

Recommended service method:

```dart
Future<UserSettings> syncSettings({required String profileId})
```

Internally, it can use `SyncService` if the DTO/table matches its assumptions. Otherwise, create a settings-specific sync path that pulls the one remote row, compares `updatedAt`, and upserts the winner.

## Service Responsibilities

`UserSettingsService` should:

- Get or create settings for the current profile.
- Update theme mode.
- Update selected light/dark preset IDs.
- Update user overrides.
- Add, update, and remove custom theme presets.
- Import settings/theme JSON from a map or string.
- Export settings/theme JSON.
- Build a `ThemeVariantsController` or provide data needed to configure one.
- Expose sync methods later.

## Controller Responsibilities

`UserSettingsController` should:

- Load current profile settings.
- Hold editable settings state.
- Call service methods for save/import/export.
- Expose latest change logs and errors.
- Notify listeners when settings change.

No widgets in the first implementation.

## App Theme Integration

Current app setup creates the theme controller inside `BooMondaiApp`:

```dart
final controller = useMemoized(createAppThemeController);
```

To support persisted settings, this flow eventually needs to load settings before or during app startup.

Possible approach:

1. Initialize local DB.
2. Load current profile settings.
3. Build a theme registry that includes built-in presets plus custom presets.
4. Create `ThemeVariantsController` with selected light/dark IDs and mode.
5. Apply user overrides through `transform`.

If settings load asynchronously inside the app widget, the app needs a small loading state or default theme fallback.

## Concerns

- `AppTokens` is currently a Dart record typedef. Records do not have `copyWith`, so applying many overrides will be verbose. If theme customization grows, convert tokens to a class with `copyWith`.
- Imported themes need schema versions because token names will change over time.
- Imported color values need validation and contrast checks.
- Font families should probably be restricted to bundled or known fonts. Arbitrary font names may render inconsistently.
- Numeric overrides need bounds. Bad radius, spacing, or text scale values can break layouts.
- Imported presets should not be allowed to collide with built-in preset IDs unless the import mode explicitly replaces a custom preset.
- The app currently only registers the `boomondai` preset. Custom presets require dynamic registry construction.
- Sync should be added only after a remote table exists and the single-row-per-profile behavior is clear.

## Non-Goals For First Pass

- No settings UI.
- No remote sync implementation unless the table already exists.
- No binary theme assets.
- No online theme marketplace.
- No persistent change-log table.
