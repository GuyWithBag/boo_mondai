import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        FlashcardTemplate,
        ListingStatesWrapper,
        ViewCardsController,
        ViewCardsTile,
        ViewCardsListTile,
        ThemeController;
import 'package:flutter/material.dart';
import 'package:signals_hooks/signals_hooks.dart';

class ViewCardsListView extends SignalWidget {
  const ViewCardsListView({super.key, required this.controller});

  final ViewCardsController controller;

  @override
  Widget build(BuildContext context) {
    final tokens = ThemeController.tokens;

    return ListingStatesWrapper.list(
      useParentScroll: true,
      isLoading: controller.isLoading.value,
      exception: controller.error.value,
      items: controller.searchController.results.value,
      emptyState: controller.emptyState.value,
      padding: EdgeInsets.zero,
      onRetry: controller.load,
      skeletonTile: ViewCardsTile.template(
        template: FlashcardTemplate.createDummy(),
      ),
      separatorHeight: tokens.spaceLayoutGapSm,
      itemBuilder: (context, index, item) {
        return ViewCardsListTile.template(template: item);
      },
    );
  }
}
