class ChangeFieldDiff {
  const ChangeFieldDiff({required this.field, this.before, this.after});

  final String field;
  final Object? before;
  final Object? after;

  Map<String, dynamic> toJson() => {
    'field': field,
    'before': before?.toString(),
    'after': after?.toString(),
  };
}
