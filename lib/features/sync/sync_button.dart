// ── _SyncButton ─────────────────────────────────────────────────────────

import 'package:boo_mondai/lib.barrel.dart'
    show
        Button,
        ButtonColor,
        ButtonSize,
        SnackbarColor,
        SnackbarVariant,
        showSnackbar,
        ButtonPadding;
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
    return Tooltip(
      message: isAuthenticated ? 'Sync decks' : 'Sign in to sync',
      child: Button(
        variants: [ButtonColor.primary, ButtonSize.icon, ButtonPadding.none],
        onPressed: () {
          if (!isAuthenticated) {
            showSnackbar(
              context,
              message: 'Sign in to sync your decks.',
              leading: const Icon(Icons.lock_outline),
              color: SnackbarColor.muted,
              variant: SnackbarVariant.dashed,
            );
            return;
          }
          onSync();
        },
        child: isSyncing
            ? CircularProgressIndicator(strokeWidth: 2)
            : Icon(Icons.sync_rounded),
      ),
    );
  }
}
