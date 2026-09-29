import 'package:boo_mondai/lib.barrel.dart' show ProfileRole;

import 'setting.tile_entry.dart';

class Setting<T> {
  const Setting({
    required this.defaultValue,
    this.disabled = false,
    this.rolesWithAccess = const {},
    this.visibleWhen = const {},
    this.description = '',
    this.tileEntry,
  });

  /// Default value used when no value has been persisted.
  final T defaultValue;
  final bool disabled;
  final Set<ProfileRole> rolesWithAccess;
  final Set<SettingVisibleWhen<dynamic>> visibleWhen;
  final String description;
  final SettingTileEntry<T>? tileEntry;
}

class SettingVisibleWhen<T> {
  const SettingVisibleWhen({required this.setting, required this.visibleOn});

  final Setting<T> setting;
  final T visibleOn;
}
