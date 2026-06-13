import 'package:boo_mondai/lib.barrel.dart'
    show
        AppSpacing,
        EmptyState,
        ListingStatesWrapper,
        CardTemplate,
        ViewCardsController,
        CardTemplateSearchFilter,
        ViewCardsSearchState,
        ViewCardsLayoutMode,
        CardTemplateSearchFilterCodec,
        CardTemplateSearchResults,
        StudyCard,
        StudyCardSearchFilter,
        StudyCardSearchFilterCodec,
        StudyCardSearchResults,
        FlashcardTemplate,
        FilteredSearchBar,
        ViewCardTile,
        ViewCardsReversibleGroup;
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
  final ViewCardsSearchState<CardTemplate, CardTemplateSearchFilter>
  searchState;
  final ViewCardsLayoutMode layoutMode;
  final bool hasSearchQuery;

  @override
  Widget build(BuildContext context) {
    final entries = _buildTemplateEntries(
      searchState.controller.results,
      layoutMode,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilteredSearchBar<CardTemplate, CardTemplateSearchFilter>(
          controller: searchState.controller,
          filterCodec: const CardTemplateSearchFilterCodec(),
          searchResults: const CardTemplateSearchResults(),
          items: controller.templates,
          placeholder: 'Search ${searchState.scope.label.toLowerCase()}',
        ),
        const SizedBox(height: AppSpacing.lg),
        ListingStatesWrapper<_ViewCardsTemplateEntry>.wrap(
          isLoading: controller.isLoading,
          exception: controller.error,
          items: entries,
          emptyState: hasSearchQuery
              ? const EmptyState(
                  icon: Icons.search_off,
                  title: 'No templates found',
                  message: 'Try a different query or remove filters.',
                )
              : const EmptyState(
                  icon: Icons.view_carousel_outlined,
                  title: 'No templates yet',
                  message: 'Add card templates to your decks to browse them.',
                ),
          onRetry: controller.load,
          skeletonTile: const _ViewCardSkeletonTile(),
          spacing: AppSpacing.xl,
          runSpacing: AppSpacing.xl,
          itemBuilder: (context, _, entry) {
            return switch (entry) {
              _TemplateSingleEntry(:final template) => ViewCardTile.template(
                template: template,
              ),
              _TemplatePairEntry(:final template) =>
                ViewCardsReversibleGroup.template(template: template),
              _ => const SizedBox.shrink(),
            };
          },
        ),
      ],
    );
  }
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
  final ViewCardsSearchState<StudyCard, StudyCardSearchFilter> searchState;
  final ViewCardsLayoutMode layoutMode;
  final bool hasSearchQuery;

  @override
  Widget build(BuildContext context) {
    final entries = _buildStudyCardEntries(
      searchState.controller.results,
      layoutMode,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilteredSearchBar<StudyCard, StudyCardSearchFilter>(
          controller: searchState.controller,
          filterCodec: const StudyCardSearchFilterCodec(),
          searchResults: const StudyCardSearchResults(),
          items: controller.cards,
          placeholder: 'Search ${searchState.scope.label.toLowerCase()}',
        ),
        const SizedBox(height: AppSpacing.lg),
        ListingStatesWrapper<_ViewCardsStudyCardEntry>.wrap(
          isLoading: controller.isLoading,
          exception: controller.error,
          items: entries,
          emptyState: hasSearchQuery
              ? const EmptyState(
                  icon: Icons.search_off,
                  title: 'No cards found',
                  message: 'Try a different query or remove filters.',
                )
              : const EmptyState(
                  icon: Icons.view_carousel_outlined,
                  title: 'No cards yet',
                  message:
                      'Add templates to your decks to generate study cards.',
                ),
          onRetry: controller.load,
          skeletonTile: const _ViewCardSkeletonTile(),
          spacing: AppSpacing.xl,
          runSpacing: AppSpacing.xl,
          itemBuilder: (context, _, entry) {
            return switch (entry) {
              _StudyCardSingleEntry(:final card) => ViewCardTile.studyCard(
                studyCard: card,
              ),
              _StudyCardPairEntry(:final frontCard, :final backCard) =>
                ViewCardsReversibleGroup.studyCards(
                  frontCard: frontCard,
                  backCard: backCard,
                ),
              _ => const SizedBox.shrink(),
            };
          },
        ),
      ],
    );
  }
}

abstract class _ViewCardsTemplateEntry {
  const _ViewCardsTemplateEntry();
}

class _TemplateSingleEntry extends _ViewCardsTemplateEntry {
  const _TemplateSingleEntry(this.template);

  final CardTemplate template;
}

class _TemplatePairEntry extends _ViewCardsTemplateEntry {
  const _TemplatePairEntry(this.template);

  final CardTemplate template;
}

abstract class _ViewCardsStudyCardEntry {
  const _ViewCardsStudyCardEntry();
}

class _StudyCardSingleEntry extends _ViewCardsStudyCardEntry {
  const _StudyCardSingleEntry(this.card);

  final StudyCard card;
}

class _StudyCardPairEntry extends _ViewCardsStudyCardEntry {
  const _StudyCardPairEntry({required this.frontCard, required this.backCard});

  final StudyCard frontCard;
  final StudyCard backCard;
}

List<_ViewCardsTemplateEntry> _buildTemplateEntries(
  List<CardTemplate> templates,
  ViewCardsLayoutMode layoutMode,
) {
  if (layoutMode == ViewCardsLayoutMode.compact) {
    return [for (final template in templates) _TemplateSingleEntry(template)];
  }

  return [
    for (final template in templates)
      if (template is FlashcardTemplate)
        _TemplatePairEntry(template)
      else
        _TemplateSingleEntry(template),
  ];
}

List<_ViewCardsStudyCardEntry> _buildStudyCardEntries(
  List<StudyCard> cards,
  ViewCardsLayoutMode layoutMode,
) {
  if (layoutMode == ViewCardsLayoutMode.compact) {
    return [for (final card in cards) _StudyCardSingleEntry(card)];
  }

  final entries = <_ViewCardsStudyCardEntry>[];
  final handledTemplateIds = <String>{};

  for (final card in cards) {
    final template = card.template;
    if (template is! FlashcardTemplate) {
      entries.add(_StudyCardSingleEntry(card));
      continue;
    }

    if (handledTemplateIds.contains(card.templateId)) {
      continue;
    }

    final group = cards
        .where(
          (candidate) =>
              candidate.templateId == card.templateId &&
              candidate.template is FlashcardTemplate,
        )
        .toList();
    handledTemplateIds.add(card.templateId);

    if (group.length >= 2) {
      final frontCards = group
          .where((candidate) => candidate.isReversed == false)
          .toList();
      final backCards = group
          .where((candidate) => candidate.isReversed)
          .toList();

      if (frontCards.isNotEmpty && backCards.isNotEmpty) {
        entries.add(
          _StudyCardPairEntry(
            frontCard: frontCards.first,
            backCard: backCards.first,
          ),
        );
      } else {
        entries.addAll(group.map(_StudyCardSingleEntry.new));
      }
    } else {
      entries.addAll(group.map(_StudyCardSingleEntry.new));
    }
  }

  return entries;
}

class _ViewCardSkeletonTile extends StatelessWidget {
  const _ViewCardSkeletonTile();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 280,
      child: AspectRatio(
        aspectRatio: 0.7142857142857143,
        child: DecoratedBox(
          decoration: BoxDecoration(color: Colors.white),
          child: SizedBox.expand(),
        ),
      ),
    );
  }
}
