import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Low-level, static wrapper around [FlutterLocalNotificationsPlugin].
///
/// Callers should prefer [NotificationsController] for high-level scheduling
/// that reads from [SettingsController]. Use this class directly only for
/// one-off fire-and-forget events (download complete, sync complete).
class NotificationsService {
  NotificationsService._();

  // -------------------------------------------------------------------------
  // Notification IDs
  // -------------------------------------------------------------------------

  static const int reviewReminderId = 1;
  static const int streakReminderId = 2;
  static const int downloadCompleteId = 3;
  static const int syncCompleteId = 4;

  // -------------------------------------------------------------------------
  // Android channel IDs
  // -------------------------------------------------------------------------

  static const String _remindersChannelId = 'reminders';
  static const String _eventsChannelId = 'events';

  // -------------------------------------------------------------------------
  // Plugin instance
  // -------------------------------------------------------------------------

  static final _plugin = FlutterLocalNotificationsPlugin();

  // -------------------------------------------------------------------------
  // Init
  // -------------------------------------------------------------------------

  /// Initialise the plugin, request Android permissions, register channels,
  /// and set the local timezone via [flutter_timezone].
  ///
  /// Safe to call multiple times (idempotent after first call).
  static Future<void> init() async {
    // Initialise the tz database and resolve the device's local location.
    // flutter_timezone isn't supported on Linux, and we don't schedule there
    // anyway, so skip it on that platform.
    tz.initializeTimeZones();
    if (!Platform.isLinux) {
      final tzInfo = await FlutterTimezone.getLocalTimezone();
      // TimezoneInfo exposes the IANA identifier via .identifier
      tz.setLocalLocation(tz.getLocation(tzInfo.identifier));
    }

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const linuxInit = LinuxInitializationSettings(defaultActionName: 'Open');
    const initSettings = InitializationSettings(
      android: androidInit,
      linux: linuxInit,
    );

    await _plugin.initialize(settings: initSettings);

    if (Platform.isAndroid) {
      await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();

      await _createAndroidChannel(
        id: _remindersChannelId,
        name: 'Reminders',
        description: 'Daily study and streak reminders.',
        importance: Importance.defaultImportance,
      );
      await _createAndroidChannel(
        id: _eventsChannelId,
        name: 'Events',
        description: 'Download and sync completion notices.',
        importance: Importance.low,
      );
    }
  }

  static Future<void> _createAndroidChannel({
    required String id,
    required String name,
    required String description,
    required Importance importance,
  }) async {
    final channel = AndroidNotificationChannel(
      id,
      name,
      description: description,
      importance: importance,
    );
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  // -------------------------------------------------------------------------
  // Scheduling
  // -------------------------------------------------------------------------

  /// Schedule [id] to fire daily at [hour]:[minute] local time.
  ///
  /// On Linux this is a no-op — the plugin doesn't support scheduled
  /// notifications on that platform.
  static Future<void> scheduleDailyAt({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    if (Platform.isLinux) return;

    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _remindersChannelId,
          'Reminders',
          channelDescription: 'Daily study and streak reminders.',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        linux: const LinuxNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // -------------------------------------------------------------------------
  // Immediate
  // -------------------------------------------------------------------------

  /// Show a one-shot notification immediately.
  ///
  /// [channelId] defaults to [_eventsChannelId].
  static Future<void> showImmediate({
    required int id,
    required String title,
    required String body,
    String channelId = _eventsChannelId,
  }) async {
    await _plugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelId == _remindersChannelId ? 'Reminders' : 'Events',
          importance: Importance.low,
          priority: Priority.low,
        ),
        linux: const LinuxNotificationDetails(),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Cancellation
  // -------------------------------------------------------------------------

  /// Cancel a single notification by [id].
  static Future<void> cancel(int id) => _plugin.cancel(id: id);

  /// Cancel all pending and delivered notifications.
  static Future<void> cancelAll() => _plugin.cancelAll();
}
