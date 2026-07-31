// 2. Define DrillSession, extending StudySession

import 'package:boo_mondai/features/study_session/models/study_session.dto.dart';
import 'package:boo_mondai/features/decks/models/deck.dto.dart';
import 'package:boo_mondai/features/profile/models/cached_profile.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'drill.study_session.dto.mapper.dart';

@MappableClass()
class DrillSession extends StudySession with DrillSessionMappable {
  final bool previewed;
  final int totalQuestions;
  final int correctCount;

  const DrillSession({
    // Use 'super' to pass the shared properties up to the base class
    required super.id,
    required super.profileId,
    super.deckId,
    required super.startedAt,
    super.completedAt,
    super.userProfile,
    super.deck,

    // Subclass specific properties
    this.previewed = false,
    required this.totalQuestions,
    this.correctCount = 0,
  });

  double get scorePercent =>
      totalQuestions > 0 ? correctCount / totalQuestions : 0;
}
