import 'package:boo_mondai/lib.barrel.dart'
    show Setting, SettingsController, SettingPath;
import 'package:flutter/material.dart';

typedef SettingTileEntryBuilder<T> =
    Widget Function(
      BuildContext context,
      SettingsController ctrl,
      Setting<T> setting,
    );

class SettingTileEntry<T> {
  const SettingTileEntry({
    required this.setting,
    required this.description,
    this.visibleWhen,
    this.builder,
  });

  final Setting<T> setting;
  final String description;
  final bool Function(SettingsController ctrl)? visibleWhen;
  final SettingTileEntryBuilder<T>? builder;

  SettingPath get path => SettingPath.parse(setting.key);
}
