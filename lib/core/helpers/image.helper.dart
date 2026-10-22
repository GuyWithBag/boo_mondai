import 'dart:convert';
import 'dart:io' show File;

import 'package:boo_mondai/features/features.barrel.dart';
import 'package:file_picker/file_picker.dart' show PlatformFile;
import 'package:flutter/material.dart';
import 'package:boo_mondai/core/helpers/media.helper.dart';

abstract final class ImageHelper {
  static Future<ImageProvider?> getImageProviderFromSource(
    String? source,
  ) async {
    final value = source?.trim();
    if (value == null) return null;

    if (value.startsWith('data:image/')) {
      final commaIndex = value.indexOf(',');
      if (commaIndex < 0) return null;

      return MemoryImage(base64Decode(value.substring(commaIndex + 1)));
    }

    if (MediaHelper.isRemoteUrl(value)) {
      return NetworkImage(value);
    }

    final file = value.startsWith('/')
        ? File(value)
        : await FileSystemHandler.getFileByRelativePath(value);
    if (file == null || !await file.exists()) {
      return null;
    }
    return FileImage(file);
  }

  static Future<String?> getImageSourceFromPickedFile(PlatformFile file) async {
    final bytes = await file.readAsBytes();
    if (bytes.isNotEmpty) {
      return 'data:${getMimeTypeFromExtension(file.extension)};base64,${base64Encode(bytes)}';
    }

    final path = file.path?.trim();
    if (path == null || path.isEmpty) {
      return null;
    }

    return path;
  }

  static String getExtensionFromMimeType(String? mimeType) {
    final extension = MediaHelper.extensionFromMimeType(mimeType);
    return extension == 'bin' ? 'png' : extension;
  }

  static String getMimeTypeFromExtension(String? extension) {
    return MediaHelper.mimeTypeFromExtension(extension) ?? 'image/png';
  }
}
