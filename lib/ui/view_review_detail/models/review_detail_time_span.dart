enum ReviewDetailTimeSpan {
  oneWeek('1 week'),
  oneMonth('1 month'),
  threeMonths('3 months'),
  sixMonths('6 months'),
  oneYear('1 year'),
  custom('Custom');

  const ReviewDetailTimeSpan(this.label);

  final String label;
}
