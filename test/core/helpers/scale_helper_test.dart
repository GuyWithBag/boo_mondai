import 'package:boo_mondai/lib.barrel.dart' show ScaleHelper;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ScaleHelper', () {
    test('getSizeFromWidthAndAspectRatio returns matching height', () {
      expect(
        ScaleHelper.getSizeFromWidthAndAspectRatio(
          width: 300,
          aspectRatio: 5 / 7,
        ),
        const Size(300, 420),
      );
    });
  });
}
