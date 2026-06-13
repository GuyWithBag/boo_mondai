// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/my_decks_page.dart
// PURPOSE: Lists user's decks with search, swipe-to-delete, and FAB to create new
// PROVIDERS: ViewDecksLocalController
// HOOKS: useEffect, useScrollController, useTextEditingController
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        AuthController,
        CreateDeckTile,
        ChangeReviewPlan,
        ChangeReviewStatus,
        ChangeReviewStore,
        ChangeSource,
        ChangeSummaryChips,
        Deck,
        DeckSearchFilter,
        DeckTile,
        DeckTileState,
        EmptyState,
        FilteredSearchBar,
        ListingStatesWrapper,
        ProgressBar,
        SyncButton,
        ViewDecksLocalController,
        showCreateDeckLocalSheet,
        useFilteredSearchBarController,
        Button,
        ButtonTone;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:theme_variants/theme_variants.dart';

class ViewDecksLocalPage extends HookWidget {
  const ViewDecksLocalPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ViewDecksLocalController>();
    final auth = context.watch<AuthController>();
    final reviewStore = ChangeReviewStore.instance;
    // final scrollController = useScrollController();

    useEffect(() {
      controller.loadOnNextFrame();
      return null;
    }, const []);

    useEffect(() {
      controller.showSyncErrorIfPresent(context);
      return null;
    }, [controller.syncError]);

    useListenable(reviewStore);

    final searchController =
        useFilteredSearchBarController<Deck, DeckSearchFilter>(
          filterCodec: ViewDecksLocalController.deckSearchFilterCodec,
          searchResults: ViewDecksLocalController.deckSearchResults,
          items: controller.decks,
        );
    final visibleDecks = searchController.results;
    final hasSearchQuery = searchController.text.trim().isNotEmpty;
    final syncPlan = _currentSyncPlan(reviewStore.plans);

    if (auth.service.isAuthenticatedRemote && syncPlan != null) {
      return _SyncReviewScaffold(
        plan: syncPlan,
        onDismiss: () {
          controller.dismissSyncReview();
          reviewStore.cancel(syncPlan.id);
          reviewStore.remove(syncPlan.id);
        },
        onViewResults: () {
          context.push('/change-review/${syncPlan.id}');
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
            isAuthenticated: auth.service.isAuthenticatedRemote,
            onSync: () => controller.sync(),
          ),
          Button.icon(
            icon: Icons.layers_rounded,
            onPressed: () => context.push('/view-cards'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(100.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              searchBar,
              const SizedBox(height: 24),
              _DeckListBody(
                error: controller.error,
                isLoading: controller.isLoading,
                onRetry: controller.load,
                onDeleteDeck: controller.deleteDeck,
                onPressed: controller.goToDeck,
                decks: visibleDecks,
                hasSearchQuery: hasSearchQuery,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SyncReviewScaffold extends StatelessWidget {
  const _SyncReviewScaffold({
    required this.plan,
    required this.onDismiss,
    required this.onViewResults,
  });

  final ChangeReviewPlan plan;
  final VoidCallback onDismiss;
  final VoidCallback onViewResults;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final progress = (plan.progress ?? 0).clamp(0.0, 1.0);
    final isComplete =
        plan.status == ChangeReviewStatus.completed ||
        plan.status == ChangeReviewStatus.results ||
        plan.status == ChangeReviewStatus.reviewing;
    final isReviewing = plan.status == ChangeReviewStatus.reviewing;

    return Scaffold(
      backgroundColor: tokens.backgroundPage,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(tokens.spacePanelPadding.r),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.sync_rounded, size: 76, color: tokens.textMuted),
                  SizedBox(height: tokens.spacePanelGapMd.h),
                  Text(
                    isComplete ? 'Sync Complete!' : 'Syncing',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: tokens.textPrimary,
                      fontFamily: tokens.fontFamily,
                      fontSize: tokens.textSizeHeader.sp,
                      fontWeight: tokens.fontWeightTextStrong,
                    ),
                  ),
                  SizedBox(height: tokens.spacePanelGapSm.h),
                  Text(
                    isComplete
                        ? isReviewing
                              ? 'Review changes before applying.'
                              : 'Review the results or return to your decks.'
                        : '${(progress * 100).round()}%',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: tokens.textSecondary,
                      fontFamily: tokens.fontFamily,
                      fontSize: tokens.textSizeLabelLarge.sp,
                      fontWeight: tokens.fontWeightTextStrong,
                    ),
                  ),
                  if (!isComplete) ...[
                    SizedBox(height: tokens.spacePanelGapMd.h),
                    ProgressBar(value: progress),
                  ] else ...[
                    SizedBox(height: tokens.spacePanelGapMd.h),
                    ChangeSummaryChips(plan: plan),
                  ],
                  SizedBox(height: tokens.spacePanelGapLg.h),
                  if (isComplete) ...[
                    Row(
                      children: [
                        Expanded(
                          child: Button(
                            tone: ButtonTone.filled,
                            onPressed: onViewResults,
                            child: const Text('VIEW RESULTS'),
                          ),
                        ),
                        SizedBox(width: tokens.spacePanelGapSm.w),
                        Expanded(
                          child: Button(
                            onPressed: onDismiss,
                            child: const Text('CANCEL'),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    SizedBox(
                      width: double.infinity,
                      child: Button(
                        onPressed: onDismiss,
                        child: const Text('CANCEL'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
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
      spacing: 100,
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
