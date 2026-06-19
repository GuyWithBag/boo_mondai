import 'package:boo_mondai/lib.barrel.dart'
    show DeckCardFormState, MatchPairData, MatchPairHelper;
import 'package:flutter_hooks/flutter_hooks.dart';

class MatchingTypeEditorController {
  const MatchingTypeEditorController({
    required this.formState,
    required this.pairs,
  });

  final DeckCardFormState formState;
  final List<MatchPairData> pairs;

  void addPair() {
    formState.matchPairs.value = MatchPairHelper.add(pairs);
  }

  void removePair(int index) {
    formState.matchPairs.value = MatchPairHelper.removeAt(pairs, index);
  }

  void updatePair(int index, MatchPairData pair) {
    formState.matchPairs.value = MatchPairHelper.updateAt(pairs, index, pair);
  }

  void updatePairTerm(int index, String term) {
    formState.matchPairs.value = MatchPairHelper.updateTermAt(
      pairs,
      index,
      term,
    );
  }

  void updatePairMatch(int index, String match) {
    formState.matchPairs.value = MatchPairHelper.updateMatchAt(
      pairs,
      index,
      match,
    );
  }
}

MatchingTypeEditorController useMatchingTypeEditor(
  DeckCardFormState formState,
) {
  final pairs = useValueListenable(formState.matchPairs);

  return MatchingTypeEditorController(formState: formState, pairs: pairs);
}
