import 'package:boo_mondai/lib.barrel.dart' show AppTokens, ThemeController;
import 'package:flutter/material.dart';
import 'package:signals_hooks/signals_hooks.dart';

class PageDots extends SignalWidget {
  const PageDots({super.key, required this.index, required this.count});

  final int index;
  final int count;

  @override
  Widget build(BuildContext context) {
    final tokens = ThemeController.tokens;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: tokens.spaceLayoutGapSm,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: i == index ? 20 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: i == index
                  ? tokens.colorPrimary
                  : tokens.colorTextMuted.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(99),
            ),
          ),
      ],
    );
  }
}
