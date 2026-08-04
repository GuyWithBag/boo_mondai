import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        NotificationBlock,
        NotificationsController,
        TextColor,
        TextSize,
        TextWeight,
        showModal,
        textStyle;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:theme_variants/theme_variants.dart';

Future<void> showNotificationsModal(BuildContext context) {
  return showModal<void>(
    context: context,
    leading: const Icon(Icons.notifications_outlined),
    title: 'Notifications',
    child: const NotificationsModalBody(),
    showCancelButton: true,
  );
}

class NotificationsModalBody extends StatelessWidget {
  const NotificationsModalBody({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final notifications = context
        .watch<NotificationsController>()
        .notifications;

    if (notifications.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: tokens.spaceLayoutGapLg),
        child: Text(
          'No notifications yet.',
          textAlign: TextAlign.center,
          style: textStyle.resolve(tokens, const [
            TextSize.label,
            TextWeight.body,
            TextColor.muted,
          ]),
        ),
      );
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 420),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: notifications.length,
        separatorBuilder: (_, _) => SizedBox(height: tokens.spaceLayoutGapSm),
        itemBuilder: (context, index) {
          return NotificationBlock(notification: notifications[index]);
        },
      ),
    );
  }
}
