import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        FlashcardTemplate,
        ListingStatesWrapper,
        ViewCardsController,
        ViewCardsTile,
        ThemeController;
import 'package:flutter/material.dart';
import 'package:signals_hooks/signals_hooks.dart';

class ViewCardsPairedView extends SignalWidget {
  const ViewCardsPairedView({super.key, required this.controller});

  final ViewCardsController controller;

  @override
  Widget build(BuildContext context) {
    final tokens = ThemeController.tokens;

    return ListingStatesWrapper.wrap(
      isLoading: controller.isLoading.value,
      exception: controller.error.value,
      items: controller.searchController.results.value,
      emptyState: controller.emptyState.value,
      onRetry: controller.load,
      skeletonTile: ViewCardsTile.template(
        template: FlashcardTemplate.createDummy(),
      ),
      spacing: tokens.spaceLayoutGapMd,
      runSpacing: tokens.spaceLayoutGapMd,
      itemBuilder: (context, _, item) => LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth < 280
              ? constraints.maxWidth
              : 280.0;
          return ViewCardsTile.template(
            template: item,
            width: width,
            editable: true,
          );
        },
      ),
    );
  }
}
