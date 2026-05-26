// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/bottom_navbar.dart
// PURPOSE: Custom Bottom Navigation using Surface and custom Buttons
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show AppTokens, surfaceStyle, ButtonTone, ButtonDepth, Button, Pages;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' show GoRouterHelper;
import 'package:theme_variants/theme_variants.dart';

class BottomNavbar extends StatelessWidget {
  final int currentPageIndex;

  const BottomNavbar({super.key, required this.currentPageIndex});

  @override
  Widget build(BuildContext context) {
    final pages = Pages.shell;
    final tokens = context.themeTokens<AppTokens>();
    return Surface(
      style: surfaceStyle.resolve(tokens),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(pages.length, (index) {
            final page = pages[index];
            final isSelected = index == currentPageIndex;

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Button(
                  leading: page.icon,
                  tone: ButtonTone.filled,
                  depth: ButtonDepth.flat,
                  selected: isSelected,
                  mainAxisAlignment: MainAxisAlignment.center,
                  onPressed: () => context.go(pages[index].url),
                  child: page.name,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
