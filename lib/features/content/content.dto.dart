import 'package:dart_mappable/dart_mappable.dart';

part 'content.dto.mapper.dart';

@MappableClass()
class Content with ContentMappable {
  final String id;
  final String profiledId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Content({
    required this.id,
    required this.profiledId,
    required this.createdAt,
    required this.updatedAt,
  });
}
