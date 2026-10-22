import 'package:boo_mondai/core/widgets/listing_states_wrapper.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        LocalDB,
        ViewNotificationsTile,
        NotificationsController,
        TextColor,
        TextSize,
        TextWeight,
        showModal,
        textStyle;
import 'package:boo_mondai/ui/view_notifications/view_notifications.debug.dart';
import 'package:flutter/material.dart';
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
    final controller = NotificationsController.instance;

    Widget getBody() {
      final notifications = controller.allNotifications;

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
        child: ListingStatesWrapper.list(
          items: notifications,
          separatorHeight: tokens.spaceLayoutGapSm,
          itemBuilder: (context, index, item) {
            return ViewNotificationsTile(notification: item);
          },
        ),
      );
    }

    return StreamBuilder(
      stream: LocalDB.notifications.watch(),
      builder: (context, snapshot) {
        return Column(children: [ViewNotificationsDebug(), getBody()]);
      },
    );
  }
}
