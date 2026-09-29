import 'package:boo_mondai/features/cards/models/fill_in_the_blank.answer_key.dto.dart';

final class FillInTheBlanksPromptSegment {
  const FillInTheBlanksPromptSegment.text(this.text) : key = null;
  const FillInTheBlanksPromptSegment.blank(this.key) : text = null;

  final String? text;
  final FillInTheBlankAnswerKey? key;
}

List<FillInTheBlanksPromptSegment> scanFillInTheBlanksPrompt(
  String prompt,
  List<FillInTheBlankAnswerKey> answerKeys,
) {
  final keys = [...answerKeys]
    ..sort((a, b) => b.value.length.compareTo(a.value.length));
  final segments = <FillInTheBlanksPromptSegment>[];
  var textStart = 0;
  var index = 0;

  while (index < prompt.length) {
    FillInTheBlankAnswerKey? match;
    for (final key in keys) {
      if (key.value.isEmpty || !prompt.startsWith(key.value, index)) continue;
      if (!_hasWordBoundaries(prompt, index, key.value.length)) continue;
      match = key;
      break;
    }

    if (match == null) {
      index++;
      continue;
    }

    if (textStart < index) {
      segments.add(
        FillInTheBlanksPromptSegment.text(prompt.substring(textStart, index)),
      );
    }
    segments.add(FillInTheBlanksPromptSegment.blank(match));
    index += match.value.length;
    textStart = index;
  }

  if (textStart < prompt.length) {
    segments.add(
      FillInTheBlanksPromptSegment.text(prompt.substring(textStart)),
    );
  }
  return segments;
}

bool _hasWordBoundaries(String text, int start, int length) {
  final end = start + length;
  final beginsWithWord = _isWordChar(text[start]);
  final endsWithWord = _isWordChar(text[end - 1]);
  final beforeIsWord = start > 0 && _isWordChar(text[start - 1]);
  final afterIsWord = end < text.length && _isWordChar(text[end]);
  return (!beginsWithWord || !beforeIsWord) && (!endsWithWord || !afterIsWord);
}

bool _isWordChar(String value) {
  return RegExp(r'[\p{L}\p{N}]', unicode: true).hasMatch(value);
}
