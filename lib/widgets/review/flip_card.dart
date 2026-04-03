// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/review/flip_card.dart
// PURPOSE: Animated Y-axis flip card showing question front and answer back
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';

class FlipCard extends StatelessWidget {
  const FlipCard({
    super.key,
    required this.controller,
    required this.template, // <-- CHANGED
    this.isReversed = false, // <-- ADDED: Support for flipped review state
  });

  final AnimationController controller;
  final CardTemplate template; // <-- CHANGED
  final bool isReversed;

  // ── Helper Extractors for Abstract Template ──────────────────

  String _getFrontText() {
    return switch (template) {
      FlashcardTemplate f => f.getQuestion(isReversed: isReversed),
      IdentificationTemplate i => i.promptText,
      MultipleChoiceTemplate m => m.questionPrompt,
      FillInTheBlanksTemplate fb =>
        fb.segments.isNotEmpty ? fb.segments.first.fullText : '',
      WordScrambleTemplate ws => ws.sentenceToScramble,
      MatchMadnessTemplate mm =>
        mm.pairs.isNotEmpty ? 'Match: ${mm.pairs.first.term}' : 'Match Pairs',
      _ => '(no question)',
    };
  }

  String _getBackText() {
    return switch (template) {
      FlashcardTemplate f => f.getAnswer(isReversed: isReversed),
      IdentificationTemplate i => i.acceptedAnswers,
      MultipleChoiceTemplate m =>
        m.options.where((o) => o.isCorrect).map((o) => o.optionText).join(', '),
      FillInTheBlanksTemplate _ => '(Fill in the blanks)',
      WordScrambleTemplate _ => '(Word scramble)',
      MatchMadnessTemplate mm => '${mm.pairs.length} pairs',
      _ => '(no answer)',
    };
  }

  String? _getFrontImage() {
    return switch (template) {
      FlashcardTemplate f => isReversed ? f.backImageUrl : f.frontImageUrl,
      IdentificationTemplate i => i.imageUrl,
      MultipleChoiceTemplate m => m.imageUrl,
      WordScrambleTemplate ws => ws.imageUrl,
      _ => null,
    };
  }

  String? _getBackImage() {
    return switch (template) {
      FlashcardTemplate f => isReversed ? f.frontImageUrl : f.backImageUrl,
      // Add other template back images here if you add them to the models later
      _ => null,
    };
  }

  // ─────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final angle = controller.value * pi;
        final isFront = angle < pi / 2;

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle),
          child: isFront
              ? QuizQuestionCard(
                  question: _getFrontText(), // <-- Extracted
                  imageUrl: _getFrontImage(), // <-- Extracted
                )
              : Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..rotateY(pi),
                  child: ReviewCardBack(
                    answer: _getBackText(), // <-- Extracted
                    imageUrl: _getBackImage(), // <-- Extracted
                  ),
                ),
        );
      },
    );
  }
}
