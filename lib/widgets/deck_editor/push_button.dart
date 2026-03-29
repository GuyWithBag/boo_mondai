// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/deck_editor/push_button.dart
// PURPOSE: Button to push local deck changes to the cloud
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';

class EditorPushButton extends StatelessWidget {
  const EditorPushButton({
    super.key,
    required this.isPushing,
    required this.onPressed,
  });

  final bool isPushing;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: Tooltip(
        message: 'Push changes to cloud',
        child: OutlinedButton.icon(
          onPressed: onPressed,
          icon: isPushing
              ? const SizedBox.square(
                  dimension: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.cloud_upload_outlined, size: 18),
          label: const Text('Push'),
        ),
      ),
    );
  }
}
