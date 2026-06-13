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

SearchScope<CardTemplate, CardTemplateSearchFilter> buildViewCardsTemplateScope(
  Iterable<CardTemplate> items,
) {
  return SearchScope<CardTemplate, CardTemplateSearchFilter>(
    id: ViewCardsSearchScope.templates.name,
    label: 'Templates',
    filterCodec: const CardTemplateSearchFilterCodec(),
    searchResults: const CardTemplateSearchResults(),
    items: items,
  );
}

SearchScope<StudyCard, StudyCardSearchFilter> buildViewCardsStudyCardsScope(
  Iterable<StudyCard> items,
) {
  return SearchScope<StudyCard, StudyCardSearchFilter>(
    id: ViewCardsSearchScope.studyCards.name,
    label: 'Study cards',
    filterCodec: const StudyCardSearchFilterCodec(),
    searchResults: const StudyCardSearchResults(),
    items: items,
  );
}
