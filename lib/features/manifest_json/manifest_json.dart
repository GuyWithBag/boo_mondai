import 'dart:io';

abstract class ManifestJson<TConfig, VManifestPaths> {
  final TConfig config;
  final VManifestPaths paths;

  final File file;

  ManifestJson({
    required this.config,
    required this.paths,
    required this.file,
  }) {
    if (!file.existsSync()) {
      throw FileSystemException('Manifest file does not exist', file.path);
    }
  }
}
