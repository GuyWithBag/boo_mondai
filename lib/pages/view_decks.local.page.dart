// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/my_decks_page.dart
// PURPOSE: Lists user's decks with search, swipe-to-delete, and FAB to create new
// PROVIDERS: ViewDecksLocalController
// HOOKS: useEffect, useScrollController, useTextEditingController
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/controllers/controllers.barrel.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ViewDecksLocalPage extends HookWidget {
  const ViewDecksLocalPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ViewDecksLocalController>();
    final auth = context.watch<AuthController>();
    // final scrollController = useScrollController();
    final searchController = useTextEditingController();
    final searchQuery = useState('');

    useEffect(() {
      // Defer past the current build frame to avoid
      // "setState called during build" when mounted inside a LayoutBuilder.
      SchedulerBinding.instance.addPostFrameCallback((_) => controller.load());
      return null;
    }, const []);

    // Show a snackbar whenever a sync error arrives.
    useEffect(() {
      final err = controller.syncError;
      if (err == null) return null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sync failed: $err'),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: () => controller.sync(),
            ),
          ),
        );
        controller.clearSyncError();
      });
      return null;
    }, [controller.syncError]);

    useEffect(() {
      void listener() => searchQuery.value = searchController.text;
      searchController.addListener(listener);
      return () => searchController.removeListener(listener);
    }, [searchController]);

    final filteredDecks = controller.decks.where((deck) {
      final q = searchQuery.value.trim().toLowerCase();
      if (q.isEmpty) return true;
      return deck.title.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Decks'),
        actions: [
          _SyncButton(
            isSyncing: controller.isSyncing,
            isAuthenticated: !auth.currentProfile.isAnonymous,
            onSync: () => controller.sync(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/decks-local/create'),
        tooltip: 'New Deck',
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          SearchBar(controller: searchController),
          Expanded(
            child: _DeckListBody(
              isLoading: controller.isLoading,
              error: controller.error,
              decks: filteredDecks,
              onRetry: controller.load,
              onDeleteDeck: controller.deleteDeck,
            ),
          ),
        ],
      ),
    );
  }
}

// ── _DeckListBody ─────────────────────────────────────────────────────────────

class _DeckListBody extends StatelessWidget {
  const _DeckListBody({
    required this.isLoading,
    required this.error,
    required this.decks,
    required this.onRetry,
    required this.onDeleteDeck,
  });

  final bool isLoading;
  final Exception? error;
  final List<Deck> decks;
  final VoidCallback onRetry;
  final void Function(String id) onDeleteDeck;

  @override
  Widget build(BuildContext context) {
    return ListingStatesWrapper<Deck>.list(
      isLoading: isLoading,
      items: decks,
      onRetry: onRetry,
      skeletonTile: DeckCardTile(deck: null),
      emptyState: EmptyState(
        icon: Icons.layers,
        title: 'No decks yet',
        message: 'Create your first deck to get started',
        action: ElevatedButton(
          child: Text('Create Deck'),
          onPressed: () => context.push('/decks-local/create'),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md.w,
        vertical: AppSpacing.sm.h,
      ),
      itemBuilder: (_, _, deck) {
        return Dismissible(
          key: ValueKey(deck.id),
          direction: DismissDirection.horizontal,
          // background: _DismissBackground(alignment: Alignment.centerLeft),
          // secondaryBackground: _DismissBackground(
          //   alignment: Alignment.centerRight,
          // ),
          onDismissed: (_) => onDeleteDeck(deck.id),
          child: DeckCardTile(deck: deck),
        );
      },
    );
  }
}

// // ── _DismissBackground ────────────────────────────────────────────────────────

// class _DismissBackground extends StatelessWidget {
//   const _DismissBackground({required this.alignment});

//   final Alignment alignment;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: AppColors.incorrect,
//         borderRadius: BorderRadius.circular(16.r),
//       ),
//       alignment: alignment,
//       padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
//       child: const Icon(Icons.delete_outline, color: Colors.white),
//     );
//   }
// }

// ── _SyncButton ─────────────────────────────────────────────────────────

/// AppBar action that drives the deck sync operation.
///
/// Shows a spinner while syncing, a disabled cloud icon with a tooltip
/// when the user is a guest, and a tappable cloud icon when authenticated.
class _SyncButton extends StatelessWidget {
  const _SyncButton({
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
      child: IconButton(
        icon: Icon(
          Icons.sync_rounded,
          color: isAuthenticated ? null : Theme.of(context).disabledColor,
        ),
        onPressed: isAuthenticated ? onSync : null,
      ),
    );
  }
}
