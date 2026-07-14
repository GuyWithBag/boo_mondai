abstract class TimeHelper {
  static bool isStrictlyAfterMs(DateTime a, DateTime b) {
    return a.toUtc().millisecondsSinceEpoch > b.toUtc().millisecondsSinceEpoch;
  }
}
