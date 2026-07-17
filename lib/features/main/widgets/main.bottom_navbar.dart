// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/bottom_navbar.dart
// PURPOSE: Custom Bottom Navigation using Surface and custom Buttons
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        ButtonColor,
        Button,
        ButtonVariant,
        BottomNavBar,
        Pages,
        SurfaceShape,
        SurfacePadding;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' show GoRouterHelper;
import 'package:theme_variants/theme_variants.dart';

class MainBottomNavBar extends StatelessWidget implements PreferredSizeWidget {
  final int currentPageIndex;

  const MainBottomNavBar({super.key, required this.currentPageIndex});

  @override
  Size get preferredSize => Size(0, BottomNavBar.preferredHeightDefault);

  @override
  Widget build(BuildContext context) {
    final pages = Pages.shell;
    final tokens = context.themeTokens<AppTokens>();

    return BottomNavBar(
      variants: [SurfaceShape.sharp, SurfacePadding.sm],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        spacing: tokens.spaceLayoutGapSm,
        children: List.generate(pages.length, (index) {
          final page = pages[index];
          final isSelected = index == currentPageIndex;

          return Expanded(
            child: Button.iconWithLabel(
              color: ButtonColor.baseline,
              variant: ButtonVariant.selectedElevatedText,
              selected: isSelected,
              icon: isSelected && page.selectedIcon != null
                  ? page.selectedIcon!
                  : page.icon!,

              label: page.name,
              onPressed: () => context.go(pages[index].url),
            ),
          );
        }),
      ),
    );
  }
}
