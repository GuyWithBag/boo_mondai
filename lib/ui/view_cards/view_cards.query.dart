import 'package:boo_mondai/lib.barrel.dart' show ViewCardsSearchScope;

ViewCardsSearchScope resolveViewCardsInitialScope(
  Map<String, String> queryParameters,
) {
  final scope = queryParameters['scope']?.trim().toLowerCase();
  if (scope == null || scope.isEmpty) {
    if (_isTruthy(queryParameters['studyCards'])) {
      return ViewCardsSearchScope.studyCards;
    }
    return ViewCardsSearchScope.templates;
  }

  return switch (scope) {
    'studycards' || 'study_cards' || 'cards' => ViewCardsSearchScope.studyCards,
    _ => ViewCardsSearchScope.templates,
  };
}

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
  final cleanedTokens = <String>[];

  for (final token in text.split(RegExp(r'\s+'))) {
    final cleaned = token.trim();
    if (cleaned.isEmpty) continue;
    if (_isLegacyScopeToken(cleaned)) continue;
    cleanedTokens.add(cleaned);
  }

  return cleanedTokens.join(' ').trim();
}

bool _isLegacyScopeToken(String token) {
  final separatorIndex = token.indexOf(':');
  if (separatorIndex <= 0) return false;

  final key = token.substring(0, separatorIndex).trim().toLowerCase();
  final value = token.substring(separatorIndex + 1).trim().toLowerCase();
  return (key == 'studycards' || key == 'study_cards' || key == 'cards') &&
      (value == 'true' || value == 'yes' || value == 'y' || value == '1');
}

bool _isTruthy(String? value) {
  return switch ((value ?? '').trim().toLowerCase()) {
    'true' || 'yes' || 'y' || '1' => true,
    _ => false,
  };
}

String _quoteIfNeeded(String value) {
  if (value.contains(RegExp(r'[\s,]'))) {
    return '"$value"';
  }
  return value;
}
