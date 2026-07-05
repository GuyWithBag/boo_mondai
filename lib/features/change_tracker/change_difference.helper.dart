import 'package:boo_mondai/lib.barrel.dart'
    show
        CardTemplate,
        ChangedProperty,
        ChangeType,
        Deck,
        FillInTheBlanksTemplate,
        FlashcardTemplate,
        IdentificationTemplate,
        MatchMadnessTemplate,
        MultipleChoiceTemplate,
        Tag,
        WordScrambleTemplate;

/// Compares two versions of the same entity and returns display-ready field
/// differences.
///
/// Used by [DeckDownloadsService] to populate [ChangedEntity.changedProperties] before
/// passing records to [ChangeTrackerController]. All methods are pure and
/// stateless.
abstract final class ChangeDifferenceHelper {
  /// Returns the metadata changedProperties that differ between [before] and [after].
  ///
  /// Returns an empty list when the decks are identical in all tracked changedProperties.
  static List<ChangedProperty> decks(Deck before, Deck after) {
    return [
      if (before.title != after.title)
        ChangedProperty(
          propertyLabel: 'Title',
          type: ChangeType.modified,
          before: before.title,
          after: after.title,
        ),
      if (before.shortDescription != after.shortDescription)
        ChangedProperty(
          propertyLabel: 'Short description',
          type: ChangeType.modified,
          before: before.shortDescription,
          after: after.shortDescription,
        ),
      if (before.longDescription != after.longDescription)
        ChangedProperty(
          propertyLabel: 'Long description',
          type: ChangeType.modified,
          before: before.longDescription,
          after: after.longDescription,
        ),
      if (_tagText(before.tags) != _tagText(after.tags))
        ChangedProperty(
          propertyLabel: 'Tags',
          type: ChangeType.modified,
          before: _tagText(before.tags),
          after: _tagText(after.tags),
        ),
    ];
  }

  /// Returns the template changedProperties that differ between [before] and [after].
  ///
  /// Returns an empty list when both templates are the same type and identical
  /// in all tracked changedProperties. Returns a single `Card type` entry when the
  /// templates are different subtypes.
  static List<ChangedProperty> templates(
    CardTemplate before,
    CardTemplate after,
  ) {
    final properties = <ChangedProperty>[];
    if (_tagText(before.tags) != _tagText(after.tags)) {
      properties.add(
        ChangedProperty(
          propertyLabel: 'Tags',
          type: ChangeType.modified,
          before: _tagText(before.tags),
          after: _tagText(after.tags),
        ),
      );
    }
    properties.addAll(_templateProperties(before, after));
    return properties;
  }

  /// Returns a concise display title for [template].
  ///
  /// Falls back to the runtime type name when no content text is available.
  static String templateTitle(CardTemplate template) {
    final preview = templatePreview(template);
    if (preview.trim().isEmpty) return template.runtimeType.toString();
    return preview;
  }

  /// Returns the primary prompt or content text for [template].
  ///
  /// Returns an empty string for unsupported subtypes.
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

  static List<ChangedProperty> _templateProperties(
    CardTemplate before,
    CardTemplate after,
  ) {
    if (before.runtimeType != after.runtimeType) {
      return [
        ChangedProperty(
          propertyLabel: 'Card type',
          type: ChangeType.modified,
          before: before.runtimeType,
          after: after.runtimeType,
        ),
      ];
    }

    return switch ((before, after)) {
      (FlashcardTemplate b, FlashcardTemplate a) => [
        if (b.frontText != a.frontText)
          ChangedProperty(
            propertyLabel: 'Front',
            type: ChangeType.modified,
            before: b.frontText,
            after: a.frontText,
          ),
        if (b.backText != a.backText)
          ChangedProperty(
            propertyLabel: 'Back',
            type: ChangeType.modified,
            before: b.backText,
            after: a.backText,
          ),
      ],
      (IdentificationTemplate b, IdentificationTemplate a) => [
        if (b.promptText != a.promptText)
          ChangedProperty(
            propertyLabel: 'Prompt',
            type: ChangeType.modified,
            before: b.promptText,
            after: a.promptText,
          ),
        if (b.acceptedAnswers != a.acceptedAnswers)
          ChangedProperty(
            propertyLabel: 'Accepted answers',
            type: ChangeType.modified,
            before: b.acceptedAnswers,
            after: a.acceptedAnswers,
          ),
      ],
      (MultipleChoiceTemplate b, MultipleChoiceTemplate a) => [
        if (b.questionPrompt != a.questionPrompt)
          ChangedProperty(
            propertyLabel: 'Question',
            type: ChangeType.modified,
            before: b.questionPrompt,
            after: a.questionPrompt,
          ),
        if (_optionText(b) != _optionText(a))
          ChangedProperty(
            propertyLabel: 'Options',
            type: ChangeType.modified,
            before: _optionText(b),
            after: _optionText(a),
          ),
      ],
      (FillInTheBlanksTemplate b, FillInTheBlanksTemplate a) => [
        if (_segmentText(b) != _segmentText(a))
          ChangedProperty(
            propertyLabel: 'Segments',
            type: ChangeType.modified,
            before: _segmentText(b),
            after: _segmentText(a),
          ),
      ],
      (MatchMadnessTemplate b, MatchMadnessTemplate a) => [
        if (_pairText(b) != _pairText(a))
          ChangedProperty(
            propertyLabel: 'Pairs',
            type: ChangeType.modified,
            before: _pairText(b),
            after: _pairText(a),
          ),
      ],
      (WordScrambleTemplate b, WordScrambleTemplate a) => [
        if (b.sentenceToScramble != a.sentenceToScramble)
          ChangedProperty(
            propertyLabel: 'Sentence',
            type: ChangeType.modified,
            before: b.sentenceToScramble,
            after: a.sentenceToScramble,
          ),
      ],
      _ => const <ChangedProperty>[],
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
