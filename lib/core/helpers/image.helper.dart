import 'dart:convert';

import 'package:file_picker/file_picker.dart' show PlatformFile;
import 'package:flutter/material.dart';

abstract final class ImageHelper {
  static ImageProvider? providerFromSource(String? source) {
    final value = source?.trim();
    if (value == null || value.isEmpty) return null;

    final uri = Uri.tryParse(value);
    if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https')) {
      return NetworkImage(value);
    }

    final dataImage = _memoryImageFromDataUri(value);
    if (dataImage != null) return dataImage;

    return AssetImage(value);
  }

  static String? sourceFromPickedFile(PlatformFile file) {
    final bytes = file.bytes;
    if (bytes == null || bytes.isEmpty) {
      return null;
    }

    return 'data:${_mimeTypeForExtension(file.extension)};base64,${base64Encode(bytes)}';
  }

  static MemoryImage? _memoryImageFromDataUri(String value) {
    final uri = Uri.tryParse(value);
    if (uri == null || uri.scheme != 'data' || !value.contains(',')) {
      return null;
    }

    final base64Part = value.substring(value.indexOf(',') + 1);
    return MemoryImage(base64Decode(base64Part));
  }

  static String _mimeTypeForExtension(String? extension) {
    return switch (extension?.toLowerCase()) {
      'jpg' || 'jpeg' => 'image/jpeg',
      'webp' => 'image/webp',
      'gif' => 'image/gif',
      'bmp' => 'image/bmp',
      _ => 'image/png',
    };
  }
}
