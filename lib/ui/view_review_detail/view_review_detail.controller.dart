import 'package:boo_mondai/lib.barrel.dart' show Deck, FsrsReviewLog, LocalDB;
import 'package:boo_mondai/ui/view_review_detail/models/models.barrel.dart';
import 'package:signals/signals_flutter.dart';

class ViewReviewDetailController {
  ViewReviewDetailController(this.deckId) {
    load();
  }

  final String deckId;
  final deck = signal<Deck?>(null);
  final reviewLogs = signal<List<FsrsReviewLog>>(const []);
  final isLoading = signal(true);
  final error = signal<Exception?>(null);
  final timeSpan = signal(ReviewDetailTimeSpan.oneWeek);
  final rangeMode = signal(ReviewDetailRangeMode.relative);
  final customAmount = signal(30);
  final customUnit = signal(ReviewDetailTimeUnit.days);

  late final reviewCounts = computed(() {
    final now = dateOnly(DateTime.now());
    final start = rangeStart(now);
    final dayCount = now.difference(start).inDays;
    final counts = <int, int>{
      for (var day = 0; day <= dayCount; day++) -day: 0,
    };

    for (final reviewLog in reviewLogs.value) {
      final reviewedDay = dateOnly(reviewLog.reviewedAt.toLocal());
      final dayOffset = reviewedDay.difference(now).inDays;
      if (dayOffset <= 0 && dayOffset >= -dayCount) {
        counts[dayOffset] = (counts[dayOffset] ?? 0) + 1;
      }
    }

    return List.unmodifiable([
      for (var day = dayCount; day >= 0; day--)
        (day: -day, count: counts[-day]!),
    ]);
  });

  late final chartBars = computed(() {
    final dailyBars = reviewCounts.value;
    final aggregateByMonth =
        timeSpan.value == ReviewDetailTimeSpan.threeMonths ||
        timeSpan.value == ReviewDetailTimeSpan.sixMonths ||
        timeSpan.value == ReviewDetailTimeSpan.oneYear;
    if (!aggregateByMonth) {
      return List.unmodifiable([
        for (var index = 0; index < dailyBars.length; index++)
          (
            index: index,
            count: dailyBars[index].count,
            label: '${dailyBars[index].day}',
          ),
      ]);
    }

    final end = dateOnly(DateTime.now());
    final start = rangeStart(end);
    final intervalMonths = timeSpan.value == ReviewDetailTimeSpan.oneYear
        ? 2
        : 1;
    final bars = <({int index, int count, String label})>[];
    var bucketStart = DateTime(start.year, start.month);
    var index = 0;
    while (bucketStart.isBefore(end) || bucketStart.month == end.month) {
      final bucketEnd = DateTime(
        bucketStart.year,
        bucketStart.month + intervalMonths,
      );
      final count = reviewLogs.value.where((reviewLog) {
        final reviewedAt = dateOnly(reviewLog.reviewedAt.toLocal());
        return !reviewedAt.isBefore(bucketStart) &&
            reviewedAt.isBefore(bucketEnd) &&
            !reviewedAt.isAfter(end);
      }).length;
      bars.add((
        index: index,
        count: count,
        label: monthLabel(bucketStart, intervalMonths),
      ));
      bucketStart = bucketEnd;
      index++;
    }
    return List.unmodifiable(bars);
  });

  Future<void> load() async {
    isLoading.value = true;
    error.value = null;

    try {
      final loadedDeck = LocalDB.deck.selectByPk({'id': deckId});
      deck.value = loadedDeck;
      if (loadedDeck == null) {
        reviewLogs.value = const [];
        return;
      }

      final studyCards = LocalDB.studyCard
          .selectMany()
          .where((card) => card.deckId == loadedDeck.id)
          .toList(growable: false);
      final studyCardIds = studyCards.map((card) => card.id).toSet();
      final fsrsCardIds = LocalDB.fsrsCard
          .selectMany()
          .where((card) => studyCardIds.contains(card.studyCardId))
          .map((card) => card.id)
          .toSet();
      reviewLogs.value = List.unmodifiable(
        LocalDB.reviewLogs
            .selectMany()
            .where((log) => fsrsCardIds.contains(log.fsrsCardId))
            .toList(),
      );
    } on Exception catch (exception) {
      error.value = exception;
    } finally {
      isLoading.value = false;
    }
  }

  void selectTimeSpan(ReviewDetailTimeSpan value) {
    timeSpan.value = value;
  }

  void setRangeMode(ReviewDetailRangeMode value) {
    rangeMode.value = value;
  }

  void setCustomAmount(String value) {
    final parsed = int.tryParse(value);
    if (parsed != null && parsed > 0) customAmount.value = parsed;
  }

  void setCustomUnit(ReviewDetailTimeUnit value) {
    customUnit.value = value;
  }

  DateTime rangeStart(DateTime end) {
    if (rangeMode.value == ReviewDetailRangeMode.fixed) {
      return switch (timeSpan.value) {
        ReviewDetailTimeSpan.oneWeek => end.subtract(
          Duration(days: end.weekday - 1),
        ),
        ReviewDetailTimeSpan.oneMonth => DateTime(end.year, end.month),
        ReviewDetailTimeSpan.threeMonths => DateTime(end.year, end.month - 2),
        ReviewDetailTimeSpan.sixMonths => DateTime(end.year, end.month - 5),
        ReviewDetailTimeSpan.oneYear => DateTime(end.year),
        ReviewDetailTimeSpan.custom => end.subtract(customDuration),
      };
    }

    return end.subtract(selectedDuration);
  }

  Duration get selectedDuration {
    return switch (timeSpan.value) {
      ReviewDetailTimeSpan.oneWeek => const Duration(days: 7),
      ReviewDetailTimeSpan.oneMonth => const Duration(days: 30),
      ReviewDetailTimeSpan.threeMonths => const Duration(days: 90),
      ReviewDetailTimeSpan.sixMonths => const Duration(days: 180),
      ReviewDetailTimeSpan.oneYear => const Duration(days: 365),
      ReviewDetailTimeSpan.custom => customDuration,
    };
  }

  Duration get customDuration {
    return switch (customUnit.value) {
      ReviewDetailTimeUnit.days => Duration(days: customAmount.value),
      ReviewDetailTimeUnit.weeks => Duration(days: customAmount.value * 7),
      ReviewDetailTimeUnit.months => Duration(days: customAmount.value * 30),
      ReviewDetailTimeUnit.years => Duration(days: customAmount.value * 365),
    };
  }

  DateTime dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

  String monthLabel(DateTime month, int intervalMonths) {
    const names = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    if (intervalMonths == 1) return names[month.month - 1];
    final endMonth = DateTime(month.year, month.month + intervalMonths - 1);
    return '${names[month.month - 1]}-${names[endMonth.month - 1]}';
  }

  void dispose() {
    reviewCounts.dispose();
    chartBars.dispose();
    deck.dispose();
    reviewLogs.dispose();
    isLoading.dispose();
    error.dispose();
    timeSpan.dispose();
    rangeMode.dispose();
    customAmount.dispose();
    customUnit.dispose();
  }
}
