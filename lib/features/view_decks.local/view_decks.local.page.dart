// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/my_decks_page.dart
// PURPOSE: Lists user's decks with search, swipe-to-delete, and FAB to create new
// PROVIDERS: ViewDecksLocalController
// HOOKS: useEffect, useScrollController, useTextEditingController
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        ViewDecksLocalController,
        AuthController,
        Deck,
        ListingStatesWrapper,
        AppSnackbarTone,
        showAppSnackbar,
        SyncButton,
        DeckTile,
        showCreateDeckLocalSheet,
        EmptyState,
        CreateDeckTile;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

class ViewDecksLocalPage extends HookWidget {
  const ViewDecksLocalPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ViewDecksLocalController>();
    final auth = context.watch<AuthController>();
    // final scrollController = useScrollController();

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
        showAppSnackbar(
          context: context,
          message: 'Sync failed: $err',
          leading: const Icon(Icons.sync_problem_outlined),
          duration: const Duration(seconds: 3),
          tone: AppSnackbarTone.error,
        );
        controller.clearSyncError();
      });
      return null;
    }, [controller.syncError]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Decks'),
        actions: [
          SyncButton(
            isSyncing: controller.isSyncing,
            isAuthenticated: auth.service.isAuthenticatedRemote,
            onSync: () => controller.sync(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(100.0),
        child: _DeckListBody(
          error: controller.error,
          isLoading: controller.isLoading,
          onRetry: () {},
          onDeleteDeck: (id) {},
          onPressed: controller.goToDeck,
          decks: controller.decks,
        ),
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
    required this.onPressed,
  });

  final bool isLoading;
  final Exception? error;
  final List<Deck> decks;
  final VoidCallback onRetry;
  final Function(BuildContext context, Deck deck) onPressed;
  final void Function(String id) onDeleteDeck;

  @override
  Widget build(BuildContext context) {
    return ListingStatesWrapper<Deck>.wrap(
      isLoading: isLoading,
      items: decks,
      onRetry: onRetry,
      skeletonTile: DeckTile(deck: null),
      emptyState: EmptyState(
        icon: Icons.layers,
        title: 'No decks yet',
        message: 'Create your first deck to get started',
        action: ElevatedButton(
          child: Text('Create Deck'),
          onPressed: () => showCreateDeckLocalSheet(context),
        ),
      ),
      spacing: 100,
      leadingItem: CreateDeckTile(
        onPressed: () => showCreateDeckLocalSheet(context),
      ),
      itemBuilder: (_, _, deck) {
        return DeckTile(
          deck: deck,
          onPressed: () {
            onPressed(context, deck);
          },
        );
      },
    );
  }
}
