import 'package:boo_mondai/lib.barrel.dart'
    show AppTokens, Button, NotificationsController, showNotificationsModal;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:theme_variants/theme_variants.dart';

class NotificationButton extends StatelessWidget {
  const NotificationButton({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final count = context.watch<NotificationsController>().unreadCount;

    return Badge(
      isLabelVisible: count > 0,
      label: Text(count > 9 ? '9+' : '$count'),
      child: Button.icon(
        tokens: tokens,
        icon: Icons.notifications_outlined,
        onPressed: () => showNotificationsModal(context),
      ),
    );
  }
}
