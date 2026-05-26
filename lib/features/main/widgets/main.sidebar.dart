// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/sidebar.dart (or your specific path)
// PURPOSE: Sidebar navigation using a ListView and custom Buttons
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        Button,
        ButtonTone,
        Pages,
        ButtonDepth,
        AppTokens,
        surfaceStyle,
        SurfaceShape,
        SurfaceBorder;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' show GoRouterHelper;
import 'package:theme_variants/theme_variants.dart';

class Sidebar extends StatelessWidget {
  final int currentPageIndex;

  const Sidebar({super.key, required this.currentPageIndex});

  @override
  Widget build(BuildContext context) {
    final pages = Pages.shell;
    final tokens = context.themeTokens<AppTokens>();
    return SizedBox(
      width: 280,
      child: Container(
        decoration: BoxDecoration(
          border: BorderDirectional(
            end: BorderSide(
              color: tokens.borderNeutralSubtle,
              width: tokens.borderWidthDefault,
            ),
          ),
        ),
        child: Surface(
          style: surfaceStyle.resolve(tokens, const [
            SurfaceShape.sharp,
            SurfaceBorder.none,
          ]),
          child: ListView.separated(
            itemCount: pages.length,
            separatorBuilder: (_, _) =>
                SizedBox(height: tokens.spacePanelGapSm),
            itemBuilder: (context, index) {
              final page = pages[index];
              final isSelected = index == currentPageIndex;

              return Button(
                leading: page.icon,
                tone: ButtonTone.textGhostSelect,
                selected: isSelected,
                depth: ButtonDepth.flat,
                mainAxisAlignment: MainAxisAlignment.start,
                onPressed: () => context.go(pages[index].url),
                child: page.name,
              );
            },
          ),
        ),
      ),
    );
  }
}
