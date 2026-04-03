// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/fsrs_service.dart
// PURPOSE: Wraps the fsrs dart package for spaced repetition scheduling
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/repositories/repositories.dart';
import 'package:fsrs/fsrs.dart';

class FsrsService {
  final Scheduler scheduler = Scheduler();

  // FsrsCard enrollCard(String userId, String cardId, Rating rating) async {
  //   final card = await Card.create();
  //   final result = scheduleCard(card, rating);
  //   return _cardToState(result.card, userId, cardId);
  // }

  // Reviews card and puts it in the Repository
  void enrollCard({required FsrsCard card, required Rating rating}) {
    final res = scheduler.reviewCard(card.state, rating);
    final newCard = card.copyWith(state: res.card);
    final newLog = FsrsReviewLog.create(log: res.reviewLog, cardId: newCard.id);
    Repositories.fsrsCard.save(newCard);
    Repositories.reviewLog.save(newLog);
  }

  // ({Card card, ReviewLog reviewLog}) reviewCard(Card card, Rating rating) {
  //   final res = scheduler.reviewCard(card, rating);
  //   return (card: res.card, reviewLog: res.reviewLog);
  // }
}
