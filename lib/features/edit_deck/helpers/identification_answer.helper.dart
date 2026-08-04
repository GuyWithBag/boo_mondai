import 'package:boo_mondai/lib.barrel.dart'
    show CasingType, IdentificationAnswerData;

abstract final class IdentificationAnswerHelper {
  static List<IdentificationAnswerData> add(
    List<IdentificationAnswerData> answers,
  ) {
    return [
      ...answers,
      const IdentificationAnswerData(answer: '', casingType: CasingType.any),
    ];
  }

  static List<IdentificationAnswerData> removeAt(
    List<IdentificationAnswerData> answers,
    int index,
  ) {
    if (index < 0 || index >= answers.length) return answers;
    return [...answers.take(index), ...answers.skip(index + 1)];
  }

  static List<IdentificationAnswerData> updateAt(
    List<IdentificationAnswerData> answers,
    int index,
    IdentificationAnswerData answer,
  ) {
    if (index < 0 || index >= answers.length) return answers;
    return [
      for (final entry in answers.asMap().entries)
        if (entry.key == index) answer else entry.value,
    ];
  }

  static List<IdentificationAnswerData> updateAnswerAt(
    List<IdentificationAnswerData> answers,
    int index,
    String answer,
  ) {
    if (index < 0 || index >= answers.length) return answers;
    return updateAt(answers, index, answers[index].copyWith(answer: answer));
  }

  static List<IdentificationAnswerData> updateCasingTypeAt(
    List<IdentificationAnswerData> answers,
    int index,
    CasingType casingType,
  ) {
    if (index < 0 || index >= answers.length) return answers;
    return updateAt(
      answers,
      index,
      answers[index].copyWith(casingType: casingType),
    );
  }

  static List<IdentificationAnswerData> move(
    List<IdentificationAnswerData> answers,
    int from,
    int to,
  ) {
    if (from < 0 || from >= answers.length || to < 0 || to >= answers.length) {
      return answers;
    }

    final updated = [...answers];
    final item = updated.removeAt(from);
    updated.insert(to, item);
    return updated;
  }
}
