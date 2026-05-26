import 'package:boo_mondai/features/profile/models/cached_profile.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'deck_vote_review_comment_edit_log.dto.mapper.dart';

@MappableClass()
class DeckVoteReviewCommentEditLog with DeckVoteReviewCommentEditLogMappable {
  final String id;
  final String commentId;
  final String editedBy;
  final String oldBody;
  final String newBody;
  final DateTime editedAt;
  final CachedProfile? editorProfile;

  const DeckVoteReviewCommentEditLog({
    required this.id,
    required this.commentId,
    required this.editedBy,
    required this.oldBody,
    required this.newBody,
    required this.editedAt,
    this.editorProfile,
  });
}
