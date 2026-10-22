import 'package:boo_mondai/lib.barrel.dart'
    show
        StatusLayoutState,
        DeckListingTile,
        DeckWithListingContent,
        AppTokens,
        ListingStatesWrapper,
        Deck,
        DeckListing,
        ContentType,
        Content,
        Profile,
        DeckListingTileController;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class DeckListingListView extends StatelessWidget {
  const DeckListingListView({
    super.key,
    required this.isLoading,
    required this.error,
    required this.entries,
    required this.onRetry,
    required this.onPressed,
    required this.hasSearchQuery,
  });

  final bool isLoading;
  final Exception? error;
  final List<DeckWithListingContent> entries;
  final VoidCallback onRetry;
  final Function(BuildContext context, DeckWithListingContent entry) onPressed;
  final bool hasSearchQuery;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return ListingStatesWrapper<DeckWithListingContent>.list(
      isLoading: isLoading,
      exception: error,
      items: entries,
      reverse: true,
      useParentScroll: true,
      onRetry: onRetry,
      skeletonTile: DeckListingTile(
        controller: DeckListingTileController(
          deck: Deck(
            id: '',
            updatedAt: DateTime.now(),
            createdAt: DateTime.now(),
            profileId: 'loading',
            title: 'Loading listing',
            shortDescription: 'Loading listing description',
            isPublished: true,
          ),
          listing: DeckListing(deckId: '', contentId: ''),
          content: Content(
            id: '',
            profileId: '',
            type: ContentType.deck,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          sourceProfile: Profile(
            displayName: '',
            id: '',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            userId: '',
            username: '',
          ),
          profile: Profile(
            displayName: '',
            id: '',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            userId: '',
            username: '',
          ),
        ),
      ),
      emptyState: hasSearchQuery
          ? const StatusLayoutState(
              icon: Icons.search_off,
              title: 'No listings found',
              message: 'Try another search or remove filters',
              disableScaffoldScrollingWhenShown: true,
            )
          : const StatusLayoutState(
              icon: Icons.public,
              title: 'No listings yet',
              message: 'Create a deck listing to manage it here',
              disableScaffoldScrollingWhenShown: true,
            ),
      separatorHeight: tokens.spaceLayoutGapMd,
      itemBuilder: (context, _, entry) {
        return DeckListingTile(
          controller: DeckListingTileController(
            deck: entry.deck,
            listing: entry.deckListing,
            content: entry.deckListingContent,
            profile: entry.profile,
            sourceProfile: entry.sourceProfile ?? entry.profile,
          ),
          onPressed: () {
            onPressed(context, entry);
          },
        );
      },
    );
  }
}
