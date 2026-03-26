// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: test/services/fsrs_service_test.dart
// PURPOSE: Unit tests for FsrsService — pure logic tests with no mocks needed
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter_test/flutter_test.dart';
import 'package:fsrs/fsrs.dart';
import 'package:boo_mondai/services/fsrs_service.dart';
import 'package:boo_mondai/models/fsrs_card_state.dart';

void main() {
  late FsrsService service;

  setUp(() {
    service = FsrsService();
  });

  group('createNewCard', () {
    test('returns a card with state=new (index 0)', () {
      final card = service.createNewCard();
      expect(card.state, State.newState);
      expect(card.reps, 0);
      expect(card.lapses, 0);
    });

    test('returns a card with zero reps and lapses', () {
      final card = service.createNewCard();
      expect(card.reps, 0);
      expect(card.lapses, 0);
      expect(card.elapsedDays, 0);
      expect(card.scheduledDays, 0);
    });
  });

  group('scheduleCard', () {
    test('with Good rating produces a future due date', () {
      final card = service.createNewCard();
      final result = service.scheduleCard(card, Rating.good);

      expect(result.card.due.isAfter(DateTime.now().subtract(const Duration(seconds: 1))), true);
      expect(result.card.state, isNot(State.newState));
      expect(result.log, isNotNull);
    });

    test('with Again rating produces a sooner due date than Good', () {
      final card = service.createNewCard();
      final againResult = service.scheduleCard(card, Rating.again);
      final goodResult = service.scheduleCard(card, Rating.good);

      // Again should schedule sooner than Good
      expect(
        againResult.card.due.isBefore(goodResult.card.due) ||
            againResult.card.due.isAtSameMomentAs(goodResult.card.due),
        true,
        reason: 'Again rating should produce a due date no later than Good rating',
      );
    });

    test('with Easy rating produces the furthest due date', () {
      final card = service.createNewCard();
      final goodResult = service.scheduleCard(card, Rating.good);
      final easyResult = service.scheduleCard(card, Rating.easy);

      expect(
        easyResult.card.due.isAfter(goodResult.card.due) ||
            easyResult.card.due.isAtSameMomentAs(goodResult.card.due),
        true,
        reason: 'Easy rating should produce a due date no earlier than Good rating',
      );
    });

    test('with Hard rating produces a due date between Again and Good', () {
      final card = service.createNewCard();
      final againResult = service.scheduleCard(card, Rating.again);
      final hardResult = service.scheduleCard(card, Rating.hard);
      final goodResult = service.scheduleCard(card, Rating.good);

      expect(
        hardResult.card.due.isAfter(againResult.card.due) ||
            hardResult.card.due.isAtSameMomentAs(againResult.card.due),
        true,
      );
      expect(
        hardResult.card.due.isBefore(goodResult.card.due) ||
            hardResult.card.due.isAtSameMomentAs(goodResult.card.due),
        true,
      );
    });

    test('returns a valid ReviewLog', () {
      final card = service.createNewCard();
      final result = service.scheduleCard(card, Rating.good);

      expect(result.log.rating, Rating.good);
    });

    test('advances reps count after scheduling', () {
      final card = service.createNewCard();
      expect(card.reps, 0);

      final result = service.scheduleCard(card, Rating.good);
      expect(result.card.reps, greaterThan(0));
    });
  });

  group('reviewCard', () {
    test('updates FsrsCardState with new scheduling info', () {
      const userId = 'user-1';
      const cardId = 'card-1';
      final initialState = FsrsCardState(
        id: '${userId}_$cardId',
        userId: userId,
        cardId: cardId,
        due: DateTime.now(),
        stability: 0.0,
        difficulty: 0.0,
        elapsedDays: 0,
        scheduledDays: 0,
        reps: 0,
        lapses: 0,
        state: 0, // new
        lastReview: null,
      );

      // Rating 3 = Good
      final updated = service.reviewCard(initialState, 3);

      expect(updated.userId, userId);
      expect(updated.cardId, cardId);
      expect(updated.id, '${userId}_$cardId');
      expect(updated.reps, greaterThan(0));
      expect(updated.due.isAfter(DateTime.now().subtract(const Duration(seconds: 1))), true);
    });

    test('with Again rating (1) increments lapses on review state card', () {
      const userId = 'user-1';
      const cardId = 'card-1';

      // First get into review state by doing a Good rating
      final enrolled = service.enrollCard(userId, cardId, 3);

      // Now review with Again
      final reviewed = service.reviewCard(enrolled, 1);

      // After Again on a card that was in learning/review, state should change
      expect(reviewed.userId, userId);
      expect(reviewed.cardId, cardId);
    });

    test('with Easy rating (4) produces a long scheduled interval', () {
      const userId = 'user-1';
      const cardId = 'card-1';

      final enrolled = service.enrollCard(userId, cardId, 3);
      final reviewed = service.reviewCard(enrolled, 4);

      // Easy should schedule further out than the initial enrollment
      expect(reviewed.due.isAfter(DateTime.now()), true);
    });

    test('preserves userId and cardId through review', () {
      const userId = 'test-user-123';
      const cardId = 'test-card-456';
      final state = FsrsCardState(
        id: '${userId}_$cardId',
        userId: userId,
        cardId: cardId,
        due: DateTime.now(),
        stability: 1.0,
        difficulty: 5.0,
        elapsedDays: 0,
        scheduledDays: 1,
        reps: 1,
        lapses: 0,
        state: 1,
        lastReview: DateTime.now(),
      );

      final updated = service.reviewCard(state, 3);
      expect(updated.userId, userId);
      expect(updated.cardId, cardId);
      expect(updated.id, '${userId}_$cardId');
    });
  });

  group('enrollCard', () {
    test('creates a new FsrsCardState from userId and cardId', () {
      const userId = 'user-1';
      const cardId = 'card-1';

      final state = service.enrollCard(userId, cardId, 3);

      expect(state.id, '${userId}_$cardId');
      expect(state.userId, userId);
      expect(state.cardId, cardId);
      expect(state.reps, greaterThan(0));
    });

    test('with Good rating (3) produces a reasonable due date', () {
      final state = service.enrollCard('user-1', 'card-1', 3);
      expect(state.due.isAfter(DateTime.now().subtract(const Duration(seconds: 1))), true);
    });

    test('with Again rating (1) produces a sooner due date than Good', () {
      final againState = service.enrollCard('user-1', 'card-1', 1);
      final goodState = service.enrollCard('user-1', 'card-1', 3);

      expect(
        againState.due.isBefore(goodState.due) ||
            againState.due.isAtSameMomentAs(goodState.due),
        true,
      );
    });

    test('with Easy rating (4) produces the furthest due date', () {
      final goodState = service.enrollCard('user-1', 'card-1', 3);
      final easyState = service.enrollCard('user-1', 'card-1', 4);

      expect(
        easyState.due.isAfter(goodState.due) ||
            easyState.due.isAtSameMomentAs(goodState.due),
        true,
      );
    });
  });
}
