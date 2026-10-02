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
        ViewCardsLayoutModeView,
        ViewCardsWrapView,
        ViewCardsListView;
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

    Widget getBody() {
      switch (controller.layoutMode.value) {
        case ViewCardsLayoutModeView.wrap:
          return ViewCardsWrapView(controller: controller);
        case ViewCardsLayoutModeView.list:
          return ViewCardsListView(controller: controller);
        case _:
          return SizedBox.shrink();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: 'View Cards',
        header: FilteredSearchBar<CardTemplate>(
          controller: controller.templateSearchController,
          placeholder: 'Search templates',
        ),
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
              SegmentedControl<ViewCardsLayoutModeView>(
                value: layoutMode,
                onChanged: controller.setLayoutMode,
                options: const [
                  // ToDo: Add paired option
                  SegmentOption(
                    value: ViewCardsLayoutModeView.wrap,
                    label: 'Wrap',
                  ),
                  SegmentOption(
                    value: ViewCardsLayoutModeView.list,
                    label: 'List',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

      body: getBody(),
    );
  }
}
