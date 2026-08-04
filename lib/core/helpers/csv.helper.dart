abstract final class CsvHelper {
  static String rows(List<List<Object?>> rows) {
    return rows.map(row).join('\n');
  }

  static String row(List<Object?> cells) {
    return cells.map(cell).join(',');
  }

  static String cell(Object? value) {
    final text = value?.toString() ?? '';
    final escaped = text.replaceAll('"', '""');
    return '"$escaped"';
  }
}
