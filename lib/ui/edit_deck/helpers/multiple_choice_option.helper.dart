import 'package:boo_mondai/lib.barrel.dart'
    show ListHelper, MultipleChoiceOption, uuid;

abstract final class MultipleChoiceOptionHelper {
  static List<MultipleChoiceOption> add(
    List<MultipleChoiceOption> options, {
    required String templateId,
  }) {
    return [
      ...options,
      MultipleChoiceOption(
        id: uuid.v7(),
        templateId: templateId,
        optionText: '',
        isCorrect: false,
        displayOrder: options.length,
      ),
    ];
  }

  static List<MultipleChoiceOption> removeAt(
    List<MultipleChoiceOption> options,
    int index,
  ) {
    return ListHelper.removeAt(options, index);
  }

  static List<MultipleChoiceOption> updateAt(
    List<MultipleChoiceOption> options,
    int index,
    MultipleChoiceOption option,
  ) {
    return ListHelper.replaceAt(options, index, option);
  }

  static List<MultipleChoiceOption> updateTextAt(
    List<MultipleChoiceOption> options,
    int index,
    String text,
  ) {
    final current = options[index];
    return updateAt(
      options,
      index,
      MultipleChoiceOption(
        id: current.id,
        templateId: current.templateId,
        optionText: text,
        isCorrect: current.isCorrect,
        displayOrder: current.displayOrder,
      ),
    );
  }

  static List<MultipleChoiceOption> selectCorrectAt(
    List<MultipleChoiceOption> options,
    int selectedIndex,
  ) {
    return [
      for (final entry in options.asMap().entries)
        MultipleChoiceOption(
          id: entry.value.id,
          templateId: entry.value.templateId,
          optionText: entry.value.optionText,
          isCorrect: entry.key == selectedIndex,
          displayOrder: entry.value.displayOrder,
        ),
    ];
  }
}
