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
  final activeNotification = signal<NotificationIntent?>(null);

  NotificationBubbleHandle? notificationBubbleHandle;
  int? visibleNotificationId;
  bool isWaitingForOverlay = false;
  StreamSubscription<BoxEvent>? notificationsSubscription;

  void refresh() {
    final unreadNotifications = notificationsController.unreadNotifications;
    final currentVisibleNotification =
        notificationBubbleHandle == null || visibleNotificationId == null
        ? null
        : unreadNotifications
              .where((notification) => notification.id == visibleNotificationId)
              .firstOrNull;
    final nextNotification =
        currentVisibleNotification ??
        unreadNotifications
            .where(
              (notification) =>
                  notification.showAsBubble && !notification.shown,
            )
            .firstOrNull;

    activeNotification.value = nextNotification;

    if (nextNotification == null) {
      removeNotificationBubble();
      return;
    }

    showActiveNotificationBubble();
  }

  void showActiveNotificationBubble() {
    final notification = activeNotification.value;
    if (notification == null || notification.shown) return;
    if (visibleNotificationId == notification.id &&
        notificationBubbleHandle != null) {
      return;
    }

    final overlay = rootNavigatorKey.currentState?.overlay;
    if (overlay == null || !overlay.mounted) {
      deferShowActiveNotificationBubble();
      return;
    }

    removeNotificationBubble();
    notificationBubbleHandle = showNotificationBubble(overlay);
    visibleNotificationId = notification.id;
    unawaited(markShown(notification));
  }

  void deferShowActiveNotificationBubble() {
    if (isWaitingForOverlay) return;
    isWaitingForOverlay = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isWaitingForOverlay = false;
      showActiveNotificationBubble();
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
    visibleNotificationId = null;
    isWaitingForOverlay = false;
  }

  String? routeFor(NotificationIntent notification) {
    return notification.route ??
        (notification.ifRouteNullPushToView
            ? Pages.notificationIntentUrl(notification.id)
            : null);
  }

  Future<void> dismiss() async {
    final notification = activeNotification.value;
    if (notification == null) return;

    await notificationsController.markRead(notification.id);
    refresh();
  }

  Future<void> dispose() async {
    removeNotificationBubble();
    await notificationsSubscription?.cancel();
    activeNotification.dispose();
  }
}
