import 'package:boo_mondai/lib.barrel.dart' show StringHelper;
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StringHelper.truncateWithEllipsis', () {
    test('returns unchanged values within the limit', () {
      expect(StringHelper.truncateWithEllipsis('hello', 5), 'hello');
    });

    test('truncates long values with an ellipsis', () {
      expect(StringHelper.truncateWithEllipsis('hello world', 8), 'hello...');
    });

    test('handles very small limits', () {
      expect(StringHelper.truncateWithEllipsis('hello', 2), '..');
    });
  });
}
