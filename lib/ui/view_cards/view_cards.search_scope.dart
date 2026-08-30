import 'package:boo_mondai/lib.barrel.dart'
    show
        CardTemplate,
        CardTemplateSearchFilter,
        SearchScope,
        CardTemplateSearchFilterCodec,
        CardTemplateSearchResults,
        StudyCard,
        StudyCardSearchFilter,
        StudyCardSearchFilterCodec,
        StudyCardSearchResults;

enum ViewCardsSearchScope { templates, studyCards }

enum ViewCardsLayoutMode { compact, paired }

SearchScope<ViewCardsSearchScope, CardTemplate, CardTemplateSearchFilter>
buildViewCardsTemplateScope(Iterable<CardTemplate> items) {
  return SearchScope<
    ViewCardsSearchScope,
    CardTemplate,
    CardTemplateSearchFilter
  >(
    value: ViewCardsSearchScope.templates,
    label: 'Templates',
    filterCodec: const CardTemplateSearchFilterCodec(),
    searchResults: const CardTemplateSearchResults(),
    items: items,
  );
}

SearchScope<ViewCardsSearchScope, StudyCard, StudyCardSearchFilter>
buildViewCardsStudyCardsScope(Iterable<StudyCard> items) {
  return SearchScope<ViewCardsSearchScope, StudyCard, StudyCardSearchFilter>(
    value: ViewCardsSearchScope.studyCards,
    label: 'Cards',
    filterCodec: const StudyCardSearchFilterCodec(),
    searchResults: const StudyCardSearchResults(),
    items: items,
  );
}
