import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        FlashcardTemplate,
        ListingStatesWrapper,
        ViewCardsController,
        ViewCardsTile;
import 'package:flutter/material.dart';
import 'package:signals_hooks/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class ViewCardsWrapView extends SignalWidget {
  const ViewCardsWrapView({super.key, required this.controller});

  final ViewCardsController controller;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

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
      itemBuilder: (context, _, item) =>
          ViewCardsTile.template(template: item, width: 150, editable: true),
    );
  }
}
