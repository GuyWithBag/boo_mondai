import 'package:boo_mondai/core/helpers/casing.helper.dart';
import 'package:boo_mondai/core/helpers/casing.type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CasingHelper.matches', () {
    test('accepts any casing without splitting mixed-case words', () {
      expect(CasingHelper.matches('saGING', 'Saging', CasingType.any), isTrue);
    });

    test('keeps exact casing strict', () {
      expect(
        CasingHelper.matches('saGING', 'Saging', CasingType.exact),
        isFalse,
      );
    });
  });
}
