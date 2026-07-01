import 'package:boo_mondai/lib.barrel.dart'
    show
        AppBar,
        AppTokens,
        CardTemplate,
        CardTemplateSearchFilter,
        CardTemplateSearchFilterCodec,
        CardTemplateSearchResults,
        FilteredSearchBar,
        Scaffold,
        SegmentOption,
        SegmentedControl,
        StudyCard,
        StudyCardSearchFilter,
        StudyCardSearchFilterCodec,
        StudyCardSearchResults,
        ViewCardsController,
        ViewCardsLayoutMode,
        ViewCardsSearchScope,
        ViewCardsStudyCardScopeView,
        ViewCardsTemplateScopeView;
import 'package:flutter/material.dart' hide AppBar, Scaffold;
import 'package:provider/provider.dart';
import 'package:theme_variants/theme_variants.dart';

class ViewCardsPage extends StatelessWidget {
  const ViewCardsPage({super.key, this.queryParameters = const {}});

  final Map<String, String> queryParameters;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          ViewCardsController(queryParameters: queryParameters)..load(),
      child: const _ViewCardsView(),
    );
  }
}

class _ViewCardsView extends StatelessWidget {
  const _ViewCardsView();

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final controller = context.watch<ViewCardsController>();
    final searchBar = controller.isTemplateScope
        ? FilteredSearchBar<CardTemplate, CardTemplateSearchFilter>(
            controller: controller.templateSearchState.controller,
            filterCodec: const CardTemplateSearchFilterCodec(),
            searchResults: const CardTemplateSearchResults(),
            items: controller.templates,
            placeholder:
                'Search ${controller.templateSearchState.scope.label.toLowerCase()}',
          )
        : FilteredSearchBar<StudyCard, StudyCardSearchFilter>(
            controller: controller.studyCardsSearchState.controller,
            filterCodec: const StudyCardSearchFilterCodec(),
            searchResults: const StudyCardSearchResults(),
            items: controller.cards,
            placeholder:
                'Search ${controller.studyCardsSearchState.scope.label.toLowerCase()}',
          );

    return Scaffold(
      appBar: AppBar(
        title: 'View Cards',
        header: searchBar,
        preferredBottomHeight: 154,
        bottom: Padding(
          padding: EdgeInsets.only(
            left: tokens.spaceScaffoldPadding,
            right: tokens.spaceScaffoldPadding,
            top: tokens.spaceLayoutGapSm,
          ),
          child: Column(
            spacing: tokens.spaceLayoutGapSm,
            children: [
              SegmentedControl<ViewCardsSearchScope>(
                value: controller.activeScope,
                onChanged: controller.setActiveScope,
                options: [
                  for (final option in controller.scopeOptions)
                    SegmentOption(value: option.value, label: option.label),
                ],
              ),
              SegmentedControl<ViewCardsLayoutMode>(
                value: controller.layoutMode,
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
      body: controller.isTemplateScope
          ? ViewCardsTemplateScopeView(
              controller: controller,
              searchState: controller.templateSearchState,
              layoutMode: controller.layoutMode,
              hasSearchQuery: controller.hasSearchQuery,
            )
          : ViewCardsStudyCardScopeView(
              controller: controller,
              searchState: controller.studyCardsSearchState,
              layoutMode: controller.layoutMode,
              hasSearchQuery: controller.hasSearchQuery,
            ),
    );
  }
}
