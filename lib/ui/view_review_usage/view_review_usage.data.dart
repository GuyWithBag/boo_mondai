typedef ReviewLogPoint = ({int day, int reviews});

enum ReviewLogDataset {
  japaneseSetAUser1,
  japaneseSetAUser2,
  japaneseSetAUser3,
  japaneseSetBUser1,
  japaneseSetBUser2,
  chineseSetAUser1,
  chineseSetAUser2,
  chineseSetAUser3,
  chineseSetBUser1,
  chineseSetBUser2,
}

extension ReviewLogDatasetDetails on ReviewLogDataset {
  String get userName => switch (this) {
    ReviewLogDataset.japaneseSetAUser1 => 'J-A01',
    ReviewLogDataset.japaneseSetAUser2 => 'J-A02',
    ReviewLogDataset.japaneseSetAUser3 => 'J-A03',
    ReviewLogDataset.japaneseSetBUser1 => 'J-A04',
    ReviewLogDataset.japaneseSetBUser2 => 'J-A05',
    ReviewLogDataset.chineseSetAUser1 => 'C-A01',
    ReviewLogDataset.chineseSetAUser2 => 'C-A02',
    ReviewLogDataset.chineseSetAUser3 => 'C-A03',
    ReviewLogDataset.chineseSetBUser1 => 'C-A04',
    ReviewLogDataset.chineseSetBUser2 => 'C-A05',
  };

  String get deckTitle => switch (this) {
    ReviewLogDataset.japaneseSetAUser1 ||
    ReviewLogDataset.japaneseSetAUser2 ||
    ReviewLogDataset.japaneseSetAUser3 => 'Japanese Set A',
    ReviewLogDataset.japaneseSetBUser1 ||
    ReviewLogDataset.japaneseSetBUser2 => 'Japanese Set B',
    ReviewLogDataset.chineseSetAUser1 ||
    ReviewLogDataset.chineseSetAUser2 ||
    ReviewLogDataset.chineseSetAUser3 => 'Chinese Set A',
    ReviewLogDataset.chineseSetBUser1 ||
    ReviewLogDataset.chineseSetBUser2 => 'Chinese Set B',
  };

  int get preTestScore => switch (this) {
    ReviewLogDataset.japaneseSetAUser1 => 22,
    ReviewLogDataset.japaneseSetAUser2 => 20,
    ReviewLogDataset.japaneseSetAUser3 => 17,
    ReviewLogDataset.japaneseSetBUser1 => 13,
    ReviewLogDataset.japaneseSetBUser2 => 29,
    ReviewLogDataset.chineseSetAUser1 => 27,
    ReviewLogDataset.chineseSetAUser2 => 27,
    ReviewLogDataset.chineseSetAUser3 => 26,
    ReviewLogDataset.chineseSetBUser1 => 15,
    ReviewLogDataset.chineseSetBUser2 => 24,
  };

  int get postTestScore => switch (this) {
    ReviewLogDataset.japaneseSetAUser1 => 24,
    ReviewLogDataset.japaneseSetAUser2 => 26,
    ReviewLogDataset.japaneseSetAUser3 => 24,
    ReviewLogDataset.japaneseSetBUser1 => 26,
    ReviewLogDataset.japaneseSetBUser2 => 29,
    ReviewLogDataset.chineseSetAUser1 => 29,
    ReviewLogDataset.chineseSetAUser2 => 29,
    ReviewLogDataset.chineseSetAUser3 => 29,
    ReviewLogDataset.chineseSetBUser1 => 22,
    ReviewLogDataset.chineseSetBUser2 => 27,
  };

  List<ReviewLogPoint> get reviewLog => createEstimatedReviewLog(this);

  int get daysStudied => reviewLog.where((point) => point.reviews > 0).length;

  int get totalReviews =>
      reviewLog.fold(0, (total, point) => total + point.reviews);

  double get averageOverPeriod => totalReviews / reviewLog.length;

  double get averageForDaysStudied =>
      daysStudied == 0 ? 0 : totalReviews / daysStudied;
}

const estimatedReviewDays = 7;
const reviewChartDays = 31;

List<ReviewLogPoint> createEstimatedReviewLog(ReviewLogDataset dataset) {
  // The response files contain test scores, but no review duration. Estimate
  // study time from the starting knowledge gap and observed score improvement.
  const baseMinutes = 10.0;
  const minutesPerMissingPoint = 0.5;
  const minutesPerImprovedPoint = 1.5;
  const reviewsPerMinute = 2.0;
  const dailyDistribution = <double>[0.08, 0.10, 0.13, 0.16, 0.20, 0.15, 0.18];

  final knowledgeGap = 30 - dataset.preTestScore;
  final scoreImprovement = (dataset.postTestScore - dataset.preTestScore).clamp(
    0,
    30,
  );
  final estimatedMinutes =
      baseMinutes +
      knowledgeGap * minutesPerMissingPoint +
      scoreImprovement * minutesPerImprovedPoint;
  final totalReviews = (estimatedMinutes * reviewsPerMinute).round();
  final reviews = List<int>.filled(reviewChartDays, 0);
  var allocatedReviews = 0;

  for (var index = 0; index < estimatedReviewDays; index++) {
    final dayReviews = index == estimatedReviewDays - 1
        ? totalReviews - allocatedReviews
        : (totalReviews * dailyDistribution[index]).floor();
    reviews[index] = dayReviews;
    allocatedReviews += dayReviews;
  }

  return [
    for (var index = 0; index < reviewChartDays; index++)
      (day: index + 1, reviews: reviews[index]),
  ];
}
