import 'dart:math' as math;

import 'package:flutter/material.dart';

class AnimatedFlip extends StatelessWidget {
  const AnimatedFlip({
    required this.showBack,
    required this.front,
    required this.back,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeInOutCubic,
    this.perspective = 0.001,
    super.key,
  });

  final bool showBack;
  final Widget front;
  final Widget back;
  final Duration duration;
  final Curve curve;
  final double perspective;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(end: showBack ? math.pi : 0),
      duration: duration,
      curve: curve,
      builder: (context, angle, _) {
        final showingBack = angle >= math.pi / 2;

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, perspective)
            ..rotateY(angle),
          child: showingBack
              ? Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..rotateY(math.pi),
                  child: back,
                )
              : front,
        );
      },
    );
  }
}
