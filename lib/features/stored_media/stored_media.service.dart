import 'dart:io';
import 'dart:typed_data' show Uint8List;

import 'package:boo_mondai/lib.barrel.dart'
    show
        FileHelper,
        ImageHelper,
        LocalDB,
        MediaHelper,
        StoredMedia,
        StoredMediaPath;
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

  static Future<StoredMedia?> storeFile({
    required StoredMediaPath path,
    required PlatformFile file,
    String? remoteUrl,
  }) async {
    final bytes = await FileHelper.getBytesFromPickedFile(file);
    if (bytes == null || bytes.isEmpty) return null;

    return storeBytes(
      path: path,
      bytes: bytes,
      mimeType: MediaHelper.mimeTypeFromExtension(file.extension),
      remoteUrl: remoteUrl,
    );
  }

  static Future<String?> remoteToLocal({
    required StoredMediaPath path,
    required String remoteUrl,
  }) async {
    if (!ImageHelper.isRemoteUrl(remoteUrl)) return null;

    final response = await http.get(Uri.parse(remoteUrl));
    if (response.statusCode < 200 || response.statusCode >= 300) return null;

    final stored = await storeBytes(
      path: path,
      bytes: response.bodyBytes,
      mimeType: response.headers['content-type']?.split(';').first.trim(),
      remoteUrl: remoteUrl,
    );
    return stored.localPath;
  }

  static Future<StoredMedia> storeBytes({
    required StoredMediaPath path,
    required Uint8List bytes,
    String? mimeType,
    String? remoteUrl,
  }) async {
    final now = DateTime.now();
    final extension = MediaHelper.extensionFromMimeType(mimeType);
    final id = path.id(extension);
    final existing = getByPath(path);
    final directory = await getMediaDirectory(path);
    final file = File('${directory.path}/${path.fileName(extension)}');
    await file.writeAsBytes(bytes, flush: true);

    final oldPath = existing?.localPath;
    if (oldPath != null && oldPath != file.path) {
      await deleteLocalFile(oldPath);
    }
    if (existing != null && existing.id != id) {
      await LocalDB.storedMedia.delete(existing);
    }

    final storedMedia = StoredMedia(
      id: id,
      localPath: file.path,
      remoteUrl: remoteUrl,
      mimeType: mimeType,
      byteSize: bytes.length,
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
    );

    await LocalDB.storedMedia.upsert(storedMedia);

    return storedMedia;
  }

  static File? getFileById(String id) {
    final entry = getById(id);
    final localPath = entry?.localPath;
    if (localPath == null || localPath.trim().isEmpty) return null;
    final file = File(localPath);
    return file.existsSync() ? file : null;
  }

  static StoredMedia? getById(String id) {
    return LocalDB.storedMedia.selectByPk({'id': id});
  }

  static File? getFileByPath(StoredMediaPath path) {
    final entry = getByPath(path);
    final localPath = entry?.localPath;
    if (localPath == null || localPath.trim().isEmpty) return null;
    final file = File(localPath);
    return file.existsSync() ? file : null;
  }

  static StoredMedia? getByPath(StoredMediaPath path) {
    if (path.isApp) {
      return getById(path.id(''));
    }

    final prefix = '${path.relativePathPrefix()}.';
    return LocalDB.storedMedia
        .selectMany(
          where: (item) =>
              item.id == path.relativePathPrefix() ||
              item.id.startsWith(prefix),
          limit: 1,
        )
        .firstOrNull;
  }

  static File? getFileByRemoteUrl(String remoteUrl) {
    final entry = getByRemoteUrl(remoteUrl);
    final localPath = entry?.localPath;
    if (localPath == null || localPath.trim().isEmpty) return null;
    final file = File(localPath);
    return file.existsSync() ? file : null;
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

  /// Records the remote value returned after a stored-media upload.
  static Future<void> markUploaded(StoredMedia storedMedia, String remoteUrl) {
    return LocalDB.storedMedia.upsert(
      StoredMedia(
        id: storedMedia.id,
        localPath: storedMedia.localPath,
        remoteUrl: remoteUrl,
        mimeType: storedMedia.mimeType,
        byteSize: storedMedia.byteSize,
        createdAt: storedMedia.createdAt,
        updatedAt: DateTime.now(),
      ),
    );
  }

  static Future<void> renameFolderByPrefix({
    required String oldPrefix,
    required String newPrefix,
  }) async {
    if (oldPrefix.isEmpty || oldPrefix == newPrefix) return;

    final storedMedias = LocalDB.storedMedia.selectMany(
      where: (media) =>
          media.id == oldPrefix || media.id.startsWith('$oldPrefix/'),
    );
    if (storedMedias.isEmpty) return;

    final now = DateTime.now();
    for (final storedMedia in storedMedias) {
      final newStoredMediaId = storedMedia.id.replaceFirst(
        oldPrefix,
        newPrefix,
      );
      final currentFilePath =
          getFileById(storedMedia.id)?.path ?? storedMedia.localPath;
      final newFilePath = await _getLocalFilePathFromId(newStoredMediaId);

      await _moveStoredMediaFile(
        currentFilePath: currentFilePath,
        newFilePath: newFilePath,
      );

      if (storedMedia.id != newStoredMediaId) {
        await LocalDB.storedMedia.delete(storedMedia);
      }

      await LocalDB.storedMedia.upsert(
        StoredMedia(
          id: newStoredMediaId,
          localPath: newFilePath,
          remoteUrl: storedMedia.remoteUrl,
          mimeType: storedMedia.mimeType,
          byteSize: storedMedia.byteSize,
          createdAt: storedMedia.createdAt,
          updatedAt: now,
        ),
      );
    }
  }

  static Future<void> deleteLocalFile(String localPath) async {
    final file = File(localPath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  static Future<Directory> getMediaDirectory(StoredMediaPath path) async {
    final documents = await getApplicationDocumentsDirectory();
    final directory = Directory(
      [documents.path, ...path.folderSegments].join('/'),
    );
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    return directory;
  }

  static Future<String> _getLocalFilePathFromId(String id) async {
    final documents = await getApplicationDocumentsDirectory();
    return [
      documents.path,
      ...id.split('/').where((segment) => segment.trim().isNotEmpty),
    ].join(Platform.pathSeparator);
  }

  static Future<void> _moveStoredMediaFile({
    required String currentFilePath,
    required String newFilePath,
  }) async {
    if (currentFilePath == newFilePath) return;

    final currentFile = File(currentFilePath);
    if (!await currentFile.exists()) return;

    final newFile = File(newFilePath);
    await newFile.parent.create(recursive: true);

    if (await newFile.exists()) {
      await newFile.delete();
    }

    await currentFile.rename(newFilePath);
  }
}
