// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/my_decks_page.dart
// PURPOSE: Lists user's decks with search, swipe-to-delete, and FAB to create new
// PROVIDERS: ViewDecksLocalController
// HOOKS: useEffect, useScrollController, useTextEditingController
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        AppBar,
        AppTokens,
        AuthService,
        Button,
        ChangeTrackerStatus,
        CreateDeckTile,
        Deck,
        DeckListingTile,
        DeckSearchFilter,
        DeckTile,
        DeckTileState,
        FilteredSearchBar,
        ImportExportController,
        ImportFileStatus,
        InteractionHandler,
        ListingStatesWrapper,
        LocalDB,
        RemoteDB,
        Scaffold,
        SegmentOption,
        SegmentedControl,
        SelectionController,
        SnackbarTone,
        StatusLayoutState,
        SyncButton,
        SyncPage,
        ViewDecksHelper,
        ViewDecksLocalController,
        ViewDecksSearchScope,
        showSnackbar,
        useChangeTrackerController,
        useSyncController,
        useSelectionController;
import 'package:flutter/material.dart' hide AppBar, Scaffold;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:theme_variants/theme_variants.dart';

class ViewDecksLocalPage extends HookWidget {
  const ViewDecksLocalPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final controller = context.watch<ViewDecksLocalController>();
    final changeTrackerController = useChangeTrackerController();
    final selectionController = useSelectionController<String>(
      multiple: true,
      isEnabled: false,
      emptySelectionAllowed: true,
    );
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
      final syncEntry = syncController.currentEntry;
      if (syncEntry == null) return null;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        switch (syncEntry.status) {
          case ChangeTrackerStatus.alreadyUpToDate:
            showSnackbar(context, message: 'Everything is already up to date!');
            syncController.clearAlreadyUpToDate();
          case ChangeTrackerStatus.reviewing:
            showSnackbar(
              context,
              message: 'There are changes that need to be reviewed!',
            );
          case _:
            break;
        }
      });

      return null;
    }, [syncController.currentEntry?.id, syncController.currentEntry?.status]);

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

    // If there's an active sync plan, show SyncPage while this page-owned
    // tracker service has reviewable sync work.
    if (AuthService.isAuthenticatedRemote &&
        !syncController.isAlreadyUpToDate &&
        syncController.shouldShowSyncPage) {
      return SyncPage<Deck>(syncController: syncController);
    }

    final searchState = controller.activeSearchState;
    final searchBar = FilteredSearchBar<Deck, DeckSearchFilter>(
      controller: searchState.controller,
      filterCodec: searchState.scope.filterCodec,
      searchResults: searchState.scope.searchResults,
      items: controller.isDeckScope
          ? controller.decks
          : controller.listingDecks,
      placeholder: 'Search decks',
      resultLabelBuilder: (deck) => deck.title,
      onResultSelected: (deck) {
        if (controller.isDeckScope) {
          controller.goToDeck(context, deck);
        } else {
          controller.goToListing(context, deck);
        }
      },
      onSubmitted: (_) => controller.submitSearch(context, searchState.results),
    );

    return Scaffold(
      scrollStartAtTheBottom: true,
      appBar: AppBar(
        title: 'My Decks',
        selectedActions: [
          Button.icon(tokens: tokens, icon: Icons.import_export),
        ],
        actions: [
          Button.icon(
            tokens: tokens,
            icon: Icons.file_open_outlined,
            onPressed: importController.isLoading ? null : importDecksFromFile,
          ),
          Button.icon(
            tokens: tokens,
            icon: Icons.layers_rounded,
            onPressed: () => context.push('/view-cards'),
          ),
          SyncButton(
            isSyncing: syncController.isSyncing,
            isAuthenticated: AuthService.isAuthenticatedRemote,
            onSync: () => syncController.sync(changeTrackerController),
          ),
        ],
        header: searchBar,
        preferredBottomHeight: 70,
        selectionController: selectionController,
        bottom: Padding(
          padding: EdgeInsets.only(
            left: tokens.spaceScaffoldPadding,
            right: tokens.spaceScaffoldPadding,
            top: tokens.spaceLayoutGapSm,
          ),
          child: SegmentedControl<ViewDecksSearchScope>(
            value: controller.activeScope,
            onChanged: controller.setActiveScope,
            options: [
              for (final option in controller.scopeOptions)
                SegmentOption(value: option.value, label: option.label),
            ],
          ),
        ),
      ),
      body: controller.isDeckScope
          ? _DeckListView(
              error: controller.error,
              isLoading: controller.isLoading,
              onRetry: controller.load,
              onPressed: controller.goToDeck,
              onCreate: () => controller.createDeck(context),
              decks: controller.visibleDecks,
              hasSearchQuery: controller.hasSearchQuery,
              selectionController: selectionController,
            )
          : _DeckListingListView(
              error: controller.error,
              isLoading: controller.isLoading,
              onRetry: controller.load,
              onPressed: controller.goToListing,
              decks: controller.visibleListingDecks,
              hasSearchQuery: controller.hasSearchQuery,
            ),
    );
  }
}

