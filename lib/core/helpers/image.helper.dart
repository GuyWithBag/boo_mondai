import 'dart:convert';

import 'package:file_picker/file_picker.dart' show PlatformFile;
import 'package:flutter/material.dart';
import 'package:boo_mondai/core/helpers/image_file_provider_stub.dart'
    if (dart.library.io) 'package:boo_mondai/core/helpers/image_file_provider_io.dart'
    show imageProviderFromFilePath;

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

    final fileImage = imageProviderFromFilePath(value);
    if (fileImage != null) return fileImage;

    return AssetImage(value);
  }

  static String? sourceFromPickedFile(PlatformFile file) {
    final bytes = file.bytes;
    if (bytes != null && bytes.isNotEmpty) {
      return 'data:${_mimeTypeForExtension(file.extension)};base64,${base64Encode(bytes)}';
    }

    final path = file.path?.trim();
    if (path == null || path.isEmpty) {
      return null;
    }

    return path;
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
