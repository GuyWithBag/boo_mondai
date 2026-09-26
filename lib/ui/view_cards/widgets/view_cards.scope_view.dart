import 'package:boo_mondai/lib.barrel.dart'
    show
        StatusLayoutState,
        CardTemplate,
        ViewCardsController,
        ViewCardsLayoutMode,
        FlashcardTemplate,
        ViewCardsTile,
        ViewCardsByPairTile,
        ViewCardsListLayout,
        GridTileMaxWidthConstraints;
import 'package:flutter/material.dart';

class ViewCardsTemplateScopeView extends StatelessWidget {
  const ViewCardsTemplateScopeView({
    required this.controller,
    required this.entries,
    required this.layoutMode,
    required this.hasSearchQuery,
    super.key,
  });

  final ViewCardsController controller;
  final List<CardTemplate> entries;
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
      isLoading: controller.isLoading.value,
      exception: controller.error.value,
      entries: entries,
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
