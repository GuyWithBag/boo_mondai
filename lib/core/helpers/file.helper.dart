abstract final class FileHelper {
  static String toSanitizedFileName(String value) =>
      value.replaceAll(RegExp(r'[^A-Za-z0-9_.-]'), '_');

  static String fileNameWithoutExtension(String fileName) {
    final normalized = fileName.trim().split(RegExp(r'[/\\]+')).last;
    final dotIndex = normalized.lastIndexOf('.');
    final name = dotIndex <= 0 ? normalized : normalized.substring(0, dotIndex);
    return toSanitizedFileName(name.isEmpty ? 'media' : name);
  }

  static String? getExtension(String filePath) {
    final uri = Uri.tryParse(filePath.trim());
    final path = uri?.path.trim().isNotEmpty == true ? uri!.path : filePath;
    final fileName = path.trim().split(RegExp(r'[/\\]+')).last;
    final dotIndex = fileName.lastIndexOf('.');
    if (dotIndex <= 0 || dotIndex == fileName.length - 1) return null;
    return fileName.substring(dotIndex + 1).toLowerCase();
  }
}
