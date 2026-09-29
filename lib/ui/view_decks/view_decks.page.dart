// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/my_decks_page.dart
// PURPOSE: Lists user's decks with search, swipe-to-delete, and FAB to create new
// PROVIDERS: ViewDecksLocalController
// HOOKS: useEffect, useScrollController, useTextEditingController
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:io' show Directory, FileSystemEntity, Link;

import 'package:boo_mondai/features/features.barrel.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        AppBar,
        AppTokens,
        AuthService,
        Button,
        ChangeTrackerController,
        ChangeTrackerRouteArgs,
        ChangeTrackerService,
        ChangeTrackerStatus,
        Deck,
        DeckWithListingContent,
        FilteredSearchBar,
        FilteredSearchBarController,
        ProgressBar,
        Scaffold,
        SegmentOption,
        SegmentedControl,
        SelectionController,
        SettingPath,
        SettingsStore,
        SnackbarHandle,
        SnackbarColor,
        SnackbarVariant,
        SyncController,
        SyncButton,
        SyncPage,
        ViewDecksLocalController,
        showViewImportModal,
        showFeatureDisabledModal,
        showSnackbar,
        showModal;
import 'package:boo_mondai/ui/ui.barrel.dart';
import 'package:flutter/material.dart' hide AppBar, Scaffold;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:signals_hooks/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class ViewDecksLocalPage extends SignalHookWidget {
  const ViewDecksLocalPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final controller = context.read<ViewDecksLocalController>();
    final settingsStore = SettingsStore.instance;
    final areOnlineFeaturesDisabled = settingsStore.get<bool>(
      SettingPath.disableOnlineFeatures,
    );
    final changeTrackerPageArgs = useMemoized(
      () => signal(const ChangeTrackerRouteArgs.missing(entryId: '')),
    );
    final changeTrackerController = useMemoized(
      () => ChangeTrackerController(
        service: ChangeTrackerService(
          inboundLabel: 'pull',
          outboundLabel: 'push',
        ),
        pageArgs: changeTrackerPageArgs,
      ),
      [changeTrackerPageArgs],
    );
    final syncController = context.read<SyncController>();
    useEffect(() {
      syncController.bindChangeTracker(changeTrackerController);
      return () {
        changeTrackerController.dispose();
        changeTrackerPageArgs.dispose();
      };
    }, [syncController, changeTrackerController]);
    final syncError = syncController.error.value;
    final currentSyncEntry = syncController.currentEntry.value;
    final isSyncing = syncController.isSyncing.value;
    final isAlreadyUpToDate = syncController.isAlreadyUpToDate.value;
    final shouldShowSyncPage = syncController.shouldShowSyncPage.value;
    final selectionController = useMemoized(
      () => SelectionController<String>(
        multiple: true,
        isEnabled: false,
        emptySelectionAllowed: true,
      ),
    );
    final syncSnackbarHandle = useRef<SnackbarHandle?>(null);
    final syncProgress = useRef(ValueNotifier(0.0));

    useEffect(() {
      controller.loadOnNextFrame();
      return null;
    }, const []);

    useEffect(() {
      if (syncError == null) return null;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        syncSnackbarHandle.value?.dismiss();
        syncSnackbarHandle.value = null;
        showSnackbar(
          context,
          message: 'Sync failed: ${syncError.toString()}',
          leading: const Icon(Icons.sync_problem_outlined),
          duration: const Duration(seconds: 3),
          color: SnackbarColor.error,
        );
        syncController.clearError();
      });
      return null;
    }, [syncError]);

    useEffect(() {
      return () {
        syncSnackbarHandle.value?.dismiss();
        syncProgress.value.dispose();
      };
    }, const []);

    useEffect(
      () {
        if (currentSyncEntry == null) return null;
        final progress = currentSyncEntry.progress ?? 0;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted) return;
          syncProgress.value.value = progress.clamp(0.0, 1.0);

          switch (currentSyncEntry.status) {
            case ChangeTrackerStatus.fetching:
              syncSnackbarHandle.value ??= showSnackbar(
                context,
                message: 'Checking if needs sync...',
                leading: const Icon(Icons.sync_rounded),
                child: ValueListenableBuilder<double>(
                  valueListenable: syncProgress.value,
                  builder: (context, progress, _) {
                    return ProgressBar(value: progress);
                  },
                ),
                duration: null,
                color: SnackbarColor.muted,
                variant: SnackbarVariant.dashed,
              );
            case ChangeTrackerStatus.applying:
              syncSnackbarHandle.value ??= showSnackbar(
                context,
                message: 'Syncing decks...',
                leading: const Icon(Icons.sync_rounded),
                child: ValueListenableBuilder<double>(
                  valueListenable: syncProgress.value,
                  builder: (context, progress, _) {
                    return ProgressBar(value: progress);
                  },
                ),
                duration: null,
                color: SnackbarColor.muted,
                variant: SnackbarVariant.dashed,
              );
            case ChangeTrackerStatus.alreadyUpToDate:
              syncSnackbarHandle.value?.dismiss();
              syncSnackbarHandle.value = null;
              showSnackbar(
                context,
                message: 'Everything is already up to date!',
              );
              syncController.clearAlreadyUpToDate();
            case ChangeTrackerStatus.completed:
              syncSnackbarHandle.value?.dismiss();
              syncSnackbarHandle.value = null;
              showSnackbar(
                context,
                message: 'Deck sync complete!',
                leading: const Icon(Icons.cloud_done_outlined),
                color: SnackbarColor.success,
              );
              syncController.dismissCurrentEntry();
            case ChangeTrackerStatus.reviewing:
              syncSnackbarHandle.value?.dismiss();
              syncSnackbarHandle.value = null;
              showSnackbar(
                context,
                message: 'There are changes that need to be reviewed!',
              );
            case _:
              break;
          }
        });

        return null;
      },
      [
        currentSyncEntry?.id,
        currentSyncEntry?.status,
        ((currentSyncEntry?.progress ?? 0) * 100).round(),
      ],
    );

    Future<void> deleteSelectedDecks(
      SelectionController<String> selection,
    ) async {
      final selectedDeckIds = selection.selectedValues;
      if (selectedDeckIds.isEmpty) return;

      final selectedDecks = controller.decks.value
          .where((deck) => selectedDeckIds.contains(deck.id))
          .toList(growable: false);

      await controller.deleteDecks(selectedDecks);
      selection.clear();
      selection.isEnabled.value = false;
    }

    Future<void> showSandboxFiles() async {
      final sandboxDirectory =
          await FileSystemHandler.getAbsolutePathOfRelativePath(null);
      final output = await _buildDirectoryTree(Directory(sandboxDirectory));

      debugPrint(output, wrapWidth: 1024);

      if (!context.mounted) return;
      await showModal<void>(
        context: context,
        leading: const Icon(Icons.folder_outlined),
        title: 'Sandbox files',
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.6,
          ),
          child: SingleChildScrollView(child: SelectableText(output)),
        ),
        showCancelButton: true,
      );
    }

    Future<void> showImportDeckModal() async {
      await showViewImportModal(context);
    }

    // If there's an active sync plan, show SyncPage while this page-owned
    // tracker service has reviewable sync work.
    if (!areOnlineFeaturesDisabled &&
        AuthService.isAuthenticatedRemote &&
        !isAlreadyUpToDate &&
        shouldShowSyncPage) {
      return SyncPage(syncController: syncController);
    }

    final deckSearchController = useMemoized(
      () => FilteredSearchBarController<Deck>(
        tokenShapes: ViewDecksSearch.tokenShapes,
        searchTextLabel: ViewDecksSearch.deckSearchTextLabel,
        itemFilter: ViewDecksSearch.deckItemFilter,
        sorter: ViewDecksSearch.deckSorter,
        items: controller.decks.value,
      ),
      const [],
    );
    final listingSearchController = useMemoized(
      () => FilteredSearchBarController<DeckWithListingContent>(
        tokenShapes: ViewDecksSearch.tokenShapes,
        searchTextLabel: ViewDecksSearch.listingSearchTextLabel,
        itemFilter: ViewDecksSearch.listingItemFilter,
        sorter: ViewDecksSearch.listingSorter,
        items: controller.listingEntries.value,
      ),
      const [],
    );

    useEffect(() {
      deckSearchController.setItems(controller.decks.value);
      return null;
    }, [controller.decks.value, deckSearchController]);

    useEffect(() {
      listingSearchController.setItems(controller.listingEntries.value);
      return null;
    }, [controller.listingEntries.value, listingSearchController]);

    useEffect(() {
      return () {
        deckSearchController.dispose();
        listingSearchController.dispose();
      };
    }, [deckSearchController, listingSearchController]);

    final visibleDecks = deckSearchController.results.value;
    final visibleListingEntries = listingSearchController.results.value;
    final isDeckScope =
        areOnlineFeaturesDisabled || controller.isDeckScope.value;
    final hasSearchQuery = isDeckScope
        ? deckSearchController.hasText.value
        : listingSearchController.hasText.value;

    void showOnlineFeatureDisabled() {
      showFeatureDisabledModal(context);
    }

    final searchBar = isDeckScope
        ? FilteredSearchBar<Deck>(
            controller: deckSearchController,
            placeholder: 'Search decks',
            resultLabelBuilder: (deck) => deck.title,
            onResultSelected: (deck) => controller.goToDeck(context, deck),
            onSubmitted: (_) {
              if (visibleDecks.length == 1) {
                controller.goToDeck(context, visibleDecks.single);
              }
            },
          )
        : FilteredSearchBar<DeckWithListingContent>(
            controller: listingSearchController,
            placeholder: 'Search listings',
            resultLabelBuilder: (entry) => entry.deck.title,
            onResultSelected: (entry) => controller.goToListing(context, entry),
            onSubmitted: (_) {
              if (visibleListingEntries.length == 1) {
                controller.goToListing(context, visibleListingEntries.single);
              }
            },
          );

    return Scaffold(
      scrollStartAtTheBottom: true,
      appBar: AppBar<String>(
        title: 'My Decks',
        selectedActions: [
          Button.icon(tokens: tokens, icon: Icons.import_export),
        ],
        actions: [
          Button.icon(
            tokens: tokens,
            icon: Icons.folder_outlined,
            onPressed: showSandboxFiles,
          ),
          Button.icon(
            tokens: tokens,
            icon: Icons.file_open_outlined,
            onPressed: showImportDeckModal,
          ),
          Button.icon(
            tokens: tokens,
            icon: Icons.layers_rounded,
            onPressed: () => context.push('/view-cards'),
          ),
          SyncButton(
            isSyncing: isSyncing,
            isAuthenticated: AuthService.isAuthenticatedRemote,
            isDisabled: areOnlineFeaturesDisabled,
            onFeatureDisabledPressed: showOnlineFeatureDisabled,
            onSync: () => syncController.sync(changeTrackerController),
          ),
        ],
        header: searchBar,
        preferredBottomHeight: 70,
        onSelectedDelete: deleteSelectedDecks,
        selectionController: selectionController,
        bottom: Padding(
          padding: EdgeInsets.only(
            left: tokens.spaceScaffoldPadding,
            right: tokens.spaceScaffoldPadding,
            top: tokens.spaceLayoutGapSm,
          ),
          child: SegmentedControl<ViewDecksSearchScope>(
            value: areOnlineFeaturesDisabled
                ? ViewDecksSearchScope.decks
                : controller.activeScope.value,
            onChanged: (value) {
              if (value == ViewDecksSearchScope.listings &&
                  areOnlineFeaturesDisabled) {
                showOnlineFeatureDisabled();
                return;
              }
              controller.setActiveScope(value);
            },
            isOptionEnabled: (value) =>
                value != ViewDecksSearchScope.listings ||
                !areOnlineFeaturesDisabled,
            onDisabledOptionPressed: (_) => showOnlineFeatureDisabled(),
            options: [
              for (final option in controller.scopeOptions.value)
                SegmentOption(value: option.value, label: option.label),
            ],
          ),
        ),
      ),
      body: isDeckScope
          ? DeckListView(
              error: controller.error.value,
              isLoading: controller.isLoading.value,
              onRetry: controller.load,
              onPressed: controller.goToDeck,
              onCreate: () => controller.createDeck(context),
              decks: visibleDecks,
              hasSearchQuery: hasSearchQuery,
              selectionController: selectionController,
            )
          : DeckListingListView(
              error: controller.error.value,
              isLoading: controller.isLoading.value,
              onRetry: controller.load,
              onPressed: controller.goToListing,
              entries: visibleListingEntries,
              hasSearchQuery: hasSearchQuery,
            ),
    );
  }
}

