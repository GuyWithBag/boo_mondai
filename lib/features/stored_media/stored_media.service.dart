import 'dart:io';
import 'dart:typed_data' show Uint8List;

import 'package:boo_mondai/lib.barrel.dart'
    show FileHelper, ImageHelper, LocalDB, MediaHelper, StoredMedia;
import 'package:file_picker/file_picker.dart'
    show FilePicker, FileType, PlatformFile;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

abstract final class StoredMediaService {
  static Future<PlatformFile?> pickSupportedFile() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: MediaHelper.supportedExtensions,
      allowMultiple: false,
      withData: true,
    );
    final files = result?.files;
    if (files == null || files.isEmpty) return null;
    return files.first;
  }

  static Future<String?> writePickedFileToLocal({
    required String id,
    required PlatformFile file,
    String? remoteUrl,
  }) async {
    final bytes = await FileHelper.getBytesFromPickedFile(file);
    if (bytes == null || bytes.isEmpty) return null;

    return writeToLocal(
      id: id,
      bytes: bytes,
      mimeType: MediaHelper.mimeTypeFromExtension(file.extension),
      remoteUrl: remoteUrl,
    );
  }

  static Future<String?> downloadToLocal({
    required String id,
    required String remoteUrl,
  }) async {
    if (!ImageHelper.isRemoteUrl(remoteUrl)) return null;

    final response = await http.get(Uri.parse(remoteUrl));
    if (response.statusCode < 200 || response.statusCode >= 300) return null;

    return writeToLocal(
      id: id,
      bytes: response.bodyBytes,
      mimeType: response.headers['content-type']?.split(';').first.trim(),
      remoteUrl: remoteUrl,
    );
  }

  static Future<String> writeToLocal({
    required String id,
    required Uint8List bytes,
    String? mimeType,
    String? remoteUrl,
  }) async {
    final now = DateTime.now();
    final existing = LocalDB.storedMedia.selectByPk({'id': id});
    final directory = await getMediaDirectory();
    final extension = MediaHelper.extensionFromMimeType(mimeType);
    final file = File(
      '${directory.path}/${FileHelper.toAppropriateFileName(id)}.$extension',
    );
    await file.writeAsBytes(bytes, flush: true);

    final oldPath = existing?.localPath;
    if (oldPath != null && oldPath != file.path) {
      await deleteLocalFile(oldPath);
    }

    await LocalDB.storedMedia.upsert(
      StoredMedia(
        id: id,
        localPath: file.path,
        remoteUrl: remoteUrl,
        mimeType: mimeType,
        byteSize: bytes.length,
        createdAt: existing?.createdAt ?? now,
        updatedAt: now,
      ),
    );

    return file.path;
  }

  static String? getLocalPath(String id) {
    final entry = getById(id);
    final localPath = entry?.localPath;
    if (localPath == null || localPath.trim().isEmpty) return null;
    return File(localPath).existsSync() ? localPath : null;
  }

  static StoredMedia? getById(String id) {
    return LocalDB.storedMedia.selectByPk({'id': id});
  }

  static String? getLocalPathForRemoteUrl(String remoteUrl) {
    final entry = getByRemoteUrl(remoteUrl);
    final localPath = entry?.localPath;
    if (localPath == null || localPath.trim().isEmpty) return null;
    return File(localPath).existsSync() ? localPath : null;
  }

  static StoredMedia? getByRemoteUrl(String remoteUrl) {
    final normalizedRemoteUrl = remoteUrl.trim();
    if (normalizedRemoteUrl.isEmpty) return null;

    return LocalDB.storedMedia
        .selectMany(
          where: (item) => item.remoteUrl?.trim() == normalizedRemoteUrl,
          limit: 1,
        )
        .firstOrNull;
  }

  static Future<void> deleteLocalFile(String localPath) async {
    final file = File(localPath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  static Future<Directory> getMediaDirectory() async {
    final documents = await getApplicationDocumentsDirectory();
    final directory = Directory('${documents.path}/stored_medias');
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    return directory;
  }
}
