// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/controllers/deck_editor_types.dart
// PURPOSE: Shared typedefs and default values for the deck editor
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show MultipleChoiceOptionData, MatchPairData;

/// A collection of controllers and notifiers that represent the state of the
/// card editor form. This allows us to pass the entire form state between
/// the page and the controller easily.

// ── Default form values ──────────────────────────────────────────

/// Default options provided when creating a new multiple-choice card.
const List<MultipleChoiceOptionData> defaultMultipleChoiceOptions = [
  MultipleChoiceOptionData(text: '', isCorrect: true),
  MultipleChoiceOptionData(text: '', isCorrect: false),
  MultipleChoiceOptionData(text: '', isCorrect: false),
];

/// Default pairs provided when creating a new matching card.
const List<MatchPairData> defaultMatchPairs = [
  MatchPairData(term: '', match: ''),
  MatchPairData(term: '', match: ''),
  MatchPairData(term: '', match: ''),
];
