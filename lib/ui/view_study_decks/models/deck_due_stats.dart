class DeckDueStats {
  final int dueNew;
  final int dueLearning;
  final int dueReview;

  const DeckDueStats({
    this.dueNew = 0,
    this.dueLearning = 0,
    this.dueReview = 0,
  });

  int get totalDue => dueNew + dueLearning + dueReview;
}
