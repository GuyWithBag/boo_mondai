import 'package:boo_mondai/lib.barrel.dart'
    show
        Controller,
        SettingsController,
        NotificationsService,
        AppSetting,
        LocalDB;

/// High-level notification manager.
///
/// Reads [SettingsController] to know what to schedule, delegates all
/// plugin calls to [NotificationsService].
///
/// **Provider placement:** above the router, alongside [ChangeReviewController]
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
    final enabled = _settings.get(AppSetting.reviewRemindersEnabled);
    if (!enabled) {
      await NotificationsService.cancel(NotificationsService.reviewReminderId);
      return;
    }
    await NotificationsService.scheduleDailyAt(
      id: NotificationsService.reviewReminderId,
      title: 'Time to review 🗂️',
      body: 'Your cards are waiting. Keep your streak going!',
      hour: _settings.get(AppSetting.reviewReminderHour),
      minute: _settings.get(AppSetting.reviewReminderMinute),
    );
  }

  /// Schedule (or cancel) the daily streak reminder based on current settings.
  ///
  /// Also checks whether the user has already completed a review session
  /// today — if they have, the reminder is suppressed even if enabled.
  Future<void> scheduleStreakReminder() async {
    final enabled = _settings.get(AppSetting.streakRemindersEnabled);
    if (!enabled) {
      await NotificationsService.cancel(NotificationsService.streakReminderId);
      return;
    }

    // Suppress if the user already reviewed today.
    final reviewedToday = await _hasReviewedToday();
    if (reviewedToday) {
      await NotificationsService.cancel(NotificationsService.streakReminderId);
      return;
    }

    await NotificationsService.scheduleDailyAt(
      id: NotificationsService.streakReminderId,
      title: "Don't break your streak 🔥",
      body: 'A quick review is all it takes to keep it alive.',
      hour: _settings.get(AppSetting.streakReminderHour),
      minute: _settings.get(AppSetting.streakReminderMinute),
    );
  }

  // -------------------------------------------------------------------------
  // Event notifications (fire-and-forget)
  // -------------------------------------------------------------------------

  /// Show an immediate notification when a deck download finishes.
  Future<void> notifyDownloadComplete(String deckTitle) async {
    await NotificationsService.showImmediate(
      id: NotificationsService.downloadCompleteId,
      title: 'Download complete',
      body: deckTitle,
    );
  }

  /// Show an immediate notification when a raw sync finishes.
  Future<void> notifyRawSyncComplete() async {
    await NotificationsService.showImmediate(
      id: NotificationsService.syncCompleteId,
      title: 'Sync complete',
      body: 'Your decks are up to date.',
    );
  }

  // -------------------------------------------------------------------------
  // Helpers
  // -------------------------------------------------------------------------

  Future<bool> _hasReviewedToday() async {
    final sessions = await LocalDB.reviewSession.selectMany(
      where: (s) => s.completedAt != null && _isToday(s.completedAt!),
    );
    return sessions.isNotEmpty;
  }

  bool _isToday(DateTime dt) {
    final now = DateTime.now();
    return dt.year == now.year && dt.month == now.month && dt.day == now.day;
  }
}
