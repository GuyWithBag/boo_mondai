import 'package:boo_mondai/lib.barrel.dart'
    show ListHelper, MultipleChoiceOptionData;

abstract final class MultipleChoiceOptionHelper {
  static List<MultipleChoiceOptionData> add(
    List<MultipleChoiceOptionData> options,
  ) {
    return [
      ...options,
      const MultipleChoiceOptionData(text: '', isCorrect: false),
    ];
  }

  static List<MultipleChoiceOptionData> removeAt(
    List<MultipleChoiceOptionData> options,
    int index,
  ) {
    return ListHelper.removeAt(options, index);
  }

  static List<MultipleChoiceOptionData> updateAt(
    List<MultipleChoiceOptionData> options,
    int index,
    MultipleChoiceOptionData option,
  ) {
    return ListHelper.replaceAt(options, index, option);
  }

  static List<MultipleChoiceOptionData> updateTextAt(
    List<MultipleChoiceOptionData> options,
    int index,
    String text,
  ) {
    final current = options[index];
    return updateAt(
      options,
      index,
      MultipleChoiceOptionData(text: text, isCorrect: current.isCorrect),
    );
  }

  static List<MultipleChoiceOptionData> selectCorrectAt(
    List<MultipleChoiceOptionData> options,
    int selectedIndex,
  ) {
    return [
      for (final entry in options.asMap().entries)
        MultipleChoiceOptionData(
          text: entry.value.text,
          isCorrect: entry.key == selectedIndex,
        ),
    ];
  }
}
