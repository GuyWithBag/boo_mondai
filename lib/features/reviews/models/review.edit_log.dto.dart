import 'package:boo_mondai/features/profile/models/cached_profile.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'review.edit_log.dto.mapper.dart';

@MappableClass()
class ReviewEditLog with ReviewEditLogMappable {
  final String id;
  final String reviewId;
  final String editedBy;
  final int oldVoteValueAtCreation;
  final int newVoteValueAtCreation;
  final String oldTitle;
  final String newTitle;
  final String oldBody;
  final String newBody;
  final DateTime editedAt;
  final CachedProfile? editorProfile;

  const ReviewEditLog({
    required this.id,
    required this.reviewId,
    required this.editedBy,
    required this.oldVoteValueAtCreation,
    required this.newVoteValueAtCreation,
    required this.oldTitle,
    required this.newTitle,
    required this.oldBody,
    required this.newBody,
    required this.editedAt,
    this.editorProfile,
  });
}
