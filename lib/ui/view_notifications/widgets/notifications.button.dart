import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        Button,
        LocalDB,
        NotificationsController,
        showNotificationsModal,
        ThemeController;
import 'package:flutter/material.dart';

class NotificationsButton extends StatelessWidget {
  const NotificationsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = ThemeController.tokens;
    final controller = NotificationsController.instance;

    return StreamBuilder(
      stream: LocalDB.notifications.watch(),
      builder: (context, snapshot) {
        final count = controller.unreadCount;

        return Badge(
          isLabelVisible: count > 0,
          label: Text(count > 9 ? '9+' : '$count'),
          child: Button.icon(
            tokens: tokens,
            icon: Icons.notifications_outlined,
            onPressed: () => showNotificationsModal(context),
          ),
        );
      },
    );
  }
}
