import 'dart:io';

import 'models/notification.intent.dart';
import 'models/notification.schedule.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Low-level, static wrapper around [FlutterLocalNotificationsPlugin].
///
/// Callers should prefer [NotificationsController] for high-level scheduling
/// that reads from [SettingsStore]. Use this class directly only for
/// one-off fire-and-forget events (download complete, sync complete).
class NotificationsService {
  NotificationsService._();

  // -------------------------------------------------------------------------
  // Android channel IDs
  // -------------------------------------------------------------------------

  static const String _remindersChannelId = 'reminders';
  static const String _eventsChannelId = 'events';

  // -------------------------------------------------------------------------
  // Plugin instance
  // -------------------------------------------------------------------------

  static final _plugin = FlutterLocalNotificationsPlugin();
  static ValueChanged<String>? _routeHandler;
  static String? _pendingRoute;

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

    await _plugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: _handleNotificationResponse,
    );

    final launchDetails = await _plugin.getNotificationAppLaunchDetails();
    final launchResponse = launchDetails?.notificationResponse;
    if (launchDetails?.didNotificationLaunchApp ?? false) {
      _handleNotificationPayload(launchResponse?.payload);
    }

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

  static void setRouteHandler(ValueChanged<String> handler) {
    _routeHandler = handler;
    final route = _pendingRoute;
    if (route == null) return;

    _pendingRoute = null;
    WidgetsBinding.instance.addPostFrameCallback((_) => handler(route));
  }

  static void clearRouteHandler() {
    _routeHandler = null;
  }

  static void _handleNotificationResponse(NotificationResponse response) {
    _handleNotificationPayload(response.payload);
  }

  static void _handleNotificationPayload(String? payload) {
    final route = payload?.trim();
    if (route == null || route.isEmpty) return;

    final handler = _routeHandler;
    if (handler == null) {
      _pendingRoute = route;
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => handler(route));
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
  // Delivery
  // -------------------------------------------------------------------------

  /// Show a notification according to [schedule].
  static Future<void> show(
    NotificationIntent notification,
    NotificationSchedule schedule,
  ) async {
    switch (schedule) {
      case ImmediateSchedule(dateTime: null):
        await _showNow(notification);
      case ImmediateSchedule(:final dateTime):
        await _scheduleSingle(
          notification: notification,
          scheduledDate: _dateTimeToLocalTz(dateTime!),
        );
      case DailySchedule():
      case WeeklySchedule():
      case MonthlySchedule():
      case YearlySchedule():
        await _scheduleRecurring(notification, schedule);
    }
  }

  /// On Linux this is a no-op — the plugin doesn't support scheduled
  /// notifications on that platform.
  static Future<void> _scheduleRecurring(
    NotificationIntent notification,
    NotificationSchedule schedule,
  ) async {
    if (Platform.isLinux) return;

    await cancel(notification.id);

    switch (schedule) {
      case DailySchedule(:final time):
        await _scheduleRecurringSlot(
          notification: notification,
          slotIndex: 0,
          scheduledDate: _nextDailyDate(time),
          matchDateTimeComponents: DateTimeComponents.time,
        );
      case WeeklySchedule(:final days):
        for (final indexedDay in days.indexed) {
          await _scheduleRecurringSlot(
            notification: notification,
            slotIndex: indexedDay.$1,
            scheduledDate: _nextWeeklyDate(indexedDay.$2),
            matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
          );
        }
      case MonthlySchedule(:final days):
        for (final indexedDay in days.indexed) {
          await _scheduleRecurringSlot(
            notification: notification,
            slotIndex: indexedDay.$1,
            scheduledDate: _nextMonthlyDate(indexedDay.$2),
            matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
          );
        }
      case YearlySchedule(:final dates):
        for (final indexedDate in dates.indexed) {
          await _scheduleRecurringSlot(
            notification: notification,
            slotIndex: indexedDate.$1,
            scheduledDate: _nextYearlyDate(indexedDate.$2),
            matchDateTimeComponents: DateTimeComponents.dateAndTime,
          );
        }
      case ImmediateSchedule():
        throw ArgumentError.value(
          schedule,
          'schedule',
          'Immediate schedules are not recurring.',
        );
    }
  }

  static Future<void> _scheduleSingle({
    required NotificationIntent notification,
    required tz.TZDateTime scheduledDate,
  }) async {
    if (Platform.isLinux) return;

    await cancel(notification.id);
    await _plugin.zonedSchedule(
      id: notification.id,
      title: notification.title,
      body: notification.body,
      scheduledDate: scheduledDate,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _eventsChannelId,
          'Events',
          channelDescription: 'Download and sync completion notices.',
          importance: Importance.low,
          priority: Priority.low,
        ),
        linux: const LinuxNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: notification.route,
    );
  }

  static Future<void> _scheduleRecurringSlot({
    required NotificationIntent notification,
    required int slotIndex,
    required tz.TZDateTime scheduledDate,
    required DateTimeComponents matchDateTimeComponents,
  }) async {
    await _plugin.zonedSchedule(
      id: _slotId(notification.id, slotIndex),
      title: notification.title,
      body: notification.body,
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
      matchDateTimeComponents: matchDateTimeComponents,
      payload: notification.route,
    );
  }

  static tz.TZDateTime _nextDailyDate(Time time) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  static tz.TZDateTime _nextWeeklyDate(WeekdayTime day) {
    final now = tz.TZDateTime.now(tz.local);
    final daysUntil = (_dartWeekday(day.weekday) - now.weekday) % 7;
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day + daysUntil,
      day.time.hour,
      day.time.minute,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 7));
    }
    return scheduledDate;
  }

  static tz.TZDateTime _nextMonthlyDate(MonthDayTime day) {
    final now = tz.TZDateTime.now(tz.local);
    for (var offset = 0; offset < 24; offset++) {
      final candidateMonth = now.month + offset;
      final year = now.year + (candidateMonth - 1) ~/ 12;
      final month = ((candidateMonth - 1) % 12) + 1;
      if (day.day > _daysInMonth(year, month)) continue;

      final scheduledDate = tz.TZDateTime(
        tz.local,
        year,
        month,
        day.day,
        day.time.hour,
        day.time.minute,
      );
      if (scheduledDate.isAfter(now)) return scheduledDate;
    }

    throw StateError('Unable to calculate next monthly notification date.');
  }

  static tz.TZDateTime _nextYearlyDate(YearDateTime date) {
    final now = tz.TZDateTime.now(tz.local);
    for (var offset = 0; offset < 8; offset++) {
      final year = now.year + offset;
      if (date.day > _daysInMonth(year, date.month)) continue;

      final scheduledDate = tz.TZDateTime(
        tz.local,
        year,
        date.month,
        date.day,
        date.time.hour,
        date.time.minute,
      );
      if (scheduledDate.isAfter(now)) return scheduledDate;
    }

    throw StateError('Unable to calculate next yearly notification date.');
  }

  static int _dartWeekday(Weekday weekday) {
    return switch (weekday) {
      Weekday.monday => DateTime.monday,
      Weekday.tuesday => DateTime.tuesday,
      Weekday.wednesday => DateTime.wednesday,
      Weekday.thursday => DateTime.thursday,
      Weekday.friday => DateTime.friday,
      Weekday.saturday => DateTime.saturday,
      Weekday.sunday => DateTime.sunday,
    };
  }

  static int _daysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  static int _slotId(int notificationId, int slotIndex) {
    if (slotIndex == 0) return notificationId;
    final slotId = notificationId * 1000 + slotIndex;
    if (slotId <= 0x7fffffff) return slotId;

    return 1000000000 + _stableHash('$notificationId:$slotIndex');
  }

  static int _stableHash(String value) {
    var hash = 0x811c9dc5;
    for (final unit in value.codeUnits) {
      hash ^= unit;
      hash = (hash * 0x01000193) & 0x7fffffff;
    }
    return hash % 1000000000;
  }

  static tz.TZDateTime _dateTimeToLocalTz(DateTime dateTime) {
    final local = dateTime.toLocal();
    return tz.TZDateTime(
      tz.local,
      local.year,
      local.month,
      local.day,
      local.hour,
      local.minute,
      local.second,
      local.millisecond,
      local.microsecond,
    );
  }

  static Future<void> _showNow(NotificationIntent notification) async {
    await _plugin.show(
      id: notification.id,
      title: notification.title,
      body: notification.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _eventsChannelId,
          'Events',
          importance: Importance.low,
          priority: Priority.low,
        ),
        linux: const LinuxNotificationDetails(),
      ),
      payload: notification.route,
    );
  }

  // -------------------------------------------------------------------------
  // Cancellation
  // -------------------------------------------------------------------------

  /// Cancel a single notification by [id].
  static Future<void> cancel(int id) async {
    await _plugin.cancel(id: id);
    for (var slotIndex = 1; slotIndex < 400; slotIndex++) {
      await _plugin.cancel(id: _slotId(id, slotIndex));
    }
  }

  /// Cancel all pending and delivered notifications.
  static Future<void> cancelAll() => _plugin.cancelAll();
}
