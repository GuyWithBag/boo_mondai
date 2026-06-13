import 'package:boo_mondai/lib.barrel.dart'
    show
        CardTemplate,
        ChangeFieldDiff,
        Deck,
        FillInTheBlanksTemplate,
        FlashcardTemplate,
        IdentificationTemplate,
        MatchMadnessTemplate,
        MultipleChoiceTemplate,
        Tag,
        WordScrambleTemplate;

class ChangeReviewDiffService {
  const ChangeReviewDiffService._();

  static List<ChangeFieldDiff> diffDecks(Deck before, Deck after) {
    return [
      if (before.title != after.title)
        ChangeFieldDiff(
          field: 'Title',
          before: before.title,
          after: after.title,
        ),
      if (before.shortDescription != after.shortDescription)
        ChangeFieldDiff(
          field: 'Short description',
          before: before.shortDescription,
          after: after.shortDescription,
        ),
      if (before.longDescription != after.longDescription)
        ChangeFieldDiff(
          field: 'Long description',
          before: before.longDescription,
          after: after.longDescription,
        ),
      if (_tagText(before.tags) != _tagText(after.tags))
        ChangeFieldDiff(
          field: 'Tags',
          before: _tagText(before.tags),
          after: _tagText(after.tags),
        ),
    ];
  }

  static List<ChangeFieldDiff> diffTemplates(
    CardTemplate before,
    CardTemplate after,
  ) {
    final fields = <ChangeFieldDiff>[];
    if (_tagText(before.tags) != _tagText(after.tags)) {
      fields.add(
        ChangeFieldDiff(
          field: 'Tags',
          before: _tagText(before.tags),
          after: _tagText(after.tags),
        ),
      );
    }
    fields.addAll(_templateFields(before, after));
    return fields;
  }

  static String templateTitle(CardTemplate template) {
    final preview = templatePreview(template);
    if (preview.trim().isEmpty) return template.runtimeType.toString();
    return preview;
  }

  static String templatePreview(CardTemplate template) {
    return switch (template) {
      FlashcardTemplate t => t.frontText,
      IdentificationTemplate t => t.promptText,
      MultipleChoiceTemplate t => t.questionPrompt,
      FillInTheBlanksTemplate t =>
        t.segments.isEmpty ? '' : t.segments.first.fullText,
      MatchMadnessTemplate t =>
        t.pairs.take(3).map((pair) => pair.term).join(', '),
      WordScrambleTemplate t => t.sentenceToScramble,
      _ => '',
    };
  }

  static List<ChangeFieldDiff> _templateFields(
    CardTemplate before,
    CardTemplate after,
  ) {
    if (before.runtimeType != after.runtimeType) {
      return [
        ChangeFieldDiff(
          field: 'Card type',
          before: before.runtimeType,
          after: after.runtimeType,
        ),
      ];
    }

    return switch ((before, after)) {
      (FlashcardTemplate b, FlashcardTemplate a) => [
        if (b.frontText != a.frontText)
          ChangeFieldDiff(
            field: 'Front',
            before: b.frontText,
            after: a.frontText,
          ),
        if (b.backText != a.backText)
          ChangeFieldDiff(field: 'Back', before: b.backText, after: a.backText),
      ],
      (IdentificationTemplate b, IdentificationTemplate a) => [
        if (b.promptText != a.promptText)
          ChangeFieldDiff(
            field: 'Prompt',
            before: b.promptText,
            after: a.promptText,
          ),
        if (b.acceptedAnswers != a.acceptedAnswers)
          ChangeFieldDiff(
            field: 'Accepted answers',
            before: b.acceptedAnswers,
            after: a.acceptedAnswers,
          ),
      ],
      (MultipleChoiceTemplate b, MultipleChoiceTemplate a) => [
        if (b.questionPrompt != a.questionPrompt)
          ChangeFieldDiff(
            field: 'Question',
            before: b.questionPrompt,
            after: a.questionPrompt,
          ),
        if (_optionText(b) != _optionText(a))
          ChangeFieldDiff(
            field: 'Options',
            before: _optionText(b),
            after: _optionText(a),
          ),
      ],
      (FillInTheBlanksTemplate b, FillInTheBlanksTemplate a) => [
        if (_segmentText(b) != _segmentText(a))
          ChangeFieldDiff(
            field: 'Segments',
            before: _segmentText(b),
            after: _segmentText(a),
          ),
      ],
      (MatchMadnessTemplate b, MatchMadnessTemplate a) => [
        if (_pairText(b) != _pairText(a))
          ChangeFieldDiff(
            field: 'Pairs',
            before: _pairText(b),
            after: _pairText(a),
          ),
      ],
      (WordScrambleTemplate b, WordScrambleTemplate a) => [
        if (b.sentenceToScramble != a.sentenceToScramble)
          ChangeFieldDiff(
            field: 'Sentence',
            before: b.sentenceToScramble,
            after: a.sentenceToScramble,
          ),
      ],
      _ => const <ChangeFieldDiff>[],
    };
  }

  static String _tagText(List<Tag> tags) {
    final names = tags.map((tag) => tag.name).toList()..sort();
    return names.join(', ');
  }

  static String _optionText(MultipleChoiceTemplate template) => template.options
      .map((option) => '${option.optionText}${option.isCorrect ? '*' : ''}')
      .join(', ');

  static String _segmentText(FillInTheBlanksTemplate template) => template
      .segments
      .map((segment) => '${segment.fullText} -> ${segment.correctAnswer}')
      .join(', ');

  static String _pairText(MatchMadnessTemplate template) =>
      template.pairs.map((pair) => '${pair.term}:${pair.match}').join(', ');
}
