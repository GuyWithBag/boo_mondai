import 'package:boo_mondai/features/profile/models/cached_profile.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'review.dto.mapper.dart';

@MappableClass()
class Review with ReviewMappable {
  final String id;
  final String contentId;
  final String profileId;
  final String title;
  final String body;
  final bool isDeleted;
  final CachedProfile? userProfile;

  const Review({
    required this.id,
    required this.profileId,
    this.title = '',
    required this.body,
    this.isDeleted = false,
    this.userProfile,
    required this.contentId,
  });
}
