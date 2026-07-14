final class FolderPath {
  const FolderPath(this.value);

  final String value;

  List<String> get segments {
    return value
        .split(RegExp(r'[/\\]+'))
        .where((segment) => segment.trim().isNotEmpty)
        .toList(growable: false);
  }

  String get folderPath {
    final pathSegments = segments;
    if (pathSegments.length <= 1) return '';
    return pathSegments.take(pathSegments.length - 1).join('/');
  }

  String get name {
    final pathSegments = segments;
    if (pathSegments.isEmpty) return '';
    return pathSegments.last;
  }
}
