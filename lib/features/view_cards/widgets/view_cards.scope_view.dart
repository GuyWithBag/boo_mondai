import 'package:boo_mondai/lib.barrel.dart'
    show
        StatusLayoutState,
        CardTemplate,
        ViewCardsController,
        ViewCardsSearchScope,
        CardTemplateSearchFilter,
        SearchState,
        ViewCardsLayoutMode,
        StudyCard,
        StudyCardSearchFilter,
        FlashcardTemplate,
        ViewCardsTile,
        ViewCardsByPairTile,
        ViewCardsListLayout,
        ViewCardsStudyCardEntry,
        GridTileMaxWidthConstraints,
        buildPairedStudyCardEntries;
import 'package:flutter/material.dart';

class ViewCardsTemplateScopeView extends StatelessWidget {
  const ViewCardsTemplateScopeView({
    required this.controller,
    required this.searchState,
    required this.layoutMode,
    required this.hasSearchQuery,
    super.key,
  });

  final ViewCardsController controller;
  final SearchState<
    ViewCardsSearchScope,
    CardTemplate,
    CardTemplateSearchFilter
  >
  searchState;
  final ViewCardsLayoutMode layoutMode;
  final bool hasSearchQuery;

  @override
  Widget build(BuildContext context) {
    Widget buildTemplatePreview(
      BuildContext context,
      int index,
      CardTemplate template,
    ) {
      if (layoutMode == ViewCardsLayoutMode.paired &&
          template is FlashcardTemplate) {
        return ViewCardsByPairTile.template(template: template);
      }

      return GridTileMaxWidthConstraints(
        builder: (width) => ViewCardsTile.template(
          template: template,
          width: width,
          editable: true,
        ),
      );
    }

    return ViewCardsListLayout<CardTemplate>(
      isLoading: controller.isLoading,
      exception: controller.error,
      entries: searchState.controller.results,
      emptyState: _templateEmptyState,
      onRetry: controller.load,
      layoutMode: layoutMode,
      entryBuilder: buildTemplatePreview,
    );
  }

  StatusLayoutState get _templateEmptyState => hasSearchQuery
      ? const StatusLayoutState(
          icon: Icons.search_off,
          title: 'No templates found',
          message: 'Try a different query or remove filters.',
        )
      : const StatusLayoutState(
          icon: Icons.view_carousel_outlined,
          title: 'No templates yet',
          message: 'Add card templates to your decks to browse them.',
        );
}

class ViewCardsStudyCardScopeView extends StatelessWidget {
  const ViewCardsStudyCardScopeView({
    required this.controller,
    required this.searchState,
    required this.layoutMode,
    required this.hasSearchQuery,
    super.key,
  });

  final ViewCardsController controller;
  final SearchState<ViewCardsSearchScope, StudyCard, StudyCardSearchFilter>
  searchState;
  final ViewCardsLayoutMode layoutMode;
  final bool hasSearchQuery;

  @override
  Widget build(BuildContext context) {
    if (layoutMode == ViewCardsLayoutMode.compact) {
      return ViewCardsListLayout<StudyCard>(
        isLoading: controller.isLoading,
        exception: controller.error,
        entries: searchState.controller.results,
        emptyState: _studyCardEmptyState,
        onRetry: controller.load,
        layoutMode: layoutMode,
        entryBuilder: (context, index, card) {
          return GridTileMaxWidthConstraints(
            builder: (width) => ViewCardsTile.studyCard(
              studyCard: card,
              width: width,
              editable: true,
            ),
          );
        },
      );
    }

    final entries = buildPairedStudyCardEntries(searchState.controller.results);

    Widget buildStudyCardEntryPreview(
      BuildContext context,
      int index,
      ViewCardsStudyCardEntry entry,
    ) {
      final card = entry.card;
      if (card != null) {
        return GridTileMaxWidthConstraints(
          builder: (width) => ViewCardsTile.studyCard(
            studyCard: card,
            width: width,
            editable: true,
          ),
        );
      }

      return ViewCardsByPairTile.studyCards(
        frontCard: entry.frontCard!,
        backCard: entry.backCard!,
      );
    }

    return ViewCardsListLayout<ViewCardsStudyCardEntry>(
      isLoading: controller.isLoading,
      exception: controller.error,
      entries: entries,
      emptyState: _studyCardEmptyState,
      onRetry: controller.load,
      layoutMode: layoutMode,
      entryBuilder: buildStudyCardEntryPreview,
    );
  }

  StatusLayoutState get _studyCardEmptyState => hasSearchQuery
      ? const StatusLayoutState(
          icon: Icons.search_off,
          title: 'No cards found',
          message: 'Try a different query or remove filters.',
        )
      : const StatusLayoutState(
          icon: Icons.view_carousel_outlined,
          title: 'No cards yet',
          message: 'Add templates to your decks to generate study cards.',
        );
}
