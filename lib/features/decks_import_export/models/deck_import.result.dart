final class DeckImportResult {
  const DeckImportResult({
    this.decks = const [],
    this.cardTemplates = const [],
    this.multipleChoiceOptions = const [],
    this.identificationAnswers = const [],
    this.fillInTheBlankSegments = const [],
    this.matchMadnessPairs = const [],
  });

  factory DeckImportResult.empty() => const DeckImportResult();

  final List<Map<String, dynamic>> decks;
  final List<Map<String, dynamic>> cardTemplates;
  final List<Map<String, dynamic>> multipleChoiceOptions;
  final List<Map<String, dynamic>> identificationAnswers;
  final List<Map<String, dynamic>> fillInTheBlankSegments;
  final List<Map<String, dynamic>> matchMadnessPairs;

  DeckImportResult merge(DeckImportResult other) {
    return DeckImportResult(
      decks: [...decks, ...other.decks],
      cardTemplates: [...cardTemplates, ...other.cardTemplates],
      multipleChoiceOptions: [
        ...multipleChoiceOptions,
        ...other.multipleChoiceOptions,
      ],
      identificationAnswers: [
        ...identificationAnswers,
        ...other.identificationAnswers,
      ],
      fillInTheBlankSegments: [
        ...fillInTheBlankSegments,
        ...other.fillInTheBlankSegments,
      ],
      matchMadnessPairs: [...matchMadnessPairs, ...other.matchMadnessPairs],
    );
  }
}
