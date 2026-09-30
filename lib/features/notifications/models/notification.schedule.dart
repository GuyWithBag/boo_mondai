abstract interface class NotificationSchedule {}

class ImmediateSchedule implements NotificationSchedule {
  const ImmediateSchedule.now() : dateTime = null;

  const ImmediateSchedule.at(this.dateTime);

  final DateTime? dateTime;
}

class DailySchedule implements NotificationSchedule {
  const DailySchedule({required this.time});

  final Time time;
}

class WeeklySchedule implements NotificationSchedule {
  const WeeklySchedule({required this.days}) : assert(days.length > 0);

  final List<WeekdayTime> days;
}

class MonthlySchedule implements NotificationSchedule {
  const MonthlySchedule({required this.days}) : assert(days.length > 0);

  final List<MonthDayTime> days;
}

class YearlySchedule implements NotificationSchedule {
  const YearlySchedule({required this.dates}) : assert(dates.length > 0);

  final List<YearDateTime> dates;
}

class Time {
  const Time({required this.hour, required this.minute})
    : assert(hour >= 0 && hour <= 23),
      assert(minute >= 0 && minute <= 59);

  final int hour;
  final int minute;
}

class WeekdayTime {
  const WeekdayTime({required this.weekday, required this.time});

  final Weekday weekday;
  final Time time;
}

class MonthDayTime {
  const MonthDayTime({required this.day, required this.time})
    : assert(day >= 1 && day <= 31);

  final int day;
  final Time time;
}

class YearDateTime {
  const YearDateTime({
    required this.month,
    required this.day,
    required this.time,
  }) : assert(month >= 1 && month <= 12),
       assert(day >= 1 && day <= 31);

  final int month;
  final int day;
  final Time time;
}

enum Weekday { monday, tuesday, wednesday, thursday, friday, saturday, sunday }
