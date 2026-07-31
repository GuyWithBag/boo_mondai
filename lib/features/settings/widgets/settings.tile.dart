import 'package:boo_mondai/lib.barrel.dart' show PathHelper, StringHelper;
import 'package:flutter/material.dart';

import '../settings.barrel.dart'
    show Setting, SettingTileEntry, SettingsController;

class SettingsTile<T> extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.settingTileEntry,
    required this.settingsController,
  });

  final SettingTileEntry<T> settingTileEntry;
  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    final builder = settingTileEntry.builder;
    if (builder != null) {
      return builder(context, settingsController, settingTileEntry.setting);
    }

    final value = settingsController.get(settingTileEntry.setting);
    final label = StringHelper.toTitleCase(
      PathHelper.getLastPathSegmentOrFallback(
        settingTileEntry.setting.key,
        settingTileEntry.setting.key,
        separator: '.',
      ),
    );

    if (value is bool) {
      return SwitchListTile(
        title: Text(label),
        subtitle: Text(settingTileEntry.description),
        value: value,
        contentPadding: EdgeInsets.zero,
        onChanged: (next) => settingsController.set(
          settingTileEntry.setting as Setting<bool>,
          next,
        ),
      );
    }

    if (value is int) {
      return ListTile(
        title: Text(label),
        subtitle: Text(settingTileEntry.description),
        contentPadding: EdgeInsets.zero,
        trailing: Text(value.toString()),
      );
    }

    if (value is String) {
      return ListTile(
        title: Text(label),
        subtitle: Text(settingTileEntry.description),
        contentPadding: EdgeInsets.zero,
        trailing: Text(value),
      );
    }

    return ListTile(
      title: Text(label),
      subtitle: Text(settingTileEntry.description),
    );
  }
}
