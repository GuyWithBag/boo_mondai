import 'package:boo_mondai/lib.barrel.dart' show CsvHelper;
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CsvHelper', () {
    test('quotes every cell', () {
      expect(CsvHelper.row(['a', 'b']), '"a","b"');
    });

    test('escapes quotes in cells', () {
      expect(CsvHelper.cell('he said "hi"'), '"he said ""hi"""');
    });

    test('joins rows with newlines', () {
      expect(
        CsvHelper.rows([
          ['a', 'b'],
          ['c', null],
        ]),
        '"a","b"\n"c",""',
      );
    });
  });
}
