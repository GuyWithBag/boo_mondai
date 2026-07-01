import 'package:dart_mappable/dart_mappable.dart';

part 'local_image_cache_entry.dto.mapper.dart';

@MappableClass()
class LocalImageCacheEntry with LocalImageCacheEntryMappable {
  final String cacheKey;
  final String localPath;
  final String? remotePath;
  final String? mimeType;
  final int? byteSize;
  final DateTime createdAt;
  final DateTime updatedAt;

  const LocalImageCacheEntry({
    required this.cacheKey,
    required this.localPath,
    this.remotePath,
    this.mimeType,
    this.byteSize,
    required this.createdAt,
    required this.updatedAt,
  });
}
