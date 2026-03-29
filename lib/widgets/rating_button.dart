// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/rating_button.dart
// PURPOSE: Single FSRS rating button (Again/Hard/Good/Easy) with tooltip shortcut hint
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';

class RatingButton extends StatelessWidget {
  final String label;
  final Color color;
  final String shortcut;
  final VoidCallback onTap;

  const RatingButton({
    super.key,
    required this.label,
    required this.color,
    required this.shortcut,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Tooltip(
        message: 'Press $shortcut',
        child: FilledButton(
          onPressed: onTap,
          style: FilledButton.styleFrom(
            backgroundColor: color.withValues(alpha: 0.15),
            foregroundColor: color,
          ),
          child: Text(label),
        ),
      ),
    );
  }
}
