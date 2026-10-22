import 'package:boo_mondai/features/content/models/content.type.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'content.dto.mapper.dart';

@MappableClass()
class Content with ContentMappable {
  final String id;
  final String profileId;
  final String? parentContentId;
  final ContentType type;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool hasVotes;
  final DateTime? deletedAt;
  final DateTime? purgeAfter;

  Content({
    required this.id,
    required this.profileId,
    required this.createdAt,
    required this.updatedAt,
    this.hasVotes = true,
    this.parentContentId,
    required this.type,
    this.deletedAt,
    this.purgeAfter,
  });
}
