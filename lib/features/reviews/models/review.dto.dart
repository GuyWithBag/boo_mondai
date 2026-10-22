import 'package:boo_mondai/features/comments/comments.barrel.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'review.dto.mapper.dart';

@MappableClass()
class Review with ReviewMappable implements Comment {
  @override
  final String id;
  @override
  final String contentId;
  @override
  final String body;
  @override
  final DateTime deletedAt;
  final String title;
  final bool isNegative;

  const Review({
    required this.id,
    required this.contentId,
    required this.title,
    required this.body,
    required this.deletedAt,
    this.isNegative = false,
  });
}
