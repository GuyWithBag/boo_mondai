// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/controllers/deck_editor_types.dart
// PURPOSE: Shared typedefs and default values for the deck editor
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/foundation.dart' show ValueNotifier;
import 'package:flutter/widgets.dart' show TextEditingController;
import 'package:boo_mondai/models/models.barrel.dart';

typedef McOpt = ({String text, bool isCorrect});
typedef Pair = ({String term, String match});

/// Grouping of all form-level state for one card being edited.
///
/// Each field maps 1:1 to a `useState` / `useTextEditingController` in the
/// editor page. Collecting them here makes it easier to pass around and
/// reset when the selected card changes.
typedef DeckCardForm = ({
  ValueNotifier<QuestionType> qType,
  ValueNotifier<CardType> cType,
  TextEditingController frontCtrl,
  TextEditingController backCtrl,
  TextEditingController identificationAnsCtrl,
  ValueNotifier<List<McOpt>> mcOpts,
  TextEditingController fitbSentCtrl,
  TextEditingController fitbAnsCtrl,
  ValueNotifier<List<Pair>> matchPairs,
});

// ── Default form values ──────────────────────────────────────────

const List<McOpt> defaultMcOpts = [
  (text: '', isCorrect: true),
  (text: '', isCorrect: false),
  (text: '', isCorrect: false),
];

const List<Pair> defaultMatchPairs = [
  (term: '', match: ''),
  (term: '', match: ''),
  (term: '', match: ''),
];

/// Splits [raw] on commas, trims whitespace, drops empty entries.
/// Used by both the controller (for building segments) and widgets (for preview).
List<String> splitFitbAnswers(String raw) =>
    raw.split(',').map((a) => a.trim()).where((a) => a.isNotEmpty).toList();
