sealed class StudySessionCard {
  const StudySessionCard({required this.id});

  final String id;
}

class StudyFlashcard extends StudySessionCard {
  const StudyFlashcard({
    required super.id,
    required this.front,
    required this.back,
  });

  final String front;
  final String back;
}

class StudyMcqCard extends StudySessionCard {
  const StudyMcqCard({
    required super.id,
    required this.prompt,
    required this.options,
    required this.correctOption,
  });

  final String prompt;
  final List<String> options;
  final String correctOption;
}

class StudyBlanksCard extends StudySessionCard {
  const StudyBlanksCard({
    required super.id,
    required this.prefix,
    required this.blankAnswer,
    required this.suffix,
  });

  final String prefix;
  final String blankAnswer;
  final String suffix;
}

class StudyMatchCard extends StudySessionCard {
  const StudyMatchCard({required super.id, required this.pairs});

  final List<StudyMatchPair> pairs;
}

class StudyMatchPair {
  const StudyMatchPair({required this.term, required this.match});

  final String term;
  final String match;
}
