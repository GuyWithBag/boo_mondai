import 'dart:io';
import 'dart:typed_data';

import 'package:boo_mondai/lib.barrel.dart'
    show LocalDB, LocalImageCacheEntry, LocalImagePathHelper;
import 'package:file_picker/file_picker.dart' show PlatformFile;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

abstract final class LocalImageCacheService {
  static Future<String?> savePickedImage({
    required String cacheKey,
    required PlatformFile file,
    String? remotePath,
  }) async {
    final bytes = await _bytesFromPickedFile(file);
    if (bytes == null || bytes.isEmpty) return null;

    return saveBytes(
      cacheKey: cacheKey,
      bytes: bytes,
      mimeType: LocalImagePathHelper.mimeTypeForExtension(file.extension),
      remotePath: remotePath,
    );
  }

  static Future<String?> cacheRemoteImage({
    required String cacheKey,
    required String remotePath,
  }) async {
    if (!LocalImagePathHelper.isRemotePath(remotePath)) return null;

    final response = await http.get(Uri.parse(remotePath));
    if (response.statusCode < 200 || response.statusCode >= 300) return null;

    return saveBytes(
      cacheKey: cacheKey,
      bytes: response.bodyBytes,
      mimeType: response.headers['content-type']?.split(';').first.trim(),
      remotePath: remotePath,
    );
  }

  static Future<String> saveBytes({
    required String cacheKey,
    required Uint8List bytes,
    String? mimeType,
    String? remotePath,
  }) async {
    final now = DateTime.now();
    final existing = LocalDB.localImage.selectByPk({'cache_key': cacheKey});
    final directory = await _imageDirectory();
    final extension = LocalImagePathHelper.extensionFromMimeType(mimeType);
    final file = File(
      '${directory.path}/${_safeFileName(cacheKey)}.$extension',
    );
    await file.writeAsBytes(bytes, flush: true);

    final oldPath = existing?.localPath;
    if (oldPath != null && oldPath != file.path) {
      await deleteLocalFile(oldPath);
    }

    await LocalDB.localImage.upsert(
      LocalImageCacheEntry(
        cacheKey: cacheKey,
        localPath: file.path,
        remotePath: remotePath,
        mimeType: mimeType,
        byteSize: bytes.length,
        createdAt: existing?.createdAt ?? now,
        updatedAt: now,
      ),
    );

    return file.path;
  }

  static Future<void> deleteLocalFile(String localPath) async {
    final file = File(localPath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  static Future<Directory> _imageDirectory() async {
    final documents = await getApplicationDocumentsDirectory();
    final directory = Directory('${documents.path}/local_images');
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    return directory;
  }

  static Future<Uint8List?> _bytesFromPickedFile(PlatformFile file) async {
    final bytes = file.bytes;
    if (bytes != null && bytes.isNotEmpty) return bytes;

    final path = file.path?.trim();
    if (path == null || path.isEmpty) return null;

    final localFile = File(path);
    if (!await localFile.exists()) return null;
    return localFile.readAsBytes();
  }

  static String _safeFileName(String cacheKey) =>
      cacheKey.replaceAll(RegExp(r'[^A-Za-z0-9_.-]'), '_');
}
