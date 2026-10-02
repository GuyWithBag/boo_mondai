class DeckRatingStats {
  final int again;
  final int hard;
  final int good;
  final int easy;

  const DeckRatingStats({
    this.again = 0,
    this.hard = 0,
    this.good = 0,
    this.easy = 0,
  });

  int get totalReviews => again + hard + good + easy;
}
