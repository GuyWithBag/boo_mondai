import 'dart:io' show File;

import 'package:flutter/material.dart' show FileImage, ImageProvider;

ImageProvider? imageProviderFromFilePath(String value) {
  final path = value.trim();
  if (path.isEmpty) return null;

  return FileImage(File(path));
}
