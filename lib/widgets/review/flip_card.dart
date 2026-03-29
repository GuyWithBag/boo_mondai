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
  const FlipCard({super.key, required this.controller, required this.deckCard});

  final AnimationController controller;
  final DeckCard deckCard;

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
                  question: deckCard.question,
                  imageUrl: deckCard.questionImageUrl,
                )
              : Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..rotateY(pi),
                  child: ReviewCardBack(
                    answer: deckCard.answer,
                    imageUrl: deckCard.answerImageUrl,
                  ),
                ),
        );
      },
    );
  }
}
