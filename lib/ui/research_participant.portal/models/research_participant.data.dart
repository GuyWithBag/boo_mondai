import 'package:boo_mondai/lib.barrel.dart'
    show DecksDirectoryPaths, FileSystemHandler, Profile;
import 'package:flutter/services.dart' show AssetManifest, rootBundle;
import 'package:path/path.dart' as p;

abstract class ResearchParticipantData {
  static const idPrefix = '';

  String get participantDeckId;

  Future<void> initialize(Profile profile);

  Future<void> copyAttachmentAssets({
    required String assetDirectory,
    required String deckTitle,
  }) async {
    final normalizedAssetDirectory = assetDirectory.endsWith('/')
        ? assetDirectory
        : '$assetDirectory/';
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final assetPaths = manifest
        .listAssets()
        .where((path) => path.startsWith(normalizedAssetDirectory))
        .toList(growable: false);

    for (final assetPath in assetPaths) {
      final bytes = await rootBundle.load(assetPath);
      await FileSystemHandler.storeBytes(
        path: DecksDirectoryPaths.attachment(
          deckTitle: deckTitle,
          fileName: p.posix.basename(assetPath),
        ),
        bytes: bytes.buffer.asUint8List(
          bytes.offsetInBytes,
          bytes.lengthInBytes,
        ),
      );
    }
  }
}
