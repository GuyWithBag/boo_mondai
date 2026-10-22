import 'package:dart_mappable/dart_mappable.dart';

part 'comment.edit_log.dto.mapper.dart';

@MappableClass()
class CommentEditLog with CommentEditLogMappable {
  final String id;
  final String oldBody;
  final String newBody;
  final String contentId;

  const CommentEditLog({
    required this.id,
    required this.oldBody,
    required this.newBody,
    required this.contentId,
  });
}
