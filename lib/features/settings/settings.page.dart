import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../settings/models/app_setting.dart';
import 'settings.controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch so the page rebuilds when any setting changes.
    final ctrl = context.watch<SettingsController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          _SettingsSection(
            title: 'Notifications',
            children: [
              _SwitchTile(
                label: 'Review reminders',
                description: 'Daily reminder to review your due cards.',
                value: ctrl.get(AppSetting.reviewRemindersEnabled),
                onChanged: (v) =>
                    ctrl.set(AppSetting.reviewRemindersEnabled, v),
              ),
              if (ctrl.get(AppSetting.reviewRemindersEnabled))
                _TimeTile(
                  label: 'Review reminder time',
                  description: 'When to send the daily review reminder.',
                  hour: ctrl.get(AppSetting.reviewReminderHour),
                  minute: ctrl.get(AppSetting.reviewReminderMinute),
                  onTimePicked: (picked) async {
                    await ctrl.set(AppSetting.reviewReminderHour, picked.hour);
                    await ctrl.set(
                      AppSetting.reviewReminderMinute,
                      picked.minute,
                    );
                  },
                ),
              _SwitchTile(
                label: 'Streak reminders',
                description: 'Evening nudge to keep your streak alive.',
                value: ctrl.get(AppSetting.streakRemindersEnabled),
                onChanged: (v) =>
                    ctrl.set(AppSetting.streakRemindersEnabled, v),
              ),
              if (ctrl.get(AppSetting.streakRemindersEnabled))
                _TimeTile(
                  label: 'Streak reminder time',
                  description: 'When to send the streak reminder.',
                  hour: ctrl.get(AppSetting.streakReminderHour),
                  minute: ctrl.get(AppSetting.streakReminderMinute),
                  onTimePicked: (picked) async {
                    await ctrl.set(AppSetting.streakReminderHour, picked.hour);
                    await ctrl.set(
                      AppSetting.streakReminderMinute,
                      picked.minute,
                    );
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Section wrapper
// ---------------------------------------------------------------------------

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 4),
          child: Text(title.toUpperCase()),
        ),
        ...children,
        const Divider(height: 1),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Tile: Switch
// ---------------------------------------------------------------------------

class _SwitchTile extends StatelessWidget {
  const _SwitchTile({
    required this.label,
    required this.description,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(label),
      subtitle: Text(description),
      value: value,
      onChanged: onChanged,
    );
  }
}

// ---------------------------------------------------------------------------
// Tile: Time picker
// ---------------------------------------------------------------------------

class _TimeTile extends StatelessWidget {
  const _TimeTile({
    required this.label,
    required this.description,
    required this.hour,
    required this.minute,
    required this.onTimePicked,
  });

  final String label;
  final String description;
  final int hour;
  final int minute;
  final Future<void> Function(TimeOfDay picked) onTimePicked;

  String get _formatted {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  Future<void> _pick(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: hour, minute: minute),
    );
    if (picked != null) await onTimePicked(picked);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      subtitle: Text(description),
      trailing: TextButton(
        onPressed: () => _pick(context),
        child: Text(_formatted),
      ),
      onTap: () => _pick(context),
    );
  }
}
