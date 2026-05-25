// ── _SyncButton ─────────────────────────────────────────────────────────

import 'package:boo_mondai/variant_styles/variant_styles.barrel.dart';
import 'package:boo_mondai/widgets/app_snackbar.dart';
import 'package:boo_mondai/widgets/tactile_button.dart';
import 'package:flutter/material.dart';

/// AppBar action that drives the deck sync operation.
///
/// Shows a spinner while syncing, a disabled cloud icon with a tooltip
/// when the user is a guest, and a tappable cloud icon when authenticated.
class SyncButton extends StatelessWidget {
  const SyncButton({
    super.key,
    required this.isSyncing,
    required this.isAuthenticated,
    required this.onSync,
  });

  final bool isSyncing;
  final bool isAuthenticated;
  final VoidCallback onSync;

  @override
  Widget build(BuildContext context) {
    if (isSyncing) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    return Tooltip(
      message: isAuthenticated ? 'Sync decks' : 'Sign in to sync',
      child: TactileButton.icon(
        icon: Icons.sync_rounded,
        tone: TactileTone.ghost,
        onPressed: () {
          if (!isAuthenticated) {
            showAppSnackbar(
              context: context,
              message: 'Sign in to sync your decks.',
              leading: const Icon(Icons.lock_outline),
              tone: AppSnackbarTone.dashed,
            );
            return;
          }
          onSync();
        },
      ),
    );
  }
}
