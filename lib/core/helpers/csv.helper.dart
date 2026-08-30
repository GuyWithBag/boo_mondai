import 'package:csv/csv.dart' as csv_package;

abstract final class CsvHelper {
  static String rows(List<List<Object?>> rows) {
    return csv_package.csv.encode(rows);
  }

  static String row(List<Object?> cells) {
    return csv_package.csv.encode([cells]);
  }

  static String cell(Object? value) {
    return row([value]);
  }

  static List<Map<String, dynamic>> toManyMaps(String text) {
    final rows = csv_package.csv.decodeWithHeaders(text);
    if (rows.isEmpty) {
      throw const FormatException('CSV must include headers and rows.');
    }

    final headers = rows.first.headerMap.keys.toList(growable: false);
    if (headers.isEmpty || headers.every((header) => header.trim().isEmpty)) {
      throw const FormatException('CSV must include headers.');
    }

    return rows.map((row) => row.toMap()).toList(growable: false);
  }
}
