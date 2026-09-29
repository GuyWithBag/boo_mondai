import 'package:boo_mondai/lib.barrel.dart'
    show
        CardTemplate,
        FillInTheBlanksTemplate,
        FlashcardTemplate,
        IdentificationTemplate,
        MatchingTypeTemplate,
        MultipleChoiceTemplate,
        SearchTokenShape,
        SearchTokens,
        WordScrambleTemplate;

enum ViewCardsLayoutMode { compact, paired }

abstract final class ViewCardsSearch {
  static const tag = SearchTokenShape(name: 'tag', aliases: ['tags']);
  static const fuzzy = SearchTokenShape(name: 'fuzzy', aliases: ['cutoff']);

  static const tokenShapes = [tag, fuzzy];

  static String templateSearchTextLabel(CardTemplate template) {
    return [
      template.id,
      template.deckId,
      template.runtimeType.toString(),
      for (final tag in template.tags) tag.name,
      ..._templateText(template),
    ].join(' ');
  }

  static bool templateItemFilter(CardTemplate template, SearchTokens tokens) {
    final selectedTags = tokens
        .getAll(tag)
        .map((value) => value.trim().toLowerCase())
        .where((value) => value.isNotEmpty)
        .toSet();
    if (selectedTags.isEmpty) return true;

    final templateTags = template.tags
        .map((tag) => tag.name.trim().toLowerCase())
        .toSet();
    return selectedTags.every(templateTags.contains);
  }

  static List<String> _templateText(CardTemplate template) {
    return switch (template) {
      FlashcardTemplate() => [template.frontText, template.backText],
      IdentificationTemplate() => [
        template.promptText,
        for (final answer in template.answers) answer.value,
      ],
      MultipleChoiceTemplate() => [
        template.questionPrompt,
        for (final option in template.options) option.optionText,
      ],
      FillInTheBlanksTemplate() => [
        template.promptText,
        for (final key in template.answerKeys) key.value,
      ],
      MatchingTypeTemplate() => [
        for (final value in template.values) value.text,
      ],
      WordScrambleTemplate() => [template.sentenceToScramble],
      _ => const [],
    };
  }
}
