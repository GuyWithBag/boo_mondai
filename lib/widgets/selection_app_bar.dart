// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/selection_app_bar.dart
// PURPOSE: Shared multi-select app bar with count, cancel, and delete actions
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';

class SelectionAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SelectionAppBar({
    super.key,
    required this.count,
    required this.onCancel,
    required this.onDelete,
    this.extraActions,
  });

  final int count;
  final VoidCallback onCancel;
  final VoidCallback onDelete;
  final List<Widget>? extraActions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AppBar(
      backgroundColor: scheme.primaryContainer,
      leading: IconButton(
        icon: const Icon(Icons.close),
        tooltip: 'Cancel selection',
        onPressed: onCancel,
      ),
      title: Text(
        '$count selected',
        style: TextStyle(color: scheme.onPrimaryContainer),
      ),
      actions: [
        ...?extraActions,
        Tooltip(
          message: 'Delete selected',
          child: IconButton(
            icon: const Icon(Icons.delete_outline),
            color: scheme.error,
            onPressed: onDelete,
          ),
        ),
      ],
    );
  }
}
