import 'package:boo_mondai/lib.barrel.dart' show FileHelper;

final class StoredMediaPath {
  const StoredMediaPath.app({required this.name})
    : folderPath = 'stored_medias',
      isApp = true;

  const StoredMediaPath.folder({required this.folderPath, required this.name})
    : isApp = false;

  final String folderPath;
  final String name;
  final bool isApp;

  List<String> get folderSegments {
    return folderPath
        .split(RegExp(r'[/\\]+'))
        .map(FileHelper.toAppropriateFileName)
        .where((segment) => segment.isNotEmpty)
        .toList();
  }

  String relativePath(String extension) {
    return '${relativePathPrefix()}.$extension';
  }

  String id(String extension) {
    if (isApp) return FileHelper.toAppropriateFileName(name);
    return relativePath(extension);
  }

  String relativePathPrefix() {
    return [
      ...folderSegments,
      FileHelper.toAppropriateFileName(name),
    ].join('/');
  }

  String fileName(String extension) {
    final normalizedExtension = extension.trim().replaceFirst(
      RegExp(r'^\.+'),
      '',
    );

    return '${FileHelper.toAppropriateFileName(name)}.$normalizedExtension';
  }
}
