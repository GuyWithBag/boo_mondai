import 'package:boo_mondai/lib.barrel.dart'
    show PathHelper, StringHelper, SettingPath, SettingsStore;
import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.path,
    required this.settingsStore,
  });

  final SettingPath path;
  final SettingsStore settingsStore;

  @override
  Widget build(BuildContext context) {
    final setting = settingsStore.registry.get<dynamic>(path);
    final value = settingsStore.get<dynamic>(path);
    final label = StringHelper.toTitleCase(
      PathHelper.getLastPathSegmentOrFallback(
        setting.tileEntry?.label ?? path.name,
        path.name,
      ),
    );

    if (value is bool) {
      return SwitchListTile(
        title: Text(label),
        subtitle: Text(setting.description),
        value: value,
        contentPadding: EdgeInsets.zero,
        onChanged: setting.disabled
            ? null
            : (next) => settingsStore.set<bool>(path, next),
      );
    }

    return ListTile(
      title: Text(label),
      subtitle: Text(setting.description),
      contentPadding: EdgeInsets.zero,
      trailing: value == null ? null : Text(value.toString()),
    );
  }
}
