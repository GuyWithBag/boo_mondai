// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/bottom_navbar.dart
// PURPOSE: Custom Bottom Navigation using Surface and custom Buttons
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        ButtonColor,
        ButtonPadding,
        ButtonSize,
        Button,
        ButtonVariant,
        BottomNavBar,
        LocalDB,
        NotificationsController,
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
        children: [
          ...List.generate(pages.length, (index) {
            final page = pages[index];
            final isSelected = index == currentPageIndex;
            final icon = isSelected && page.selectedIcon != null
                ? page.selectedIcon!
                : page.icon!;

            return Expanded(
              child: Button(
                variants: const [
                  ButtonColor.baseline,
                  ButtonSize.iconWithLabel,
                  ButtonPadding.iconWithLabel,
                  ButtonVariant.selectedElevatedText,
                ],
                selected: isSelected,
                axis: Axis.vertical,
                leading: _bottomNavIcon(pageUrl: page.url, icon: icon),
                child: Text(
                  page.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                onPressed: () => context.go(pages[index].url),
              ),
            );
          }),
        ],
      ),
    );
  }
}

Widget _bottomNavIcon({required String pageUrl, required IconData icon}) {
  if (pageUrl != Pages.home.url) return Icon(icon);

  return StreamBuilder(
    stream: LocalDB.notifications.watch(),
    builder: (context, snapshot) {
      final count = NotificationsController.instance.unreadCount;

      return Badge(
        isLabelVisible: count > 0,
        label: Text(count > 99 ? '99+' : '$count'),
        child: Icon(icon),
      );
    },
  );
}
