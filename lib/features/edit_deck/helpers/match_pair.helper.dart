import 'package:boo_mondai/lib.barrel.dart' show ListHelper, MatchPairData;

abstract final class MatchPairHelper {
  static List<MatchPairData> add(List<MatchPairData> pairs) {
    return [...pairs, const MatchPairData(term: '', match: '')];
  }

  static List<MatchPairData> removeAt(List<MatchPairData> pairs, int index) {
    return ListHelper.removeAt(pairs, index);
  }

  static List<MatchPairData> updateAt(
    List<MatchPairData> pairs,
    int index,
    MatchPairData pair,
  ) {
    return ListHelper.replaceAt(pairs, index, pair);
  }

  static List<MatchPairData> updateTermAt(
    List<MatchPairData> pairs,
    int index,
    String term,
  ) {
    final current = pairs[index];
    return updateAt(
      pairs,
      index,
      MatchPairData(term: term, match: current.match),
    );
  }

  static List<MatchPairData> updateMatchAt(
    List<MatchPairData> pairs,
    int index,
    String match,
  ) {
    final current = pairs[index];
    return updateAt(
      pairs,
      index,
      MatchPairData(term: current.term, match: match),
    );
  }
}
