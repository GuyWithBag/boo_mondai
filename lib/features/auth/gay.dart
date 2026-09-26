import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/services.dart';

part 'gay.mapper.dart';

@MappableClass()
class Gay with GayMappable {
  final Uint8List bytes;
  final String filePath;
  final String profileId;

  Gay({required this.profileId, required this.bytes, required this.filePath});
}
