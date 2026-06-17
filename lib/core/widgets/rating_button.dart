// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/rating_button.dart
// PURPOSE: Individual button for submitting an FSRS rating
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show StudySessionController, StudyRating, ButtonTone, Button;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RatingButton extends StatelessWidget {
  final StudyRating type;
  final VoidCallback onTap;
  final StudySessionController ctrl;

  const RatingButton(
    this.type, {
    super.key,
    required this.onTap,
    required this.ctrl,
  });

  @override
  Widget build(BuildContext context) {
    final reviewTime = ctrl.nextIntervals[type] ?? '-';

    late final String shortcut;
    late final String label;
    late final ButtonTone tone;

    switch (type) {
      case StudyRating.again:
      case StudyRating.incorrect: // Fallback just in case
        label = 'Again';
        shortcut = '1';
        tone = ButtonTone.again;
      case StudyRating.hard:
        label = 'Hard';
        shortcut = '2';
        tone = ButtonTone.hard;
      case StudyRating.good:
        label = 'Good';
        shortcut = '3';
        tone = ButtonTone.good;
      case StudyRating.easy:
        label = 'Easy';
        shortcut = '4';
        tone = ButtonTone.easy;
    }

    return Expanded(
      child: Tooltip(
        message: 'Press $shortcut',
        child: Button(
          onPressed: onTap,
          variants: [tone],
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label.toUpperCase(), textAlign: TextAlign.center),
              SizedBox(height: 4.h),
              Opacity(
                opacity: 0.7,
                child: Text(reviewTime, textAlign: TextAlign.center),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