class _DeckListView extends StatelessWidget {
  const _DeckListView({
    required this.isLoading,
    required this.error,
    required this.decks,
    required this.onRetry,
    required this.onPressed,
    required this.onCreate,
    required this.hasSearchQuery,
    required this.selectionController,
  });

  final bool isLoading;
  final Exception? error;
  final List<Deck> decks;
  final VoidCallback onRetry;
  final Function(BuildContext context, Deck deck) onPressed;
  final VoidCallback onCreate;
  final bool hasSearchQuery;
  final SelectionController<String> selectionController;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    const spacing = 16.0;

    return ListingStatesWrapper<Deck>.grid(
      isLoading: isLoading,
      exception: error,
      items: decks,
      reverse: true,
      useParentScroll: true,
      textDirection: TextDirection.rtl,
      onRetry: onRetry,
      skeletonTile: _GridTileMaxWidthConstraints(
        builder: (width) => DeckTile(deck: null, width: width, hasTags: true),
      ),
      emptyState: hasSearchQuery
          ? const StatusLayoutState(
              icon: Icons.search_off,
              title: 'No decks found',
              message: 'Try another search or remove filters',
            )
          : StatusLayoutState(
              icon: Icons.layers,
              title: 'No decks yet',
              message: 'Create your first deck to get started',
              actions: [
                ElevatedButton(onPressed: onCreate, child: Text('Create Deck')),
              ],
            ),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: tokens.studyCardWidth,
        mainAxisSpacing: spacing,
        crossAxisSpacing: spacing,
        childAspectRatio: tokens.studyCardAspectRatio,
      ),
      leadingItem: _GridTileMaxWidthConstraints(
        builder: (width) => CreateDeckTile(width: width, onPressed: onCreate),
      ),
      itemBuilder: (_, _, deck) {
        return _GridTileMaxWidthConstraints(
          builder: (width) => InteractionHandler(
            onPressed: () {
              onPressed(context, deck);
            },
            selectionController: selectionController,
            selectionValue: deck.id,
            child: DeckTile(
              deck: deck,
              width: width,
              hasTags: true,
              state: DeckTileState.defaultView,
              isSelected: selectionController.isSelected(deck.id),
            ),
          ),
        );
      },
    );
  }
}

class _DeckListingListView extends StatelessWidget {
  const _DeckListingListView({
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
    final tokens = context.themeTokens<AppTokens>();

    return ListingStatesWrapper<Deck>.list(
      isLoading: isLoading,
      exception: error,
      items: decks,
      reverse: true,
      useParentScroll: true,
      onRetry: onRetry,
      skeletonTile: DeckListingTile(
        deck: Deck.createNow(
          userId: 'loading',
          title: 'Loading listing',
          shortDescription: 'Loading listing description',
          isPublished: true,
        ),
      ),
      emptyState: hasSearchQuery
          ? const StatusLayoutState(
              icon: Icons.search_off,
              title: 'No listings found',
              message: 'Try another search or remove filters',
            )
          : const StatusLayoutState(
              icon: Icons.public,
              title: 'No listings yet',
              message: 'Create a deck listing to manage it here',
            ),
      separatorHeight: tokens.spaceLayoutGapMd,
      itemBuilder: (context, _, deck) {
        return DeckListingTile(
          deck: deck,
          onPressed: () {
            onPressed(context, deck);
          },
        );
      },
    );
  }
}

class _GridTileMaxWidthConstraints extends StatelessWidget {
  const _GridTileMaxWidthConstraints({required this.builder});

  final Widget Function(double width) builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => builder(constraints.maxWidth),
    );
  }
}
