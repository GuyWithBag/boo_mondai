// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/fsrs_service.dart
// PURPOSE: Wraps the fsrs dart package for spaced repetition scheduling
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:fsrs/fsrs.dart';
import 'package:boo_mondai/models/models.barrel.dart';

class FsrsService {
  final FSRS _fsrs = FSRS();

  /// Creates a fresh FSRS Card (state=new).
  Card createNewCard() => Card();

  /// Schedules a card for the given rating and returns the resulting card + log.
  ({Card card, ReviewLog log}) scheduleCard(Card card, Rating rating) {
    final now = DateTime.now();
    final result = _fsrs.repeat(card, now);
    final scheduled = result[rating]!;
    return (card: scheduled.card, log: scheduled.reviewLog);
  }

  /// Converts an FsrsCardState to an fsrs Card, schedules it, and returns updated state.
  FsrsCardState reviewCard(FsrsCardState state, int ratingValue) {
    final card = _stateToCard(state);
    final rating =
        Rating.values[ratingValue - 1]; // 1=again, 2=hard, 3=good, 4=easy
    final result = scheduleCard(card, rating);
    return _cardToState(result.card, state.userId, state.cardId);
  }

  /// Creates an initial FsrsCardState from a new card after first quiz rating.
  FsrsCardState enrollCard(String userId, String cardId, int ratingValue) {
    final card = createNewCard();
    final rating = Rating.values[ratingValue - 1];
    final result = scheduleCard(card, rating);
    return _cardToState(result.card, userId, cardId);
  }

  Card _stateToCard(FsrsCardState state) => Card()
    ..due = state.due
    ..stability = state.stability
    ..difficulty = state.difficulty
    ..elapsedDays = state.elapsedDays
    ..scheduledDays = state.scheduledDays
    ..reps = state.reps
    ..lapses = state.lapses
    ..state = State.values[state.state]
    ..lastReview = state.lastReview ?? DateTime.now().toUtc();

  FsrsCardState _cardToState(Card card, String userId, String cardId) =>
      FsrsCardState(
        id: '${userId}_$cardId',
        userId: userId,
        cardId: cardId,
        due: card.due,
        stability: card.stability,
        difficulty: card.difficulty,
        elapsedDays: card.elapsedDays,
        scheduledDays: card.scheduledDays,
        reps: card.reps,
        lapses: card.lapses,
        state: card.state.index,
        lastReview: card.lastReview,
      );
}
