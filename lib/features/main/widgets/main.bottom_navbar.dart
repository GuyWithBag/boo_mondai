// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/bottom_navbar.dart
// PURPOSE: Custom Bottom Navigation using Surface and custom Buttons
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/features/app_theme/app_theme.barrel.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        surfaceStyle,
        ButtonColor,
        Button,
        buttonStyle,
        ButtonVariant,
        Pages;
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
    return Container(
      decoration: BoxDecoration(
        border: BorderDirectional(
          top: BorderSide(
            color: tokens.colorBorderNeutralSubtle,
            width: tokens.borderWidthDefault,
          ),
        ),
      ),
      child: Surface(
        style: surfaceStyle.resolve(tokens, const [
          SurfaceShape.sharp,
          SurfaceBorder.none,
          SurfacePadding.none,
        ]),
        child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(pages.length, (index) {
              final page = pages[index];
              final isSelected = index == currentPageIndex;

              return Expanded(
                child: Button.iconWithLabel(
                  color: ButtonColor.baseline,
                  variant: ButtonVariant.text,
                  tokens: tokens,
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
        ),
      ),
    );
  }
}
