// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/deck_creator/publish_toggle.dart
// PURPOSE: Switch row to toggle deck public/private visibility
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';

class PublishToggle extends StatelessWidget {
  const PublishToggle({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      color: scheme.surfaceContainerHighest,
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        title: const Text('Publish to public browser'),
        subtitle: Text(
          value
              ? 'Anyone can find and copy this deck'
              : 'Only you can see this deck',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
        ),
        secondary: Icon(
          value ? Icons.public : Icons.lock_outline,
          color: value ? scheme.primary : AppColors.textSecondary,
        ),
      ),
    );
  }
}
