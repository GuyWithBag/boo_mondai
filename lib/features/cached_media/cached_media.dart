import 'package:flutter/services.dart';

import 'package:dart_mappable/dart_mappable.dart';

part 'cached_media.mapper.dart';

@MappableClass()
class CachedMedia with CachedMediaMappable {
  final Uint8List bytes;
  final String filePath;
  final String profileId;

  CachedMedia({
    required this.bytes,
    required this.filePath,
    required this.profileId,
  });
}
