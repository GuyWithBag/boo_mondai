import 'dart:developer' as developer;

import 'package:boo_mondai/lib.barrel.dart'
    show
        DateHelper,
        LocalDB,
        DailySchedule,
        NotificationIntent,
        NotificationIds,
        NotificationSchedule,
        Notifications,
        NotificationsService,
        SettingPath,
        SettingsStore,
        Time;

/// High-level notification manager.
///
/// Reads [SettingsStore] to know what to schedule, delegates all
/// plugin calls to [NotificationsService].
///
/// **Provider placement:** above the router, alongside [ChangeTrackerController]
/// and [SettingsStore].
///
/// **Wiring [SettingsStore]:**
/// When the user toggles a reminder or changes a time, call the relevant
/// `schedule*` method from [SettingsStore.set]'s callsite so the new
/// schedule takes effect immediately without waiting for an app restart.
class NotificationsController {
  static final instance = NotificationsController();

  final SettingsStore settings = SettingsStore.instance;

  String get profileId => LocalDB.currentProfile.getOrCreate().id;

  List<NotificationIntent> get allNotifications {
    return LocalDB.notifications.selectAllNotifications(profileId);
  }

  List<NotificationIntent> get unreadNotifications {
    return LocalDB.notifications.selectUnreadNotifications(profileId);
  }

  List<NotificationIntent> get readNotifications {
    return LocalDB.notifications.selectReadNotifications(profileId);
  }

  List<NotificationIntent> get deletedNotifications {
    return LocalDB.notifications.selectDeletedNotifications(profileId);
  }

  int get unreadCount => unreadNotifications.length;

  // -------------------------------------------------------------------------
  // Init
  // -------------------------------------------------------------------------

  /// Initialise the plugin and re-schedule all active reminders from the
  /// current [SettingsStore] state.
  ///
  /// Call once from `main.dart` after [SettingsStore.init()] resolves.
  Future<void> init() async {
    await NotificationsService.init();
    await scheduleReviewReminder();
    await scheduleStreakReminder();
  }

  // -------------------------------------------------------------------------
  // Reminders
  // -------------------------------------------------------------------------

  /// Schedule (or cancel) the daily review reminder based on current settings.
  Future<void> scheduleReviewReminder() async {
    final enabled = settings.get<bool>(SettingPath.reviewRemindersEnabled);
    if (!enabled) {
      await NotificationsService.cancel(NotificationIds.reviewReminder);
      return;
    }

    await notify(
      Notifications.reviewReminder(),
      DailySchedule(
        time: Time(
          hour: settings.get<int>(SettingPath.reviewReminderHour),
          minute: settings.get<int>(SettingPath.reviewReminderMinute),
        ),
      ),
    );
  }

  /// Schedule (or cancel) the daily streak reminder based on current settings.
  ///
  /// Also checks whether the user has already completed a review session
  /// today — if they have, the reminder is suppressed even if enabled.
  Future<void> scheduleStreakReminder() async {
    final enabled = settings.get<bool>(SettingPath.streakRemindersEnabled);
    if (!enabled) {
      await NotificationsService.cancel(NotificationIds.streakReminder);
      return;
    }

    // Suppress if the user already reviewed today.
    final reviewedToday = await hasReviewedToday();
    if (reviewedToday) {
      await NotificationsService.cancel(NotificationIds.streakReminder);
      return;
    }

    await notify(
      Notifications.streakReminder(),
      DailySchedule(
        time: Time(
          hour: settings.get<int>(SettingPath.streakReminderHour),
          minute: settings.get<int>(SettingPath.streakReminderMinute),
        ),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Event notifications (fire-and-forget)
  // -------------------------------------------------------------------------

  Future<void> notify(
    NotificationIntent notification,
    NotificationSchedule schedule,
  ) async {
    await LocalDB.notifications.upsert(notification);

    if (!notification.showSystemNotification) return;

    try {
      await NotificationsService.show(notification, schedule);
    } catch (error, stackTrace) {
      developer.log(
        'Failed to show system notification.',
        name: 'NotificationsController',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> markRead(int id) async {
    final notification = LocalDB.notifications.selectByPk({
      'id': id,
    }, includeDeleted: true);
    if (notification == null ||
        notification.deletedAt != null ||
        notification.readAt != null) {
      return;
    }

    final now = DateTime.now();
    await LocalDB.notifications.upsert(
      notification.copyWith(readAt: now, updatedAt: now),
    );
  }

  Future<void> deleteNotification(int id) async {
    final notification = LocalDB.notifications.selectByPk({
      'id': id,
    }, includeDeleted: true);
    if (notification == null || notification.deletedAt != null) return;

    final now = DateTime.now();
    await LocalDB.notifications.upsert(
      notification.copyWith(deletedAt: now, updatedAt: now),
    );
  }

  // -------------------------------------------------------------------------
  // Helpers
  // -------------------------------------------------------------------------

  Future<bool> hasReviewedToday() async {
    final sessions = LocalDB.reviewSession.selectMany(
      where: (s) =>
          s.completedAt != null &&
          DateHelper.isSameLocalDate(s.completedAt!, DateTime.now()),
    );
    return sessions.isNotEmpty;
  }
}
