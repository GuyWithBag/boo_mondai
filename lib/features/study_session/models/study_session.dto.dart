// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/study_session.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/features/decks/models/deck.dto.dart';
import 'package:boo_mondai/features/profile/models/cached_profile.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'study_session.dto.mapper.dart';

// 1. Define the abstract base class and tell dart_mappable what key to use
@MappableClass(discriminatorKey: 'session_type')
abstract class StudySession with StudySessionMappable {
  final String id;
  final String userId;
  final String? deckId;
  final DateTime startedAt;
  final DateTime? completedAt;
  final CachedProfile? userProfile;
  final Deck? deck;

  const StudySession({
    required this.id,
    required this.userId,
    this.deckId,
    required this.startedAt,
    this.completedAt,
    this.userProfile,
    this.deck,
  });

  bool get isComplete => completedAt != null;
}
