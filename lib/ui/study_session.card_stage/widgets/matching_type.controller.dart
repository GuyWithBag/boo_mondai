import 'dart:convert';
import 'dart:math';

import 'package:boo_mondai/lib.barrel.dart'
    show
        MatchingTypeTemplate,
        MatchingTypeValue,
        StudyRating,
        StudySessionAnswer,
        StudySessionCardStageController,
        Vector2Hive;
import 'package:signals/signals_flutter.dart';

class MatchingTypeController {
  MatchingTypeController({required this.template, this.cardStageController}) {
    final random = Random();
    final pairs = _matchingRows(template);

    final nextLeftItems = <MatchingTypeItem>[];
    final nextRightItems = <MatchingTypeItem>[];
    for (final pair in pairs) {
      if (random.nextBool()) {
        nextLeftItems.add(MatchingTypeItem(value: pair.right, visualColumn: 0));
        nextRightItems.add(MatchingTypeItem(value: pair.left, visualColumn: 1));
        continue;
      }

      nextLeftItems.add(MatchingTypeItem(value: pair.left, visualColumn: 0));
      nextRightItems.add(MatchingTypeItem(value: pair.right, visualColumn: 1));
    }

    leftItems.value = nextLeftItems..shuffle(random);
    rightItems.value = nextRightItems..shuffle(random);
  }

  final MatchingTypeTemplate template;
  final StudySessionCardStageController? cardStageController;

  final leftItems = listSignal<MatchingTypeItem>(const []);
  final rightItems = listSignal<MatchingTypeItem>(const []);
  final selectedItem = signal<MatchingTypeItem?>(null);
  final matchedItemIds = signal<Set<String>>({});
  final incorrectItemIds = signal<Set<String>>({});
  final incorrectAnswers = signal(0);

  late final Computed<bool> isComplete = computed(
    () =>
        leftItems.value.isNotEmpty &&
        matchedItemIds.value.length ==
            leftItems.value.length + rightItems.value.length,
  );

  bool get isLocked => cardStageController?.isRevealed.value == true;

  bool get hasIncorrectAnswerLimit => template.maxIncorrectAnswers >= 0;

  bool get hasReachedIncorrectAnswerLimit =>
      hasIncorrectAnswerLimit &&
      incorrectAnswers.value >= template.maxIncorrectAnswers;

  void select(MatchingTypeItem item) {
    if (isLocked || isMatched(item)) return;

    final selected = selectedItem.value;
    if (selected?.id == item.id) {
      selectedItem.value = null;
      incorrectItemIds.value = {};
      return;
    }

    if (selected == null || selected.column == item.column) {
      selectedItem.value = item;
      incorrectItemIds.value = {};
      return;
    }

    if (_isMatch(selected, item)) {
      matchedItemIds.value = {...matchedItemIds.value, selected.id, item.id};
      selectedItem.value = null;
      incorrectItemIds.value = {};
      _syncAnswer();
      if (isComplete.value) {
        cardStageController?.canReveal.value = true;
        cardStageController?.reveal();
      }
      return;
    }

    incorrectAnswers.value += 1;
    incorrectItemIds.value = {selected.id, item.id};
    selectedItem.value = null;
    _syncAnswer();

    if (hasReachedIncorrectAnswerLimit) {
      cardStageController?.canReveal.value = true;
      cardStageController?.reveal(pendingRating: StudyRating.incorrect);
    }
  }

  bool isSelected(MatchingTypeItem item) => selectedItem.value?.id == item.id;

  bool isMatched(MatchingTypeItem item) =>
      matchedItemIds.value.contains(item.id);

  bool isIncorrect(MatchingTypeItem item) =>
      incorrectItemIds.value.contains(item.id);

  MatchingTypeItem? matchFor(MatchingTypeItem item) {
    for (final candidate in [...leftItems.value, ...rightItems.value]) {
      if (candidate.id != item.id && _isMatch(item, candidate)) {
        return candidate;
      }
    }
    return null;
  }

  void dispose() {
    isComplete.dispose();
    incorrectAnswers.dispose();
    incorrectItemIds.dispose();
    matchedItemIds.dispose();
    selectedItem.dispose();
    rightItems.dispose();
    leftItems.dispose();
  }

  void _syncAnswer() {
    final matches = <MatchingTypeMatch>[];
    for (final left in leftItems.value) {
      final right = matchFor(left);
      if (right == null) continue;
      final matched =
          matchedItemIds.value.contains(left.id) &&
          matchedItemIds.value.contains(right.id);
      if (!matched) continue;
      matches.add(MatchingTypeMatch(left: left, right: right));
    }

    cardStageController?.answer.value = StudySessionAnswer(
      id: matches
          .map((match) => '${match.left.id}=${match.right.id}')
          .join('|'),
      value: jsonEncode({
        'matches': [
          for (final match in matches)
            {'left': match.left.value.text, 'right': match.right.value.text},
        ],
        'incorrectAnswers': incorrectAnswers.value,
      }),
    );
  }

  bool _isMatch(MatchingTypeItem a, MatchingTypeItem b) {
    return _samePosition(a.value.matchPosition, b.value.position) &&
        _samePosition(b.value.matchPosition, a.value.position);
  }

  static bool _samePosition(Vector2Hive a, Vector2Hive b) {
    return a.x.round() == b.x.round() && a.y.round() == b.y.round();
  }

  static List<MatchingTypeRow> _matchingRows(MatchingTypeTemplate template) {
    final usedIds = <String>{};
    final rows = <MatchingTypeRow>[];

    for (final value in template.values) {
      final valueId = _valueId(value);
      if (usedIds.contains(valueId)) continue;

      final match = _matchingValue(template, value);
      if (match == null) continue;

      usedIds
        ..add(valueId)
        ..add(_valueId(match));

      final left = _columnOf(value) <= _columnOf(match) ? value : match;
      final right = identical(left, value) ? match : value;
      rows.add(MatchingTypeRow(left: left, right: right));
    }

    return rows..sort((a, b) => _rowOf(a.left).compareTo(_rowOf(b.left)));
  }

  static MatchingTypeValue? _matchingValue(
    MatchingTypeTemplate template,
    MatchingTypeValue value,
  ) {
    for (final candidate in template.values) {
      if (_valueId(candidate) == _valueId(value)) continue;
      if (_samePosition(value.matchPosition, candidate.position) &&
          _samePosition(candidate.matchPosition, value.position)) {
        return candidate;
      }
    }
    return null;
  }

  static int _columnOf(MatchingTypeValue value) =>
      value.position.x.round().clamp(0, 1);

  static int _rowOf(MatchingTypeValue value) => value.position.y.round();

  static String _valueId(MatchingTypeValue value) =>
      '${value.position.x}:${value.position.y}:${value.text}';
}

final class MatchingTypeItem {
  MatchingTypeItem({required this.value, required this.visualColumn})
    : id = MatchingTypeController._valueId(value);

  final MatchingTypeValue value;
  final int visualColumn;
  final String id;

  int get column => visualColumn;

  int get row => value.position.y.round();
}

final class MatchingTypeRow {
  const MatchingTypeRow({required this.left, required this.right});

  final MatchingTypeValue left;
  final MatchingTypeValue right;
}

final class MatchingTypeMatch {
  const MatchingTypeMatch({required this.left, required this.right});

  final MatchingTypeItem left;
  final MatchingTypeItem right;
}
