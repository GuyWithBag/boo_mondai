import 'package:boo_mondai/lib.barrel.dart' show SearchFilter;

final class ResearcherSurveyFilter implements SearchFilter {
  const ResearcherSurveyFilter({
    required this.freeText,
    this.onlyWithResponses = false,
    this.fuzzyCutoff = 60,
  });

  @override
  final String freeText;
  final bool onlyWithResponses;
  @override
  final int fuzzyCutoff;

  static ResearcherSurveyFilter parse(String input) {
    final terms = <String>[];
    var onlyWithResponses = false;

    for (final token in input.trim().split(RegExp(r'\s+'))) {
      if (token.isEmpty) continue;
      final normalized = token.toLowerCase();
      if (normalized == 'has:responses' || normalized == 'responses:true') {
        onlyWithResponses = true;
      } else {
        terms.add(token);
      }
    }

    return ResearcherSurveyFilter(
      freeText: terms.join(' ').trim(),
      onlyWithResponses: onlyWithResponses,
    );
  }

  @override
  String toSearchText() {
    return [
      freeText,
      if (onlyWithResponses) 'has:responses',
    ].where((part) => part.trim().isNotEmpty).join(' ').trim();
  }
}
