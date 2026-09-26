String buildViewCardsInitialSearchText(Map<String, String> queryParameters) {
  final parts = <String>[];

  void addRaw(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return;
    parts.add(trimmed);
  }

  void addDirective(String key, String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return;
    for (final token in trimmed.split(',')) {
      final cleaned = token.trim();
      if (cleaned.isEmpty) continue;
      parts.add('$key:${_quoteIfNeeded(cleaned)}');
    }
  }

  addRaw(queryParameters['filter']);
  addRaw(queryParameters['search']);
  addRaw(queryParameters['q']);
  addRaw(queryParameters['query']);

  addDirective('deck', queryParameters['deck']);
  addDirective('deck', queryParameters['deckId']);
  addDirective('template', queryParameters['template']);
  addDirective('template', queryParameters['templateId']);
  addDirective('tag', queryParameters['tag']);
  addDirective('tag', queryParameters['tags']);
  addDirective('tag_id', queryParameters['tagId']);
  addDirective('tag_id', queryParameters['tagIds']);
  addDirective('reversed', queryParameters['reversed']);
  addDirective('fuzzy', queryParameters['fuzzy']);
  addDirective('fuzzy', queryParameters['cutoff']);

  return parts.join(' ').trim();
}

String cleanViewCardsSearchText(String text) {
  return text.trim();
}

String _quoteIfNeeded(String value) {
  if (value.contains(RegExp(r'[\s,]'))) {
    return '"$value"';
  }
  return value;
}
