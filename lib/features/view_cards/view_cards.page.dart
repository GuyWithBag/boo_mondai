import 'package:boo_mondai/lib.barrel.dart'
    show
        AppSpacing,
        SegmentOption,
        SegmentedControl,
        ViewCardsController,
        CardTemplate,
        CardTemplateSearchFilter,
        StudyCard,
        StudyCardSearchFilter,
        ViewCardsSearchScope,
        ViewCardsLayoutMode,
        resolveViewCardsInitialScope,
        buildViewCardsInitialSearchText,
        cleanViewCardsSearchText,
        buildViewCardsTemplateScope,
        buildViewCardsStudyCardsScope,
        ViewCardsSearchState,
        ViewCardsTemplateScopeView,
        ViewCardsStudyCardScopeView;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

class ViewCardsPage extends StatelessWidget {
  const ViewCardsPage({super.key, this.queryParameters = const {}});

  final Map<String, String> queryParameters;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ViewCardsController()..load(),
      child: _ViewCardsView(queryParameters: queryParameters),
    );
  }
}

class _ViewCardsView extends HookWidget {
  const _ViewCardsView({required this.queryParameters});

  final Map<String, String> queryParameters;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ViewCardsController>();
    final initialScope = resolveViewCardsInitialScope(queryParameters);
    final initialSearchText = cleanViewCardsSearchText(
      buildViewCardsInitialSearchText(queryParameters),
    );
    final activeScope = useState(initialScope);
    final layoutMode = useState(ViewCardsLayoutMode.compact);

    final templateScopeConfig = buildViewCardsTemplateScope(
      controller.templates,
    );
    final studyCardsScopeConfig = buildViewCardsStudyCardsScope(
      controller.cards,
    );

    final templateSearchState = useMemoized(
      () => ViewCardsSearchState<CardTemplate, CardTemplateSearchFilter>(
        scope: templateScopeConfig,
        initialText: initialScope == ViewCardsSearchScope.templates
            ? initialSearchText
            : '',
        items: controller.templates,
      ),
      [
        templateScopeConfig,
        controller.templates,
        initialScope,
        initialSearchText,
      ],
    );
    final studyCardsSearchState = useMemoized(
      () => ViewCardsSearchState<StudyCard, StudyCardSearchFilter>(
        scope: studyCardsScopeConfig,
        initialText: initialScope == ViewCardsSearchScope.studyCards
            ? initialSearchText
            : '',
        items: controller.cards,
      ),
      [
        studyCardsScopeConfig,
        controller.cards,
        initialScope,
        initialSearchText,
      ],
    );

    useListenable(templateSearchState.controller);
    useListenable(studyCardsSearchState.controller);

    useEffect(() {
      templateSearchState.setItems(controller.templates);
      return null;
    }, [templateSearchState, controller.templates]);

    useEffect(() {
      studyCardsSearchState.setItems(controller.cards);
      return null;
    }, [studyCardsSearchState, controller.cards]);

    useEffect(() => templateSearchState.dispose, [templateSearchState]);
    useEffect(() => studyCardsSearchState.dispose, [studyCardsSearchState]);

    final isTemplateScope = activeScope.value == ViewCardsSearchScope.templates;
    final hasSearchQuery = isTemplateScope
        ? templateSearchState.controller.text.trim().isNotEmpty
        : studyCardsSearchState.controller.text.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('View Cards')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SegmentedControl<ViewCardsSearchScope>(
              value: activeScope.value,
              onChanged: (value) => activeScope.value = value,
              options: const [
                SegmentOption(
                  value: ViewCardsSearchScope.templates,
                  label: 'Templates',
                ),
                SegmentOption(
                  value: ViewCardsSearchScope.studyCards,
                  label: 'Cards',
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            SegmentedControl<ViewCardsLayoutMode>(
              value: layoutMode.value,
              onChanged: (value) => layoutMode.value = value,
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
            const SizedBox(height: AppSpacing.lg),
            if (isTemplateScope)
              ViewCardsTemplateScopeView(
                controller: controller,
                searchState: templateSearchState,
                layoutMode: layoutMode.value,
                hasSearchQuery: hasSearchQuery,
              )
            else
              ViewCardsStudyCardScopeView(
                controller: controller,
                searchState: studyCardsSearchState,
                layoutMode: layoutMode.value,
                hasSearchQuery: hasSearchQuery,
              ),
          ],
        ),
      ),
    );
  }
}
