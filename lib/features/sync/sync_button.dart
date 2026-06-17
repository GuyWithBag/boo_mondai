// ── _SyncButton ─────────────────────────────────────────────────────────

import 'package:boo_mondai/lib.barrel.dart'
    show Button, SnackbarTone, showSnackbar;
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
      child: Button.icon(
        icon: Icons.sync_rounded,

        onPressed: () {
          if (!isAuthenticated) {
            showSnackbar(
              context: context,
              message: 'Sign in to sync your decks.',
              leading: const Icon(Icons.lock_outline),
              tone: SnackbarTone.dashed,
            );
            return;
          }
          onSync();
        },
      ),
    );
  }
}
