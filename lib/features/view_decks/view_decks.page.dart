// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/my_decks_page.dart
// PURPOSE: Lists user's decks with search, swipe-to-delete, and FAB to create new
// PROVIDERS: ViewDecksLocalController
// HOOKS: useEffect, useScrollController, useTextEditingController
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        Button,
        ChangeTrackerController,
        CreateDeckTile,
        Deck,
        DeckSearchFilter,
        DeckTile,
        DeckTileState,
        EmptyState,
        FilteredSearchBar,
        ImportFileStatus,
        ImportExportController,
        ListingStatesWrapper,
        LocalDB,
        RemoteDB,
        SnackbarTone,
        SyncButton,
        SyncPage,
        ViewDecksHelper,
        ViewDecksLocalController,
        showCreateDeckLocalSheet,
        showSnackbar,
        useFilteredSearchBarController,
        useSyncController,
        AuthService,
        AppBar,
        Scaffold;
import 'package:flutter/material.dart'
    show
        BuildContext,
        Widget,
        Icon,
        Text,
        SizedBox,
        StatelessWidget,
        VoidCallback,
        WidgetsBinding,
        Icons,
        CrossAxisAlignment,
        Column,
        ElevatedButton,
        LayoutBuilder;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ViewDecksLocalPage extends HookWidget {
  const ViewDecksLocalPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ViewDecksLocalController>();
    final reviewController = context.watch<ChangeTrackerController>();
    final importController = useMemoized(() => ImportExportController());
    final syncController = useSyncController<Deck>(
      localDb: LocalDB.deck,
      remoteDb: RemoteDB.deck,
      userId: () => LocalDB.profile.getOrCreate().id,
      localWhere: (deck) => deck.userId == LocalDB.profile.getOrCreate().id,
      beforeSync: () async {
        final profile = LocalDB.profile.getOrCreate();
        await LocalDB.deck.adoptLegacyOwnerId(
          legacyUserId: profile.userId,
          currentProfileId: profile.id,
        );
      },
      onSynced: controller.load,
    );

    useEffect(() {
      controller.loadOnNextFrame();
      return null;
    }, const []);

    useEffect(() => importController.dispose, [importController]);
    useListenable(importController);

    useEffect(() {
      final err = syncController.syncError;
      if (err == null) return null;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        showSnackbar(
          context,
          message: 'Sync failed: $err',
          leading: const Icon(Icons.sync_problem_outlined),
          duration: const Duration(seconds: 3),
          tone: SnackbarTone.error,
        );
        syncController.clearSyncError();
      });
      return null;
    }, [syncController.syncError]);

    useEffect(() {
      final changePlan = syncController.changePlan;
      if (changePlan == null) return null;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        showSnackbar(context, message: 'Everything is up to date!');
        syncController.clearChangePreview();
      });

      return null;
    }, [syncController.changePlan]);

    final searchController =
        useFilteredSearchBarController<Deck, DeckSearchFilter>(
          filterCodec: ViewDecksLocalController.deckSearchFilterCodec,
          searchResults: ViewDecksLocalController.deckSearchResults,
          items: controller.decks,
        );

    final visibleDecks = searchController.results;
    final hasSearchQuery = searchController.text.trim().isNotEmpty;
    final syncPlan = ViewDecksHelper.currentSyncPlan(reviewController.entries);

    Future<void> importDecksFromFile() async {
      final result = await importController.importDecksFromFile();
      if (result.status == ImportFileStatus.canceled) return;
      if (!context.mounted) return;

      if (result.didImport) controller.load();

      showSnackbar(
        context,
        message: ViewDecksHelper.importMessage(result),
        leading: Icon(
          ViewDecksHelper.isImportFailure(result)
              ? Icons.error_outline
              : Icons.file_download_done_outlined,
        ),
        tone: ViewDecksHelper.isImportFailure(result)
            ? SnackbarTone.error
            : SnackbarTone.success,
      );
    }

    // If there's an active sync plan, show SyncPage regardless of which
    // tab the user navigated to and back from — the plan survives in
    // ChangeTrackerController which lives above the ShellRoute.
    if (AuthService.isAuthenticatedRemote && syncPlan != null) {
      return SyncPage(
        entry: syncPlan,
        onViewChanges: () {
          context.push('/change-review/${syncPlan.id}');
        },
        onApply: () {
          syncController.clearSyncing();
          context.read<ChangeTrackerController>().apply(syncPlan.id);
        },
        onDiscard: () {
          syncController.dismissSyncReview(
            context.read<ChangeTrackerController>(),
            syncPlan.id,
          );
        },
      );
    }

    final searchBar = FilteredSearchBar<Deck, DeckSearchFilter>(
      controller: searchController,
      filterCodec: ViewDecksLocalController.deckSearchFilterCodec,
      searchResults: ViewDecksLocalController.deckSearchResults,
      items: controller.decks,
      placeholder: 'Search decks',
      onResultSelected: (deck) => controller.goToDeck(context, deck),
      onSubmitted: (_) => controller.submitSearch(context, visibleDecks),
    );

    return Scaffold(
      appBar: AppBar(
        title: 'My Decks',
        actions: [
          SyncButton(
            isSyncing: syncController.isSyncing,
            isAuthenticated: AuthService.isAuthenticatedRemote,
            onSync: () => syncController.sync(reviewController),
          ),
          Button.icon(
            icon: Icons.file_open_outlined,
            onPressed: importController.isLoading ? null : importDecksFromFile,
          ),
          Button.icon(
            icon: Icons.layers_rounded,
            onPressed: () => context.push('/view-cards'),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          searchBar,
          const SizedBox(height: 24),
          _DeckListBody(
            error: controller.error,
            isLoading: controller.isLoading,
            onRetry: controller.load,
            onPressed: controller.goToDeck,
            decks: visibleDecks,
            hasSearchQuery: hasSearchQuery,
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
    required this.onPressed,
    required this.hasSearchQuery,
  });

  final bool isLoading;
  final Exception? error;
  final List<Deck> decks;
  final VoidCallback onRetry;
  final Function(BuildContext context, Deck deck) onPressed;
  final bool hasSearchQuery;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 16.0;
        final availableWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : 616.0;
        final tileWidth = ((availableWidth - spacing) / 2)
            .clamp(0.0, availableWidth)
            .toDouble();

        return ListingStatesWrapper<Deck>.wrap(
          isLoading: isLoading,
          exception: error,
          items: decks,
          onRetry: onRetry,
          skeletonTile: DeckTile(deck: null, width: tileWidth),
          emptyState: hasSearchQuery
              ? const EmptyState(
                  icon: Icons.search_off,
                  title: 'No decks found',
                  message: 'Try another search or remove filters',
                )
              : EmptyState(
                  icon: Icons.layers,
                  title: 'No decks yet',
                  message: 'Create your first deck to get started',
                  action: ElevatedButton(
                    child: Text('Create Deck'),
                    onPressed: () => showCreateDeckLocalSheet(context),
                  ),
                ),
          spacing: spacing,
          runSpacing: spacing,
          leadingItem: CreateDeckTile(
            width: tileWidth,
            onPressed: () => showCreateDeckLocalSheet(context),
          ),
          itemBuilder: (_, _, deck) {
            return DeckTile(
              deck: deck,
              width: tileWidth,
              state: DeckTileState.defaultView,
              onPressed: () {
                onPressed(context, deck);
              },
            );
          },
        );
      },
    );
  }
}
