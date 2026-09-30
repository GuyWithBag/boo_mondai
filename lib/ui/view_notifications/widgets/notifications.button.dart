import 'package:boo_mondai/lib.barrel.dart'
    show AppTokens, Button, NotificationsController, showNotificationsModal;
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:theme_variants/theme_variants.dart';

class NotificationsButton extends StatelessWidget {
  const NotificationsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final controller = NotificationsController.instance;

    return SignalBuilder(
      builder: (context) {
        final count = controller.unreadCount.value;

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
