// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/controllers/deck_editor_types.dart
// PURPOSE: Shared typedefs and default values for the deck editor
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/models/models.barrel.dart';

/// Represents the raw data for a multiple-choice option during editing.
typedef MultipleChoiceOptionData = ({String text, bool isCorrect});

/// Represents the raw data for a matching pair during editing.
typedef MatchPairData = ({String term, String match});

/// A collection of controllers and notifiers that represent the state of the
/// card editor form. This allows us to pass the entire form state between
/// the page and the controller easily.

// ── Default form values ──────────────────────────────────────────

/// Default options provided when creating a new multiple-choice card.
const List<MultipleChoiceOptionData> defaultMultipleChoiceOptions = [
  (text: '', isCorrect: true),
  (text: '', isCorrect: false),
  (text: '', isCorrect: false),
];

/// Default pairs provided when creating a new matching card.
const List<MatchPairData> defaultMatchPairs = [
  (term: '', match: ''),
  (term: '', match: ''),
  (term: '', match: ''),
];

// ── Helpers ──────────────────────────────────────────────────────

/// Splits [rawAnswers] on commas, trims whitespace, and removes empty entries.
/// This is used both for building segments and for UI previews.
List<String> splitFillInTheBlankAnswers(String rawAnswers) {
  return rawAnswers
      .split(',')
      .map((answer) => answer.trim())
      .where((answer) => answer.isNotEmpty)
      .toList();
}
