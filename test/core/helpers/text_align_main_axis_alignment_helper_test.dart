import 'package:boo_mondai/lib.barrel.dart'
    show TextAlignMainAxisAlignmentHelper;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TextAlignMainAxisAlignmentHelper', () {
    test('maps center to center', () {
      expect(
        TextAlignMainAxisAlignmentHelper.fromTextAlign(TextAlign.center),
        MainAxisAlignment.center,
      );
    });

    test('maps left and start to start', () {
      expect(
        TextAlignMainAxisAlignmentHelper.fromTextAlign(TextAlign.left),
        MainAxisAlignment.start,
      );
      expect(
        TextAlignMainAxisAlignmentHelper.fromTextAlign(TextAlign.start),
        MainAxisAlignment.start,
      );
    });

    test('maps right and end to end', () {
      expect(
        TextAlignMainAxisAlignmentHelper.fromTextAlign(TextAlign.right),
        MainAxisAlignment.end,
      );
      expect(
        TextAlignMainAxisAlignmentHelper.fromTextAlign(TextAlign.end),
        MainAxisAlignment.end,
      );
    });

    test('maps justify to spaceBetween', () {
      expect(
        TextAlignMainAxisAlignmentHelper.fromTextAlign(TextAlign.justify),
        MainAxisAlignment.spaceBetween,
      );
    });
  });
}
