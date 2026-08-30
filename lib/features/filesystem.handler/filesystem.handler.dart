import 'dart:io';
import 'dart:typed_data';

import 'package:boo_mondai/lib.barrel.dart' show MediaHelper, ImageHelper;
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

abstract class FileSystemHandler {
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

  static Future<File?> getCachedRemoteFile({
    required String remoteFileUrl,
    required String destinationFilePath,
  }) async {
    final cachedFile = File(destinationFilePath);
    if (await cachedFile.exists()) {
      return cachedFile;
    }

    final remoteToCacheFile = await storeRemoteAsFile(
      remoteFileUrl: remoteFileUrl,
      destinationFilePath: destinationFilePath,
    );

    return remoteToCacheFile;
  }

  static Future<File?> storeFile({
    required String path,
    required PlatformFile file,
  }) async {
    final bytes = file.bytes;
    if (bytes == null || bytes.isEmpty) return null;

    return storeBytes(path: path, bytes: bytes);
  }

  // ToDo: Should throw an error
  static Future<File> storeRemoteAsFile({
    required String remoteFileUrl,
    required String destinationFilePath,
  }) async {
    // if (!MediaHelper.isRemoteUrl(remoteFileUrl)) return null;

    final response = await http.get(Uri.parse(remoteFileUrl));
    // if (response.statusCode < 200 || response.statusCode >= 300) return null;

    final file = await storeBytes(
      path: destinationFilePath,
      bytes: response.bodyBytes,
    );
    return file;
  }

  static Future<File> storeBytes({
    required String path,
    required Uint8List bytes,
  }) async {
    final file = File(path);
    await file.writeAsBytes(bytes, flush: true);

    return file;
  }

  static File? getFileByRelativePath(String relativePath) {
    final absolutePath = getFileByPath(relativePath)?.path;
    if (absolutePath == null) return null;
    final file = File(absolutePath);
    return file.existsSync() ? file : null;
  }

  static File? getFileByPath(String path) {
    final file = File(path);
    return file.existsSync() ? file : null;
  }

  // ToDo: Currently decks uses the ApplicationDocumentsDirectory but that should be configurable in the future
  static Future<bool> doesDirectoryExistRelatively(String relativePath) async {
    return Directory(await getAbsolutePath(relativePath)).exists();
  }

  static Future<String> getAbsolutePath(String? suffix) async {
    final documentsPath = await getApplicationDocumentsDirectory();
    if (suffix == null) return documentsPath.path;
    var resolvedSuffix = suffix;
    if (suffix[0] == '/') {
      resolvedSuffix = suffix.substring(1);
    }
    return '$documentsPath/$resolvedSuffix';
  }
}
