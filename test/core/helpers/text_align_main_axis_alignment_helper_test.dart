import 'package:boo_mondai/lib.barrel.dart' show TextHelper;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TextHelper', () {
    test('maps center to center', () {
      expect(
        TextHelper.getMainAxisAlignmentForTextAlign(TextAlign.center),
        MainAxisAlignment.center,
      );
    });

    test('maps left and start to start', () {
      expect(
        TextHelper.getMainAxisAlignmentForTextAlign(TextAlign.left),
        MainAxisAlignment.start,
      );
      expect(
        TextHelper.getMainAxisAlignmentForTextAlign(TextAlign.start),
        MainAxisAlignment.start,
      );
    });

    test('maps right and end to end', () {
      expect(
        TextHelper.getMainAxisAlignmentForTextAlign(TextAlign.right),
        MainAxisAlignment.end,
      );
      expect(
        TextHelper.getMainAxisAlignmentForTextAlign(TextAlign.end),
        MainAxisAlignment.end,
      );
    });

    test('maps justify to spaceBetween', () {
      expect(
        TextHelper.getMainAxisAlignmentForTextAlign(TextAlign.justify),
        MainAxisAlignment.spaceBetween,
      );
    });
  });
}
