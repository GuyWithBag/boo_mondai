// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/my_decks_page.dart
// PURPOSE: Lists user's decks with search, swipe-to-delete, and FAB to create new
// PROVIDERS: ViewDecksLocalController
// HOOKS: useEffect, useScrollController, useTextEditingController
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:convert';

import 'package:boo_mondai/lib.barrel.dart'
    show
        Button,
        ChangeReviewController,
        ChangeReviewPlan,
        ChangeReviewStatus,
        ChangeSource,
        CreateDeckTile,
        Deck,
        DeckSearchFilter,
        DeckTile,
        DeckTileState,
        EmptyState,
        FilteredSearchBar,
        ImportExportController,
        ListingStatesWrapper,
        SnackbarTone,
        SyncButton,
        SyncPage,
        ViewDecksLocalController,
        showCreateDeckLocalSheet,
        showSnackbar,
        useFilteredSearchBarController,
        AuthService;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';

class ViewDecksLocalPage extends HookWidget {
  const ViewDecksLocalPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ViewDecksLocalController>();
    final reviewController = context.watch<ChangeReviewController>();
    final importExport = useMemoized(() => ImportExportController());

    useEffect(() {
      controller.loadOnNextFrame();
      return null;
    }, const []);

    useEffect(() {
      controller.showSyncErrorIfPresent(context);
      return null;
    }, [controller.syncError]);

    useEffect(() {
      final changePlan = controller.changePlan;
      if (changePlan == null) return null;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        showSnackbar(context: context, message: 'Everything is up to date!');
        controller.changePlan = null;
      });

      return null;
    }, [controller.changePlan]);

    useEffect(() => importExport.dispose, [importExport]);
    useListenable(importExport);

    final searchController =
        useFilteredSearchBarController<Deck, DeckSearchFilter>(
          filterCodec: ViewDecksLocalController.deckSearchFilterCodec,
          searchResults: ViewDecksLocalController.deckSearchResults,
          items: controller.decks,
        );

    final visibleDecks = searchController.results;
    final hasSearchQuery = searchController.text.trim().isNotEmpty;
    final syncPlan = _currentSyncPlan(reviewController.plans);

    Future<void> importDecksFromFile() async {
      final result = await FilePicker.pickFiles(
        dialogTitle: 'Import decks',
        type: FileType.custom,
        allowedExtensions: const ['json'],
        withData: true,
      );
      if (result == null || result.files.isEmpty) return;
      if (!context.mounted) return;

      final file = result.files.single;
      final bytes = file.bytes;
      if (bytes == null) {
        showSnackbar(
          context: context,
          message: 'Could not read the selected file.',
          leading: const Icon(Icons.error_outline),
          tone: SnackbarTone.error,
        );
        return;
      }

      final rawJson = utf8.decode(bytes);
      final decoded = jsonDecode(rawJson);
      var importedCount = 0;

      if (decoded is Map<String, dynamic>) {
        if (decoded.containsKey('decks')) {
          final imported = await importExport.importDecksJson(rawJson: rawJson);
          importedCount = imported.whereType<Deck>().length;
        } else if (decoded.containsKey('deck')) {
          final imported = await importExport.importDeckJson(rawJson: rawJson);
          importedCount = imported == null ? 0 : 1;
        } else {
          showSnackbar(
            context: context,
            message: 'Unsupported import format.',
            leading: const Icon(Icons.error_outline),
            tone: SnackbarTone.error,
          );
          return;
        }
      } else if (decoded is List) {
        final imported = await importExport.importDecksJson(rawJson: rawJson);
        importedCount = imported.whereType<Deck>().length;
      } else {
        showSnackbar(
          context: context,
          message: 'Unsupported import format.',
          leading: const Icon(Icons.error_outline),
          tone: SnackbarTone.error,
        );
        return;
      }

      if (!context.mounted) return;
      controller.load();

      if (importExport.error != null) {
        showSnackbar(
          context: context,
          message: 'Import failed: ${importExport.error}',
          leading: const Icon(Icons.error_outline),
          tone: SnackbarTone.error,
        );
        return;
      }

      showSnackbar(
        context: context,
        message: importedCount == 1
            ? 'Imported 1 deck'
            : 'Imported $importedCount decks',
        leading: const Icon(Icons.file_download_done_outlined),
      );
    }

    // If there's an active sync plan, show SyncPage regardless of which
    // tab the user navigated to and back from — the plan survives in
    // ChangeReviewController which lives above the ShellRoute.
    if (AuthService.isAuthenticatedRemote && syncPlan != null) {
      return SyncPage(
        plan: syncPlan,
        onViewChanges: () {
          context.push('/change-review/${syncPlan.id}');
        },
        onApply: () {
          controller.clearSyncing();
          context.read<ChangeReviewController>().apply(syncPlan.id);
        },
        onDiscard: () {
          controller.dismissSyncReview(
            context.read<ChangeReviewController>(),
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
        title: const Text('My Decks'),
        actions: [
          SyncButton(
            isSyncing: controller.isSyncing,
            isAuthenticated: AuthService.isAuthenticatedRemote,
            onSync: () => controller.sync(reviewController),
          ),
          Button.icon(
            icon: Icons.file_open_outlined,
            onPressed: importExport.isLoading ? null : importDecksFromFile,
          ),
          Button.icon(
            icon: Icons.layers_rounded,
            onPressed: () => context.push('/view-cards'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            searchBar,
            const SizedBox(height: 24),
            Expanded(
              child: _DeckListBody(
                error: controller.error,
                isLoading: controller.isLoading,
                onRetry: controller.load,
                onDeleteDeck: controller.deleteDeck,
                onPressed: controller.goToDeck,
                decks: visibleDecks,
                hasSearchQuery: hasSearchQuery,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

ChangeReviewPlan? _currentSyncPlan(List<ChangeReviewPlan> plans) {
  for (final plan in plans) {
    if (plan.source != ChangeSource.sync) continue;
    if (plan.status == ChangeReviewStatus.canceled ||
        plan.status == ChangeReviewStatus.failed ||
        plan.status == ChangeReviewStatus.idle) {
      continue;
    }
    return plan;
  }
  return null;
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
    required this.hasSearchQuery,
  });

  final bool isLoading;
  final Exception? error;
  final List<Deck> decks;
  final VoidCallback onRetry;
  final Function(BuildContext context, Deck deck) onPressed;
  final void Function(String id) onDeleteDeck;
  final bool hasSearchQuery;

  @override
  Widget build(BuildContext context) {
    return ListingStatesWrapper<Deck>.wrap(
      isLoading: isLoading,
      exception: error,
      items: decks,
      onRetry: onRetry,
      skeletonTile: DeckTile(deck: null),
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
      spacing: 16,
      leadingItem: CreateDeckTile(
        onPressed: () => showCreateDeckLocalSheet(context),
      ),
      itemBuilder: (_, _, deck) {
        return DeckTile(
          deck: deck,
          state: DeckTileState.defaultView,
          onPressed: () {
            onPressed(context, deck);
          },
        );
      },
    );
  }
}
