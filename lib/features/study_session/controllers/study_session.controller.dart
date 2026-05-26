// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/shared/interfaces/session_controller.dart
// PURPOSE: Abstract base class centralizing shared Drill and FSRS logic
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show CardTemplate, Controller, StudyRating, StudyCard, SessionException;
import 'package:flutter/material.dart';

abstract class StudySessionController<TCard, VSession> extends Controller {
  // ── Shared State (Protected for subclasses) ──
  int currentIndex = 0;
  Map<String, CardTemplate> templates = {};
  Map<StudyRating, String> nextIntervals = {};

  // ── THE NEW TOGGLE ──
  bool realTimeSaving = false;

  List<TCard> queue = [];
  VSession? session;

  // ── Abstract Contract (Subclasses MUST implement) ──
  bool get isComplete;
  StudyCard? get currentStudyCard;

  Future<void> submitAnswer(String userAnswer, StudyRating type);
  @protected
  Future<void> completeSession(); // <-- Pulled up to the base class
  void reset();

  CardTemplate? get currentTemplate =>
      currentStudyCard != null ? templates[currentStudyCard!.templateId] : null;

  Never failSession(String message, {required String code}) {
    final exception = SessionException(message, code: code);
    setError(exception);
    throw exception;
  }

  Future<void> calculateNextIntervals();

  double getProgressPercentage() {
    final length = queue.length;
    if (length == 0) return 0;
    return (currentIndex / queue.length).clamp(0.0, 1.0);
  }
}
