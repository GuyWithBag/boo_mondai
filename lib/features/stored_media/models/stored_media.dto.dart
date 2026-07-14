import 'package:dart_mappable/dart_mappable.dart';

part 'stored_media.dto.mapper.dart';

@MappableClass()
class StoredMedia with StoredMediaMappable {
  final String id;
  final String localPath;
  final String? remoteUrl;
  final String? mimeType;
  final int? byteSize;
  final DateTime createdAt;
  final DateTime updatedAt;

  const StoredMedia({
    required this.id,
    required this.localPath,
    this.remoteUrl,
    this.mimeType,
    this.byteSize,
    required this.createdAt,
    required this.updatedAt,
  });
}
