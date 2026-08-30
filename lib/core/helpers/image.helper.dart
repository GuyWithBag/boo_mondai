import 'dart:convert';

import 'package:file_picker/file_picker.dart' show PlatformFile;
import 'package:flutter/material.dart';
import 'package:boo_mondai/core/helpers/media.helper.dart';

abstract final class ImageHelper {
  static ImageProvider? getImageProviderFromSource(String? source) {
    final value = source?.trim();
    if (value == null) return null;

    if (MediaHelper.isRemoteUrl(value)) {
      return NetworkImage(value);
    }

    return AssetImage(value);
  }

  static String? getImageSourceFromPickedFile(PlatformFile file) {
    final bytes = file.bytes;
    if (bytes != null && bytes.isNotEmpty) {
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
