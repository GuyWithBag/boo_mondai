import 'package:boo_mondai/lib.barrel.dart'
    show
        buildViewCardsInitialSearchText,
        CardTemplate,
        cleanViewCardsSearchText,
        FilteredSearchBarController,
        LocalDB,
        ViewCardsSearch,
        ViewCardsLayoutModeView,
        StatusLayoutState;
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:signals/signals_flutter.dart';

class ViewCardsController {
  ViewCardsController({Map<String, String> queryParameters = const {}}) {
    final initialSearchText = cleanViewCardsSearchText(
      buildViewCardsInitialSearchText(queryParameters),
    );

    templateSearchController = FilteredSearchBarController<CardTemplate>(
      tokenShapes: ViewCardsSearch.tokenShapes,
      searchTextLabel: ViewCardsSearch.templateSearchTextLabel,
      itemFilter: ViewCardsSearch.templateItemFilter,
      items: templates.value,
      initialInput: initialSearchText,
    );
    hasSearchQuery = computed(() => templateSearchController.hasText.value);

    deckListenable = LocalDB.deck.box.listenable();
    templateListenable = LocalDB.cardTemplate.box.listenable();

    deckListenable.addListener(load);
    templateListenable.addListener(load);
  }

  late final Listenable deckListenable;
  late final Listenable templateListenable;
  final layoutMode = signal(ViewCardsLayoutModeView.wrap);
  final isLoading = signal(false);
  final error = signal<Exception?>(null);
  final templates = listSignal<CardTemplate>(const []);
  late final FilteredSearchBarController<CardTemplate> templateSearchController;
  late final Computed<bool> hasSearchQuery;

  late final emptyState = computed(() {
    return hasSearchQuery.value
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
  });

  void setLayoutMode(ViewCardsLayoutModeView value) {
    layoutMode.value = value;
  }

  void dispose() {
    deckListenable.removeListener(load);
    templateListenable.removeListener(load);
    hasSearchQuery.dispose();
    templateSearchController.dispose();
    templates.dispose();
    error.dispose();
    isLoading.dispose();
    layoutMode.dispose();
  }

  void load() {
    isLoading.value = true;
    error.value = null;

    Exception? failure;
    try {
      final templatesById = {
        for (final template in LocalDB.cardTemplate.box.values)
          template.id: template,
      };

      final loadedTemplates = templatesById.values.toList()
        ..sort(_compareTemplates);
      templates.value = List.unmodifiable(loadedTemplates);
      templateSearchController.setItems(loadedTemplates);
    } on Exception catch (e) {
      failure = e;
    } finally {
      isLoading.value = false;
      error.value = failure;
    }
  }

  int _compareTemplates(CardTemplate left, CardTemplate right) {
    if (left.deckId != right.deckId) {
      return left.deckId.compareTo(right.deckId);
    }

    if (left.sortOrder != right.sortOrder) {
      return left.sortOrder.compareTo(right.sortOrder);
    }

    return left.id.compareTo(right.id);
  }
}
