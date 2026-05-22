import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

import 'package:boo_mondai/shared/theme/theme.barrel.dart';
import '../../variant_styles/variant_styles.barrel.dart';
import '../tactile_button.dart';

class StudySessionActionBar extends StatelessWidget {
  const StudySessionActionBar({
    required this.revealed,
    required this.showCheckAnswer,
    required this.checkAnswerEnabled,
    required this.onCheckAnswer,
    required this.onRateAgain,
    required this.onRateHard,
    required this.onRateGood,
    required this.onRateEasy,
    super.key,
  });

  final bool revealed;
  final bool showCheckAnswer;
  final bool checkAnswerEnabled;
  final VoidCallback onCheckAnswer;
  final VoidCallback onRateAgain;
  final VoidCallback onRateHard;
  final VoidCallback onRateGood;
  final VoidCallback onRateEasy;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 28.h),
      decoration: BoxDecoration(
        color: tokens.backgroundSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40.r)),
        border: Border(
          top: BorderSide(
            color: tokens.borderNeutralSubtle,
            width: tokens.borderWidthDefault,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            offset: const Offset(0, -10),
            blurRadius: 40,
          ),
        ],
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 480.w),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeOut,
            transitionBuilder: (child, animation) {
              final offsetAnimation = Tween<Offset>(
                begin: Offset(0, 5.h / 80),
                end: Offset.zero,
              ).animate(animation);

              return FadeTransition(
                opacity: animation,
                child: SlideTransition(position: offsetAnimation, child: child),
              );
            },
            child: revealed
                ? _RatingActions(
                    onRateAgain: onRateAgain,
                    onRateHard: onRateHard,
                    onRateGood: onRateGood,
                    onRateEasy: onRateEasy,
                  )
                : showCheckAnswer
                ? SizedBox(
                    width: double.infinity,
                    child: TactileButton(
                      key: const ValueKey('check-answer'),
                      tone: TactileTone.filled,
                      size: TactileSize.lg,
                      onPressed: checkAnswerEnabled ? onCheckAnswer : null,
                      child: const Text('Check Answer'),
                    ),
                  )
                : const SizedBox(key: ValueKey('empty-actions'), height: 54),
          ),
        ),
      ),
    );
  }
}

class _RatingActions extends StatelessWidget {
  const _RatingActions({
    required this.onRateAgain,
    required this.onRateHard,
    required this.onRateGood,
    required this.onRateEasy,
  });

  final VoidCallback onRateAgain;
  final VoidCallback onRateHard;
  final VoidCallback onRateGood;
  final VoidCallback onRateEasy;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return Column(
      key: const ValueKey('rating-actions'),
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'How well did you know this?'.toUpperCase(),
          textAlign: TextAlign.center,
          style: appTextStyle.resolve(tokens, [
            TextSize.labelSmall,
            TextWeight.heavy,
            TextTone.muted,
          ]),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: _RatingButton(
                label: 'Again',
                time: '1m',
                tone: TactileTone.again,
                onPressed: onRateAgain,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _RatingButton(
                label: 'Hard',
                time: '6m',
                tone: TactileTone.hard,
                onPressed: onRateHard,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _RatingButton(
                label: 'Good',
                time: '10m',
                tone: TactileTone.good,
                onPressed: onRateGood,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _RatingButton(
                label: 'Easy',
                time: '4d',
                tone: TactileTone.easy,
                onPressed: onRateEasy,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _RatingButton extends StatelessWidget {
  const _RatingButton({
    required this.label,
    required this.time,
    required this.tone,
    required this.onPressed,
  });

  final String label;
  final String time;
  final TactileTone tone;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TactileButton(
      tone: tone,
      size: TactileSize.sm,
      onPressed: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label.toUpperCase(), textAlign: TextAlign.center),
          SizedBox(height: 4.h),
          Opacity(opacity: 0.7, child: Text(time, textAlign: TextAlign.center)),
        ],
      ),
    );
  }
}
