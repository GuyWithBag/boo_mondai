import 'package:boo_mondai/features/comments/models/comment.edit_log.dto.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'review.edit_log.dto.mapper.dart';

@MappableClass()
class ReviewEditLog with ReviewEditLogMappable implements CommentEditLog {
  @override
  final String id;
  @override
  final String contentId;
  @override
  final String oldBody;
  @override
  final String newBody;

  final String oldTitle;
  final String newTitle;

  const ReviewEditLog({
    required this.id,
    required this.contentId,
    required this.oldTitle,
    required this.newTitle,
    required this.oldBody,
    required this.newBody,
  });
}
