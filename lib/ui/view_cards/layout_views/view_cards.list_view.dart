import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        FlashcardTemplate,
        ListingStatesWrapper,
        ViewCardsController,
        ViewCardsTile,
        ViewCardsListTile;
import 'package:flutter/material.dart';
import 'package:signals_hooks/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class ViewCardsListView extends SignalWidget {
  const ViewCardsListView({super.key, required this.controller});

  final ViewCardsController controller;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return ListingStatesWrapper.list(
      isLoading: controller.isLoading.value,
      exception: controller.error.value,
      items: controller.templates,
      emptyState: controller.emptyState.value,
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
