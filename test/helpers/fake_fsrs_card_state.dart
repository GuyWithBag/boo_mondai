// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: test/helpers/fake_fsrs_card_state.dart
// PURPOSE: Provides fake FsrsCardState instances for unit and widget tests
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/models/fsrs_card_state.dart';

FsrsCardState fakeFsrsCardState({String? cardId, DateTime? due}) =>
    FsrsCardState(
      id: '00000000-0000-0000-0000-000000000002_${cardId ?? '00000000-0000-0000-0000-000000000020'}',
      userId: '00000000-0000-0000-0000-000000000002',
      cardId: cardId ?? '00000000-0000-0000-0000-000000000020',
      due: due ?? DateTime.now(),
      stability: 1.0,
      difficulty: 5.0,
      elapsedDays: 0,
      scheduledDays: 1,
      reps: 1,
      lapses: 0,
      state: 1,
      lastReview: DateTime.now(),
    );
