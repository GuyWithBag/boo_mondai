import 'package:boo_mondai/lib.barrel.dart'
    show
        Controller,
        SettingsController,
        NotificationsService,
        SettingsService,
        LocalDB,
        DateHelper,
        NotificationIntent,
        NotificationIds,
        NotificationRecurrence,
        Notifications;

/// High-level notification manager.
///
/// Reads [SettingsController] to know what to schedule, delegates all
/// plugin calls to [NotificationsService].
///
/// **Provider placement:** above the router, alongside [ChangeTrackerController]
/// and [SettingsController].
///
/// **Wiring [SettingsController]:**
/// When the user toggles a reminder or changes a time, call the relevant
/// `schedule*` method from [SettingsController.set]'s callsite so the new
/// schedule takes effect immediately without waiting for an app restart.
class NotificationsController extends Controller {
  NotificationsController(this._settings);

  final SettingsController _settings;

  // -------------------------------------------------------------------------
  // Init
  // -------------------------------------------------------------------------

  /// Initialise the plugin and re-schedule all active reminders from the
  /// current [SettingsController] state.
  ///
  /// Call once from `main.dart` after [SettingsController.init()] resolves.
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
    final enabled = _settings.get(SettingsService.reviewRemindersEnabled);
    if (!enabled) {
      await NotificationsService.cancel(NotificationIds.reviewReminder);
      return;
    }

    await notify(
      Notifications.reviewReminder(
        recurrence: NotificationRecurrence.daily(
          hour: _settings.get(SettingsService.reviewReminderHour),
          minute: _settings.get(SettingsService.reviewReminderMinute),
        ),
      ),
    );
  }

  /// Schedule (or cancel) the daily streak reminder based on current settings.
  ///
  /// Also checks whether the user has already completed a review session
  /// today — if they have, the reminder is suppressed even if enabled.
  Future<void> scheduleStreakReminder() async {
    final enabled = _settings.get(SettingsService.streakRemindersEnabled);
    if (!enabled) {
      await NotificationsService.cancel(NotificationIds.streakReminder);
      return;
    }

    // Suppress if the user already reviewed today.
    final reviewedToday = await _hasReviewedToday();
    if (reviewedToday) {
      await NotificationsService.cancel(NotificationIds.streakReminder);
      return;
    }

    await notify(
      Notifications.streakReminder(
        recurrence: NotificationRecurrence.daily(
          hour: _settings.get(SettingsService.streakReminderHour),
          minute: _settings.get(SettingsService.streakReminderMinute),
        ),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Event notifications (fire-and-forget)
  // -------------------------------------------------------------------------

  Future<void> notify(NotificationIntent notification) async {
    if (notification.persistInInbox) {
      // TODO: Persist to an in-app inbox once notification storage exists.
    }

    if (!notification.showSystemNotification) return;

    final recurrence = notification.recurrence;
    if (recurrence != null) {
      await NotificationsService.scheduleDaily(notification);
      return;
    }

    await NotificationsService.showImmediate(notification);
  }

  /// Show an immediate notification when a deck download finishes.
  // Future<void> notifyDownloadComplete(String deckTitle) async {
  //   await notify(Notifications.downloadComplete(deckTitle: deckTitle));
  // }

  // /// Show an immediate notification when a raw sync finishes.
  // Future<void> notifyRawSyncComplete() async {
  //   await notify(Notifications.syncComplete());
  // }

  // -------------------------------------------------------------------------
  // Helpers
  // -------------------------------------------------------------------------

  Future<bool> _hasReviewedToday() async {
    final sessions = LocalDB.reviewSession.selectMany(
      where: (s) =>
          s.completedAt != null &&
          DateHelper.isSameLocalDate(s.completedAt!, DateTime.now()),
    );
    return sessions.isNotEmpty;
  }
}
