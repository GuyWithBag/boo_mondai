import 'package:boo_mondai/features/profile/models/cached_profile.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'comment.dto.mapper.dart';

@MappableClass()
class Comment with CommentMappable {
  final String id;
  final String contentId;
  final String profileId;
  final String? parentCommentId;
  final String body;
  final bool isDeleted;
  final CachedProfile? userProfile;

  const Comment({
    required this.id,
    required this.profileId,
    this.parentCommentId,
    required this.body,
    this.isDeleted = false,
    this.userProfile,
    required this.contentId,
  });
}
