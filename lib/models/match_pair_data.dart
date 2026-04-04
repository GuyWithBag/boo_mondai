import 'package:dart_mappable/dart_mappable.dart';

part 'match_pair_data.mapper.dart';

@MappableClass()
class MatchPairData with MatchPairDataMappable {
  final String term;
  final String match;

  const MatchPairData({required this.term, required this.match});
}
