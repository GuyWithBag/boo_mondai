import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        Button,
        LocalDB,
        NotificationsController,
        showNotificationsModal;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class NotificationsButton extends StatelessWidget {
  const NotificationsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
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
