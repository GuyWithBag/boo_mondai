import 'dart:math';

import 'package:boo_mondai/features/cards/models/word_scramble.template.dart';
import 'package:boo_mondai/features/study_session/models/study_session.answer.dart';
import 'package:signals/signals_flutter.dart';

class WordScrambleController {
  WordScrambleController({
    required this.template,
    required this.answer,
    required this.canReveal,
    required this.isRevealed,
  }) {
    wordBank.value = _buildWords(template);

    answerEffect = effect(() {
      final nextAnswer = answerText.value;
      final ready = isComplete.value;
      answer.value = nextAnswer.trim().isEmpty
          ? null
          : StudySessionAnswer(value: nextAnswer);
      canReveal.value = ready;
    });
  }

  final WordScrambleTemplate template;
  final Signal<StudySessionAnswer?> answer;
  final Signal<bool> canReveal;
  final Signal<bool> isRevealed;

  final wordBank = listSignal<WordScrambleWord>(const []);
  final selectedWords = listSignal<WordScrambleWord>(const []);

  late final Computed<String> answerText = computed(
    () => selectedWords.value.map((word) => word.text).join(' '),
  );

  late final Computed<bool> isComplete = computed(
    () => wordBank.value.isEmpty && selectedWords.value.isNotEmpty,
  );

  late final EffectCleanup answerEffect;

  bool get isLocked => isRevealed.value;

  void selectWord(WordScrambleWord word) {
    insertWordAt(word, selectedWords.value.length);
  }

  void insertWordAt(WordScrambleWord word, int index) {
    if (isLocked || !wordBank.value.contains(word)) return;
    wordBank.value = [
      for (final item in wordBank.value)
        if (item != word) item,
    ];
    final next = [...selectedWords.value];
    next.insert(index.clamp(0, next.length), word);
    selectedWords.value = next;
  }

  void removeSelectedWordAt(int index) {
    if (isLocked || index < 0 || index >= selectedWords.value.length) return;
    final nextSelected = [...selectedWords.value];
    final word = nextSelected.removeAt(index);
    selectedWords.value = nextSelected;
    wordBank.value = [...wordBank.value, word];
  }

  void moveSelectedWord(int from, int to) {
    if (isLocked ||
        from < 0 ||
        from >= selectedWords.value.length ||
        to < 0 ||
        to > selectedWords.value.length ||
        from == to) {
      return;
    }

    final next = [...selectedWords.value];
    final item = next.removeAt(from);
    final insertionIndex = from < to ? to - 1 : to;
    next.insert(insertionIndex.clamp(0, next.length), item);
    selectedWords.value = next;
  }

  bool isCorrectWordAt(int index) {
    if (index < 0 || index >= selectedWords.value.length) return false;
    return selectedWords.value[index].sourceIndex == index;
  }

  void dispose() {
    answerEffect();
    isComplete.dispose();
    answerText.dispose();
    selectedWords.dispose();
    wordBank.dispose();
  }

  static List<WordScrambleWord> _buildWords(WordScrambleTemplate template) {
    final parts = template.sentenceToScramble
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();

    final words = [
      for (final entry in parts.asMap().entries)
        WordScrambleWord(
          id: '${template.id}:${entry.key}:${entry.value}',
          text: entry.value,
          sourceIndex: entry.key,
        ),
    ];

    return words..shuffle(Random(_stableSeed(template.id)));
  }

  static int _stableSeed(String value) {
    return value.codeUnits.fold<int>(0, (seed, unit) => seed * 31 + unit);
  }
}

final class WordScrambleWord {
  const WordScrambleWord({
    required this.id,
    required this.text,
    required this.sourceIndex,
  });

  final String id;
  final String text;
  final int sourceIndex;
}

sealed class WordScrambleDragPayload {
  const WordScrambleDragPayload();
}

final class WordScrambleBankWordDragPayload extends WordScrambleDragPayload {
  const WordScrambleBankWordDragPayload(this.word);

  final WordScrambleWord word;
}

final class WordScrambleSelectedWordDragPayload
    extends WordScrambleDragPayload {
  const WordScrambleSelectedWordDragPayload(this.index);

  final int index;
}
