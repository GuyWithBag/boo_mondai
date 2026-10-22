import 'package:boo_mondai/lib.barrel.dart'
    show
        MatchingTypeValue,
        MatchingTypeTemplate,
        CardTemplateEditorController,
        Vector2Hive;
import 'package:signals/signals_flutter.dart';

class MatchingTypeEditorController
    extends CardTemplateEditorController<MatchingTypeTemplate> {
  MatchingTypeEditorController({required super.editDeckController});

  late final Computed<List<MatchingTypeValue>> values = computed(
    () => _sortedValues(template.values),
  );
  late final Computed<int> rowCount = computed(
    () => (values.value.length / 2).ceil().clamp(1, double.infinity).toInt(),
  );

  MatchingTypeValue? valueAt(int column, int row) {
    for (final value in values.value) {
      if (_columnOf(value.position) == column &&
          _rowOf(value.position) == row) {
        return value;
      }
    }
    return null;
  }

  void addRow() {
    final current = template;
    final row = rowCount.value;
    template = current.copyWith(
      values: _normalizeRows([
        ...current.values,
        MatchingTypeValue.createDummy(position: Vector2Hive(0, row.toDouble())),
        MatchingTypeValue.createDummy(position: Vector2Hive(1, row.toDouble())),
      ]),
    );
  }

  void removeRow(int row) {
    final current = template;
    if (rowCount.value <= 1) return;
    template = current.copyWith(
      values: _normalizeRows([
        for (final value in current.values)
          if (_rowOf(value.position) != row) value,
      ]),
    );
  }

  void updateValueText({
    required int column,
    required int row,
    required String text,
  }) {
    final current = template;
    template = current.copyWith(
      values: [
        for (final value in current.values)
          _isAt(value, column, row) ? value.copyWith(text: text) : value,
      ],
    );
  }

  void moveValue({
    required int fromColumn,
    required int fromRow,
    required int toColumn,
    required int toRow,
  }) {
    if (fromColumn == toColumn && fromRow == toRow) return;

    final current = template;
    final fromIndex = current.values.indexWhere(
      (value) => _isAt(value, fromColumn, fromRow),
    );
    if (fromIndex == -1) return;

    final toIndex = current.values.indexWhere(
      (value) => _isAt(value, toColumn, toRow),
    );
    final next = [...current.values];
    next[fromIndex] = next[fromIndex].copyWith(
      position: Vector2Hive(toColumn.toDouble(), toRow.toDouble()),
    );
    if (toIndex != -1) {
      next[toIndex] = next[toIndex].copyWith(
        position: Vector2Hive(fromColumn.toDouble(), fromRow.toDouble()),
      );
    }

    template = current.copyWith(values: _normalizeRows(next));
  }

  @override
  void dispose() {
    values.dispose();
    rowCount.dispose();
    super.dispose();
  }

  static bool _isAt(MatchingTypeValue value, int column, int row) {
    return _columnOf(value.position) == column && _rowOf(value.position) == row;
  }

  static int _columnOf(Vector2Hive position) => position.x.round().clamp(0, 1);

  static int _rowOf(Vector2Hive position) => position.y.round();

  static List<MatchingTypeValue> _sortedValues(List<MatchingTypeValue> values) {
    return [...values]..sort((a, b) {
      final rowComparison = _rowOf(a.position).compareTo(_rowOf(b.position));
      if (rowComparison != 0) return rowComparison;
      return _columnOf(a.position).compareTo(_columnOf(b.position));
    });
  }

  static List<MatchingTypeValue> _normalizeRows(
    List<MatchingTypeValue> values,
  ) {
    final sorted = _sortedValues(values);
    return [
      for (final entry in sorted.asMap().entries)
        entry.value.copyWith(
          position: Vector2Hive(
            (entry.key % 2).toDouble(),
            (entry.key ~/ 2).toDouble(),
          ),
          matchPosition: Vector2Hive(
            entry.key.isEven ? 1 : 0,
            (entry.key ~/ 2).toDouble(),
          ),
        ),
    ];
  }
}
