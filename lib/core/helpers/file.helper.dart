import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart' show PlatformFile;

abstract final class FileHelper {
  static String toAppropriateFileName(String value) =>
      value.replaceAll(RegExp(r'[^A-Za-z0-9_.-]'), '_');

  static Future<Uint8List?> getBytesFromPickedFile(PlatformFile file) async {
    final bytes = file.bytes;
    if (bytes != null && bytes.isNotEmpty) return bytes;

    final path = file.path?.trim();
    if (path == null || path.isEmpty) return null;

    final localFile = File(path);
    if (!await localFile.exists()) return null;
    return localFile.readAsBytes();
  }
}