Future<String> _buildDirectoryTree(Directory root) async {
  final lines = <String>[root.path];

  if (!await root.exists()) {
    lines.add('└── Directory does not exist.');
    return lines.join('\n');
  }

  await _appendDirectoryChildren(lines: lines, directory: root, indent: '');
  return lines.join('\n');
}

Future<void> _appendDirectoryChildren({
  required List<String> lines,
  required Directory directory,
  required String indent,
}) async {
  final children = await directory.list(followLinks: false).toList();

  children.sort((a, b) {
    final aIsDirectory = a is Directory;
    final bIsDirectory = b is Directory;
    if (aIsDirectory != bIsDirectory) return aIsDirectory ? -1 : 1;
    return _entityName(a).compareTo(_entityName(b));
  });

  if (children.isEmpty) {
    lines.add('$indent└── <empty>');
    return;
  }

  for (var index = 0; index < children.length; index++) {
    final child = children[index];
    final isLast = index == children.length - 1;
    final connector = isLast ? '└──' : '├──';
    final childIndent = isLast ? '    ' : '│   ';
    final name = _entityName(child);

    lines.add('$indent$connector $name');

    if (child is Directory) {
      await _appendDirectoryChildren(
        lines: lines,
        directory: child,
        indent: '$indent$childIndent',
      );
    } else if (child is Link) {
      final target = await child.target();
      lines.add('$indent$childIndent└── -> $target');
    }
  }
}

String _entityName(FileSystemEntity entity) {
  final segments = entity.uri.pathSegments
      .where((segment) => segment.isNotEmpty)
      .toList(growable: false);
  if (segments.isEmpty) return entity.path;
  return segments.last;
}
