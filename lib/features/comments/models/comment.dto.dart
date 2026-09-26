import 'package:boo_mondai/lib.barrel.dart' show WithContent;
import 'package:dart_mappable/dart_mappable.dart';

part 'comment.dto.mapper.dart';

@MappableClass()
class Comment with CommentMappable implements WithContent {
  final String id;
  @override
  final String contentId;
  final String body;
  final DateTime deletedAt;

  const Comment({
    required this.id,
    required this.body,
    required this.contentId,
    required this.deletedAt,
  });
}
