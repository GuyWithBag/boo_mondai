import 'package:boo_mondai/features/profile/models/cached_profile.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'deck_comment.dto.mapper.dart';

@MappableClass()
class DeckComment with DeckCommentMappable {
  final String id;
  final String deckId;
  final String userId;
  final String? parentCommentId;
  final String body;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final CachedProfile? userProfile;

  const DeckComment({
    required this.id,
    required this.deckId,
    required this.userId,
    this.parentCommentId,
    required this.body,
    this.isDeleted = false,
    required this.createdAt,
    required this.updatedAt,
    this.userProfile,
  });

  factory DeckComment.createNow({
    required String id,
    required String deckId,
    required String userId,
    String? parentCommentId,
    required String body,
  }) {
    final now = DateTime.now();
    return DeckComment(
      id: id,
      deckId: deckId,
      userId: userId,
      parentCommentId: parentCommentId,
      body: body,
      createdAt: now,
      updatedAt: now,
    );
  }
}
