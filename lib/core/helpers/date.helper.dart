abstract final class DateHelper {
  static DateTime localDateOnly(DateTime value) {
    final local = value.toLocal();
    return DateTime(local.year, local.month, local.day);
  }

  static bool isSameLocalDate(DateTime a, DateTime b) {
    return localDateOnly(a) == localDateOnly(b);
  }

  static int daysBetweenLocalDates(DateTime from, DateTime to) {
    return localDateOnly(to).difference(localDateOnly(from)).inDays;
  }

  static String formatDateYyyyMmDd(DateTime value) {
    final local = localDateOnly(value);
    final year = local.year.toString().padLeft(4, '0');
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  static String formatDateDdMmYy(DateTime value) {
    final local = localDateOnly(value);
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    final year = (local.year % 100).toString().padLeft(2, '0');
    return '$day-$month-$year';
  }
}
