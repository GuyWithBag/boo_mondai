import 'package:boo_mondai/lib.barrel.dart'
    show
        SurveyBlock,
        SurveyBooleanInputBlock,
        SurveyDefinition,
        SurveyLikertInputBlock,
        SurveyMultipleChoiceInputBlock,
        SurveyNumberInputBlock,
        SurveyResponse,
        SurveyTextInputBlock,
        SurveyBlockHelper;

final class SurveyAnswerAggregate {
  const SurveyAnswerAggregate({
    required this.block,
    required this.totalResponses,
    required this.answeredCount,
    this.optionCounts = const {},
    this.textAnswers = const [],
    this.average,
    this.min,
    this.max,
  });

  final SurveyBlock block;
  final int totalResponses;
  final int answeredCount;
  final Map<String, int> optionCounts;
  final List<String> textAnswers;
  final num? average;
  final num? min;
  final num? max;
}

abstract final class ResearcherSurveyAnalyticsService {
  static List<SurveyAnswerAggregate> aggregate({
    required SurveyDefinition definition,
    required List<SurveyResponse> responses,
  }) {
    return [
      for (final block in definition.blocks.where(
        (block) => block.collectsAnswer,
      ))
        _aggregateBlock(block: block, responses: responses),
    ];
  }

  static SurveyAnswerAggregate _aggregateBlock({
    required SurveyBlock block,
    required List<SurveyResponse> responses,
  }) {
    final key = SurveyBlockHelper.keyFor(block);
    final values = [
      for (final response in responses)
        if (_isAnswered(response.answers[key])) response.answers[key],
    ];

    return switch (block) {
      SurveyTextInputBlock() => SurveyAnswerAggregate(
        block: block,
        totalResponses: responses.length,
        answeredCount: values.length,
        textAnswers: values.map((value) => value.toString()).toList(),
      ),
      SurveyNumberInputBlock() => _numericAggregate(block, responses, values),
      SurveyLikertInputBlock() => _numericAggregate(block, responses, values),
      SurveyBooleanInputBlock(:final trueLabel, :final falseLabel) =>
        SurveyAnswerAggregate(
          block: block,
          totalResponses: responses.length,
          answeredCount: values.length,
          optionCounts: {
            trueLabel: values.where((value) => value == true).length,
            falseLabel: values.where((value) => value == false).length,
          },
        ),
      SurveyMultipleChoiceInputBlock(:final options) => SurveyAnswerAggregate(
        block: block,
        totalResponses: responses.length,
        answeredCount: values.length,
        optionCounts: {
          for (final option in options)
            option.label: _countChoice(values, option.value),
        },
      ),
      _ => SurveyAnswerAggregate(
        block: block,
        totalResponses: responses.length,
        answeredCount: values.length,
      ),
    };
  }

  static SurveyAnswerAggregate _numericAggregate(
    SurveyBlock block,
    List<SurveyResponse> responses,
    List<dynamic> values,
  ) {
    final numbers = values.whereType<num>().toList();
    final sum = numbers.fold<num>(0, (total, value) => total + value);
    numbers.sort();

    return SurveyAnswerAggregate(
      block: block,
      totalResponses: responses.length,
      answeredCount: numbers.length,
      average: numbers.isEmpty ? null : sum / numbers.length,
      min: numbers.isEmpty ? null : numbers.first,
      max: numbers.isEmpty ? null : numbers.last,
      optionCounts: {
        for (final number in numbers.toSet())
          number.toString(): numbers.where((value) => value == number).length,
      },
    );
  }

  static int _countChoice(List<dynamic> values, String optionValue) {
    var count = 0;
    for (final value in values) {
      if (value is List && value.contains(optionValue)) count++;
    }
    return count;
  }

  static bool _isAnswered(dynamic value) {
    if (value == null) return false;
    if (value is String) return value.trim().isNotEmpty;
    if (value is List) return value.isNotEmpty;
    return true;
  }
}
