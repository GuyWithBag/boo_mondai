import 'package:dart_mappable/dart_mappable.dart';

part 'multiple_choice_option_data.mapper.dart';

@MappableClass()
class MultipleChoiceOptionData with MultipleChoiceOptionDataMappable {
  final String text;
  final bool isCorrect;

  const MultipleChoiceOptionData({required this.text, required this.isCorrect});
}
