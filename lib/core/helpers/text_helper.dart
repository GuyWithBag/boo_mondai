import 'package:flutter/material.dart';

abstract final class TextHelper {
  static MainAxisAlignment textAlignToMainAxisalignment(TextAlign? textAlign) {
    if (textAlign == null) return MainAxisAlignment.start;
    return switch (textAlign) {
      TextAlign.center => MainAxisAlignment.center,
      TextAlign.left || TextAlign.start => MainAxisAlignment.start,
      TextAlign.right || TextAlign.end => MainAxisAlignment.end,
      TextAlign.justify => MainAxisAlignment.spaceBetween,
    };
  }
}
