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
import 'package:signals/signals_flutter.dart';

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
  final notifications = ListSignal<NotificationIntent>(const []);

  late final unreadCount = computed(() => notifications.value.length);

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
    if (notification.persistInInbox) {
      notifications.value = List.unmodifiable([
        notification,
        ...notifications.value,
      ]);
    }

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

  /// Show an immediate notification when a deck download finishes.
  // Future<void> notifyDownloadComplete(String deckTitle) async {
  //   await notify(
  //     Notifications.downloadComplete(deckTitle: deckTitle),
  //     const ImmediateSchedule.now(),
  //   );
  // }

  // /// Show an immediate notification when a raw sync finishes.
  // Future<void> notifyRawSyncComplete() async {
  //   await notify(Notifications.syncComplete(), const ImmediateSchedule.now());
  // }

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
