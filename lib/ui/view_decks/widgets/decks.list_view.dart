import 'package:boo_mondai/lib.barrel.dart'
    show
        Deck,
        SelectionController,
        AppTokens,
        ListingStatesWrapper,
        StatusLayoutState,
        DeckTile,
        ButtonColor,
        Button,
        CreateDeckTile,
        DeckTileState,
        InteractionHandler;
import 'package:flutter/material.dart';
import 'package:signals_hooks/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class DeckListView extends SignalHookWidget {
  const DeckListView({
    super.key,
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
              disableScaffoldScrollingWhenShown: true,
            )
          : StatusLayoutState(
              icon: Icons.layers,
              title: 'No decks yet',
              message: 'Create your first deck to get started',
              actions: [
                Button(
                  onPressed: onCreate,
                  variants: const [ButtonColor.primary],
                  child: Text('Create Deck'),
                ),
              ],
              disableScaffoldScrollingWhenShown: true,
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
