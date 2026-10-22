import 'dart:async';

import 'package:boo_mondai/lib.barrel.dart'
    show LocalDB, NotificationIntent, NotificationsController, Pages;
import 'package:boo_mondai/routes.dart' show rootNavigatorKey;
import 'package:boo_mondai/ui/notification.bubble/show_notification.bubble.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_ce/hive.dart' show BoxEvent;
import 'package:signals/signals_flutter.dart';

class NotificationBubbleController {
  NotificationBubbleController({
    NotificationsController? notificationsController,
  }) : notificationsController =
           notificationsController ?? NotificationsController.instance {
    refresh();
    notificationsSubscription = LocalDB.notifications.watch().listen(
      (BoxEvent event) => refresh(),
    );
  }

  static final instance = NotificationBubbleController();

  final NotificationsController notificationsController;
  final activeNotifications = listSignal<NotificationIntent>(const []);

  NotificationBubbleHandle? notificationBubbleHandle;
  bool isWaitingForOverlay = false;
  StreamSubscription<BoxEvent>? notificationsSubscription;

  void refresh() {
    final activeNotificationIds = activeNotifications.value
        .map((notification) => notification.id)
        .toSet();
    final nextNotifications = notificationsController.unreadNotifications
        .where(
          (notification) =>
              notification.showAsBubble &&
              (!notification.shown ||
                  activeNotificationIds.contains(notification.id)),
        )
        .toList();

    activeNotifications.value = nextNotifications;

    if (nextNotifications.isEmpty) {
      removeNotificationBubble();
      return;
    }

    showActiveNotificationBubbles();
  }

  void showActiveNotificationBubbles() {
    final notifications = activeNotifications.value;
    if (notifications.isEmpty) return;
    if (notificationBubbleHandle != null) return;

    final overlay = rootNavigatorKey.currentState?.overlay;
    if (overlay == null || !overlay.mounted) {
      deferShowActiveNotificationBubbles();
      return;
    }

    notificationBubbleHandle = showNotificationBubble(overlay);
    for (final notification in notifications) {
      unawaited(markShown(notification));
    }
  }

  void deferShowActiveNotificationBubbles() {
    if (isWaitingForOverlay) return;
    isWaitingForOverlay = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isWaitingForOverlay = false;
      showActiveNotificationBubbles();
    });
  }

  Future<void> markShown(NotificationIntent notification) async {
    if (notification.shown) return;

    await LocalDB.notifications.upsert(
      notification.copyWith(shown: true, updatedAt: DateTime.now()),
    );
  }

  void removeNotificationBubble() {
    notificationBubbleHandle?.remove();
    notificationBubbleHandle = null;
    isWaitingForOverlay = false;
  }

  String? routeFor(NotificationIntent notification) {
    return notification.route ??
        (notification.ifRouteNullPushToView
            ? Pages.notificationIntentUrl(notification.id)
            : null);
  }

  Future<void> dismiss(NotificationIntent notification) async {
    await notificationsController.markRead(notification.id);
    refresh();
  }

  Future<void> dispose() async {
    removeNotificationBubble();
    await notificationsSubscription?.cancel();
    activeNotifications.dispose();
  }
}
