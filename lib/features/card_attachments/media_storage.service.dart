import 'dart:io';
import 'dart:typed_data';

import 'package:boo_mondai/features/card_attachments/helpers/mime.helper.dart';
import 'package:path_provider/path_provider.dart';

class MediaStorageService {
  const MediaStorageService._();

  static Future<String> saveMediaLocally({
    required String attachmentId,
    required Uint8List bytes,
    required String mimeType,
  }) async {
    final documents = await getApplicationDocumentsDirectory();
    final directory = Directory('${documents.path}/media');
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    final extension = MimeHelper.extensionFromMimeType(mimeType);
    final file = File('${directory.path}/$attachmentId.$extension');
    await file.writeAsBytes(bytes, flush: true);
    return file.absolute.path;
  }

  static Future<void> deleteMediaLocally(String localPath) async {
    final file = File(localPath);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
