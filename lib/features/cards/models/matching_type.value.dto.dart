// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/match_madness_pair.dart
// PURPOSE: One term↔match pair for a MATCH_MADNESS template
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/core/models/vector2.hive.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'matching_type.value.dto.mapper.dart';

@MappableClass()
class MatchingTypeValue with MatchingTypeValueMappable {
  final String text;
  final Vector2Hive matchPosition;
  final Vector2Hive position;

  const MatchingTypeValue({
    required this.text,
    required this.matchPosition,
    required this.position,
  });

  factory MatchingTypeValue.createDummy({
    String text = '',
    Vector2Hive? matchPosition,
    Vector2Hive? position,
  }) {
    return MatchingTypeValue(
      text: text,
      matchPosition: matchPosition ?? const Vector2Hive.zero(),
      position: position ?? const Vector2Hive.zero(),
    );
  }
}
