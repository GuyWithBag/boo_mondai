import 'package:boo_mondai/lib.barrel.dart'
    show
        AppBar,
        AppTokens,
        CardTemplate,
        FilteredSearchBar,
        Scaffold,
        SegmentOption,
        SegmentedControl,
        ViewCardsController,
        ViewCardsLayoutMode,
        ViewCardsTemplateScopeView;
import 'package:flutter/material.dart' hide AppBar, Scaffold;
import 'package:provider/provider.dart';
import 'package:signals_hooks/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class ViewCardsPage extends StatelessWidget {
  const ViewCardsPage({super.key, this.queryParameters = const {}});

  final Map<String, String> queryParameters;

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) {
        final controller = ViewCardsController(
          queryParameters: queryParameters,
        );
        controller.load();
        return controller;
      },
      dispose: (_, controller) => controller.dispose(),
      child: const _ViewCardsView(),
    );
  }
}

class _ViewCardsView extends SignalHookWidget {
  const _ViewCardsView();

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final controller = context.read<ViewCardsController>();
    final layoutMode = controller.layoutMode.value;
    final hasSearchQuery = controller.hasSearchQuery.value;

    final searchBar = FilteredSearchBar<CardTemplate>(
      controller: controller.templateSearchController,
      placeholder: 'Search templates',
    );

    return Scaffold(
      appBar: AppBar(
        title: 'View Cards',
        header: searchBar,
        preferredBottomHeight: 104,
        bottom: Padding(
          padding: EdgeInsets.only(
            left: tokens.spaceScaffoldPadding,
            right: tokens.spaceScaffoldPadding,
            top: tokens.spaceLayoutGapSm,
          ),
          child: Column(
            spacing: tokens.spaceLayoutGapSm,
            children: [
              SegmentedControl<ViewCardsLayoutMode>(
                value: layoutMode,
                onChanged: controller.setLayoutMode,
                options: const [
                  SegmentOption(
                    value: ViewCardsLayoutMode.compact,
                    label: 'Cards',
                  ),
                  SegmentOption(
                    value: ViewCardsLayoutMode.paired,
                    label: 'Pairs',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: ViewCardsTemplateScopeView(
        controller: controller,
        entries: controller.templateSearchController.results.value,
        layoutMode: layoutMode,
        hasSearchQuery: hasSearchQuery,
      ),
    );
  }
}
