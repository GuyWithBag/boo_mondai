import 'dart:ffi';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/services.dart';

part 'cached_media.mapper.dart';

@MappableClass()
class CachedMedia with CachedMediaMappable {
  final Uint8List bytes;
  final String path;
  final String profileId;

  CachedMedia({
    required this.bytes,
    required this.path,
    required this.profileId,
  });
}
